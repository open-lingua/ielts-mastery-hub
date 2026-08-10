import React, { useState, useEffect, useCallback, useMemo } from "react";
import { motion, AnimatePresence } from "framer-motion";
import {
  Search,
  Edit2,
  Trash2,
  Ban,
  Users,
  MoreHorizontal,
  AlertTriangle,
  ShieldAlert,
  Loader2,
  RefreshCw,
} from "lucide-react";
import { AdminLayout } from "@/components/AdminLayout";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
  DialogClose,
} from "@/components/ui/dialog";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Separator } from "@/components/ui/separator";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Skeleton } from "@/components/ui/skeleton";
import { listProfiles, listUserRoles, updateProfile, deleteProfile, createUserRole, deleteUserRole } from "@/lib/tauri";
import { toast } from "sonner";
import { formatDistanceToNow } from "date-fns";

// ── Types ──────────────────────────────────────────────────
interface UserRow {
  id: string;
  full_name: string | null;
  email: string | null;
  avatar_url: string | null;
  plan_type: string | null;
  is_banned: boolean;
  ban_reason: string | null;
  banned_until: string | null;
  updated_at: string | null;
  role: string;
}

type ModalType = "edit" | "delete" | "ban" | null;

const ROWS_PER_PAGE = 10;

// ── Status / Plan Badges ───────────────────────────────────
const StatusBadge: React.FC<{ isBanned: boolean }> = ({ isBanned }) => (
  <Badge
    variant="outline"
    className={
      !isBanned
        ? "border-emerald-500/30 bg-emerald-500/10 text-emerald-700 dark:text-emerald-400"
        : "border-rose-500/30 bg-rose-500/10 text-rose-700 dark:text-rose-400"
    }
  >
    {isBanned ? "Banned" : "Active"}
  </Badge>
);

const PlanBadge: React.FC<{ plan: string }> = ({ plan }) => {
  const isPremium = plan?.toLowerCase() === "premium";
  return (
    <Badge
      variant="outline"
      className={
        isPremium
          ? "border-amber-500/30 bg-amber-500/10 text-amber-700 dark:text-amber-400"
          : "border-border bg-muted text-muted-foreground"
      }
    >
      {isPremium ? "Premium" : "Free"}
    </Badge>
  );
};

const RoleBadge: React.FC<{ role: string }> = ({ role }) => (
  <Badge
    variant="outline"
    className={
      role === "super_admin"
        ? "border-violet-500/30 bg-violet-500/10 text-violet-700 dark:text-violet-400"
        : "border-border bg-muted text-muted-foreground"
    }
  >
    {role === "super_admin" ? "Admin" : "Student"}
  </Badge>
);

const TableSkeleton = () => (
  <>
    {Array.from({ length: ROWS_PER_PAGE }).map((_, i) => (
      <TableRow key={i}>
        <TableCell>
          <div className="flex items-center gap-3">
            <Skeleton className="h-8 w-8 rounded-full" />
            <div className="space-y-1.5">
              <Skeleton className="h-3.5 w-28" />
              <Skeleton className="h-3 w-36" />
            </div>
          </div>
        </TableCell>
        <TableCell><Skeleton className="h-5 w-14" /></TableCell>
        <TableCell><Skeleton className="h-5 w-14" /></TableCell>
        <TableCell className="hidden md:table-cell"><Skeleton className="h-4 w-20" /></TableCell>
        <TableCell><Skeleton className="h-5 w-14" /></TableCell>
        <TableCell className="text-right"><Skeleton className="h-8 w-8 ml-auto" /></TableCell>
      </TableRow>
    ))}
  </>
);

// ── Page Component ─────────────────────────────────────────
const UserManagement: React.FC = () => {
  const [users, setUsers] = useState<UserRow[]>([]);
  const [totalCount, setTotalCount] = useState(0);
  const [isLoading, setIsLoading] = useState(true);
  const [isMutating, setIsMutating] = useState(false);
  const [search, setSearch] = useState("");
  const [debouncedSearch, setDebouncedSearch] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [activeModal, setActiveModal] = useState<ModalType>(null);
  const [selectedUser, setSelectedUser] = useState<UserRow | null>(null);

  // Edit form state
  const [editName, setEditName] = useState("");
  const [editPlan, setEditPlan] = useState("free");
  const [editRole, setEditRole] = useState("student");

  // Ban form state
  const [banReason, setBanReason] = useState("");
  const [banDuration, setBanDuration] = useState<"temporary" | "permanent">("temporary");

  // Debounce search
  useEffect(() => {
    const timer = setTimeout(() => {
      setDebouncedSearch(search);
      setCurrentPage(1);
    }, 300);
    return () => clearTimeout(timer);
  }, [search]);

  // Fetch all profiles client-side, then paginate + search locally
  const fetchUsers = useCallback(async () => {
    setIsLoading(true);
    try {
      const allProfiles = await listProfiles();

      // Client-side search
      const filtered = debouncedSearch
        ? allProfiles.filter((p) => {
            const q = debouncedSearch.toLowerCase();
            return (
              (p.full_name ?? "").toLowerCase().includes(q) ||
              (p.email ?? "").toLowerCase().includes(q)
            );
          })
        : allProfiles;

      // Sort by updated_at descending
      filtered.sort((a, b) => new Date(b.updated_at).getTime() - new Date(a.updated_at).getTime());

      setTotalCount(filtered.length);

      // Client-side pagination
      const from = (currentPage - 1) * ROWS_PER_PAGE;
      const page = filtered.slice(from, from + ROWS_PER_PAGE);

      // Fetch roles for this page of users in parallel
      const roleResults = await Promise.all(page.map((p) => listUserRoles(p.id).catch(() => [])));
      const roleMap = new Map<string, string>();
      page.forEach((p, i) => {
        const role = roleResults[i]?.[0]?.role ?? "student";
        roleMap.set(p.id, role);
      });

      const merged: UserRow[] = page.map((p) => ({
        id: p.id,
        full_name: p.full_name,
        email: p.email,
        avatar_url: p.avatar_url,
        plan_type: p.plan_type,
        is_banned: p.is_banned ?? false,
        ban_reason: p.ban_reason,
        banned_until: p.banned_until,
        updated_at: p.updated_at,
        role: roleMap.get(p.id) ?? "student",
      }));

      setUsers(merged);
    } catch (err) {
      toast.error("Failed to load users");
      console.error(err);
    } finally {
      setIsLoading(false);
    }
  }, [currentPage, debouncedSearch]);

  useEffect(() => {
    fetchUsers();
  }, [fetchUsers]);

  const totalPages = Math.max(1, Math.ceil(totalCount / ROWS_PER_PAGE));

  // Open modals
  const openModal = (type: ModalType, user: UserRow) => {
    setSelectedUser(user);
    setActiveModal(type);
    if (type === "edit") {
      setEditName(user.full_name ?? "");
      setEditPlan(user.plan_type ?? "free");
      setEditRole(user.role);
    }
    if (type === "ban") {
      setBanReason("");
      setBanDuration("temporary");
    }
  };

  const closeModal = () => {
    setActiveModal(null);
    setSelectedUser(null);
  };

  // ── Actions ──────────────────────────────────────────────
  const handleEdit = async () => {
    if (!selectedUser) return;
    setIsMutating(true);
    try {
      await updateProfile(selectedUser.id, { full_name: editName.trim(), plan_type: editPlan });

      if (editRole !== selectedUser.role) {
        const existingRoles = await listUserRoles(selectedUser.id);
        await Promise.all(existingRoles.map((r) => deleteUserRole(r.id, selectedUser.id)));
        await createUserRole({ user_id: selectedUser.id, role: editRole });
      }

      toast.success("User updated successfully");
      closeModal();
      fetchUsers();
    } catch (err) {
      toast.error("Failed to update user");
      console.error(err);
    } finally {
      setIsMutating(false);
    }
  };

  const handleDelete = async () => {
    if (!selectedUser) return;
    setIsMutating(true);
    try {
      await deleteProfile(selectedUser.id);
      toast.success("User deleted");
      closeModal();
      fetchUsers();
    } catch (err) {
      toast.error("Failed to delete user");
      console.error(err);
    } finally {
      setIsMutating(false);
    }
  };

  const handleBan = async () => {
    if (!selectedUser || !banReason.trim()) return;
    setIsMutating(true);
    try {
      const bannedUntil =
        banDuration === "permanent"
          ? null
          : new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString();

      await updateProfile(selectedUser.id, {
        is_banned: true,
        ban_reason: banReason.trim(),
        banned_until: bannedUntil,
      });

      toast.success(`${selectedUser.full_name ?? "User"} has been banned`);
      closeModal();
      fetchUsers();
    } catch (err) {
      toast.error("Failed to ban user");
      console.error(err);
    } finally {
      setIsMutating(false);
    }
  };

  // Page numbers
  const pageNumbers = useMemo(() => {
    const pages: number[] = [];
    for (let i = 1; i <= totalPages; i++) pages.push(i);
    if (pages.length <= 5) return pages;
    if (currentPage <= 3) return [1, 2, 3, 4, 5];
    if (currentPage >= totalPages - 2)
      return [totalPages - 4, totalPages - 3, totalPages - 2, totalPages - 1, totalPages];
    return [currentPage - 2, currentPage - 1, currentPage, currentPage + 1, currentPage + 2];
  }, [currentPage, totalPages]);

  const rangeStart = (currentPage - 1) * ROWS_PER_PAGE + 1;
  const rangeEnd = Math.min(currentPage * ROWS_PER_PAGE, totalCount);

  return (
    <AdminLayout>
      <div className="p-6 lg:p-8 max-w-7xl mx-auto space-y-6">
        {/* Header */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <div>
            <h1 className="text-2xl font-bold text-foreground">User Management</h1>
            <p className="text-sm text-muted-foreground mt-1 flex items-center gap-1.5">
              <Users className="h-4 w-4" />
              Total Students: {totalCount.toLocaleString()}
            </p>
          </div>
          <div className="flex items-center gap-2">
            <Button variant="outline" size="icon" onClick={fetchUsers} disabled={isLoading}>
              <RefreshCw className={`h-4 w-4 ${isLoading ? "animate-spin" : ""}`} />
            </Button>
            <div className="relative w-full sm:w-72">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Search by name or email…"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                className="pl-9"
              />
            </div>
          </div>
        </div>

        {/* Table */}
        <div className="rounded-lg border border-border bg-card overflow-hidden">
          <Table>
            <TableHeader>
              <TableRow className="bg-muted/40">
                <TableHead className="min-w-[220px]">User</TableHead>
                <TableHead>Role</TableHead>
                <TableHead>Plan</TableHead>
                <TableHead className="hidden md:table-cell">Last Updated</TableHead>
                <TableHead>Status</TableHead>
                <TableHead className="text-right w-[100px]">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {isLoading ? (
                <TableSkeleton />
              ) : (
                <AnimatePresence mode="popLayout">
                  {users.map((user) => (
                    <motion.tr
                      key={user.id}
                      layout
                      initial={{ opacity: 0, y: 6 }}
                      animate={{ opacity: 1, y: 0 }}
                      exit={{ opacity: 0, y: -6 }}
                      transition={{ duration: 0.15 }}
                      className="border-b border-border transition-colors hover:bg-muted/30"
                    >
                      <TableCell>
                        <div className="flex items-center gap-3">
                          <Avatar className="h-8 w-8">
                            <AvatarFallback className="bg-violet-100 text-violet-700 dark:bg-violet-900/40 dark:text-violet-300 text-xs font-medium">
                              {(user.full_name ?? "U")
                                .split(" ")
                                .map((n) => n[0])
                                .join("")
                                .slice(0, 2)
                                .toUpperCase()}
                            </AvatarFallback>
                          </Avatar>
                          <div className="min-w-0">
                            <p className="text-sm font-medium text-foreground truncate">
                              {user.full_name ?? "Unknown"}
                            </p>
                            <p className="text-xs text-muted-foreground truncate">{user.email}</p>
                          </div>
                        </div>
                      </TableCell>
                      <TableCell>
                        <RoleBadge role={user.role} />
                      </TableCell>
                      <TableCell>
                        <PlanBadge plan={user.plan_type ?? "free"} />
                      </TableCell>
                      <TableCell className="hidden md:table-cell text-sm text-muted-foreground">
                        {user.updated_at
                          ? formatDistanceToNow(new Date(user.updated_at), { addSuffix: true })
                          : "—"}
                      </TableCell>
                      <TableCell>
                        <StatusBadge isBanned={user.is_banned} />
                      </TableCell>
                      <TableCell className="text-right">
                        <DropdownMenu>
                          <DropdownMenuTrigger asChild>
                            <Button variant="ghost" size="icon" className="h-8 w-8">
                              <MoreHorizontal className="h-4 w-4" />
                            </Button>
                          </DropdownMenuTrigger>
                          <DropdownMenuContent align="end" className="w-40">
                            <DropdownMenuItem onClick={() => openModal("edit", user)}>
                              <Edit2 className="h-4 w-4 mr-2 text-blue-500" /> Edit
                            </DropdownMenuItem>
                            <DropdownMenuItem onClick={() => openModal("ban", user)}>
                              <Ban className="h-4 w-4 mr-2 text-amber-500" />
                              {user.is_banned ? "Update Ban" : "Ban"}
                            </DropdownMenuItem>
                            <DropdownMenuItem
                              onClick={() => openModal("delete", user)}
                              className="text-destructive focus:text-destructive"
                            >
                              <Trash2 className="h-4 w-4 mr-2" /> Delete
                            </DropdownMenuItem>
                          </DropdownMenuContent>
                        </DropdownMenu>
                      </TableCell>
                    </motion.tr>
                  ))}
                </AnimatePresence>
              )}
              {!isLoading && users.length === 0 && (
                <TableRow>
                  <TableCell colSpan={6} className="text-center py-12 text-muted-foreground">
                    No users found.
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </div>

        {/* Pagination Footer */}
        <div className="flex flex-col sm:flex-row items-center justify-between gap-3 text-sm">
          <p className="text-muted-foreground">
            Showing {totalCount > 0 ? rangeStart : 0}–{rangeEnd} of {totalCount} users
          </p>
          <div className="flex items-center gap-1">
            <Button
              variant="outline"
              size="sm"
              disabled={currentPage === 1}
              onClick={() => setCurrentPage((p) => p - 1)}
            >
              Previous
            </Button>
            {pageNumbers.map((n) => (
              <Button
                key={n}
                variant={n === currentPage ? "default" : "outline"}
                size="sm"
                className="w-9"
                onClick={() => setCurrentPage(n)}
              >
                {n}
              </Button>
            ))}
            <Button
              variant="outline"
              size="sm"
              disabled={currentPage === totalPages}
              onClick={() => setCurrentPage((p) => p + 1)}
            >
              Next
            </Button>
          </div>
        </div>
      </div>

      {/* ── Edit Modal ────────────────────────────────────── */}
      <Dialog open={activeModal === "edit"} onOpenChange={(o) => !o && closeModal()}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>Edit User</DialogTitle>
            <DialogDescription>Update details for {selectedUser?.full_name ?? "this user"}.</DialogDescription>
          </DialogHeader>
          <div className="space-y-4 py-2">
            <div className="space-y-2">
              <Label htmlFor="edit-name">Name</Label>
              <Input id="edit-name" value={editName} onChange={(e) => setEditName(e.target.value)} />
            </div>
            <div className="space-y-2">
              <Label>Plan</Label>
              <Select value={editPlan} onValueChange={setEditPlan}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="free">Free</SelectItem>
                  <SelectItem value="premium">Premium</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>Role</Label>
              <Select value={editRole} onValueChange={setEditRole}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="student">Student</SelectItem>
                  <SelectItem value="super_admin">Super Admin</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
          <DialogFooter>
            <DialogClose asChild>
              <Button variant="outline">Cancel</Button>
            </DialogClose>
            <Button onClick={handleEdit} disabled={isMutating}>
              {isMutating && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
              Save Changes
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* ── Delete Modal ──────────────────────────────────── */}
      <Dialog open={activeModal === "delete"} onOpenChange={(o) => !o && closeModal()}>
        <DialogContent className="sm:max-w-sm">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2 text-destructive">
              <AlertTriangle className="h-5 w-5" /> Delete User
            </DialogTitle>
            <DialogDescription>
              You are about to permanently delete <strong>{selectedUser?.full_name ?? "this user"}</strong>. This action
              cannot be undone.
            </DialogDescription>
          </DialogHeader>
          <Separator />
          <DialogFooter>
            <DialogClose asChild>
              <Button variant="outline">Cancel</Button>
            </DialogClose>
            <Button variant="destructive" onClick={handleDelete} disabled={isMutating}>
              {isMutating && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
              Delete Permanently
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* ── Ban Modal ─────────────────────────────────────── */}
      <Dialog open={activeModal === "ban"} onOpenChange={(o) => !o && closeModal()}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <ShieldAlert className="h-5 w-5 text-amber-500" /> Ban User
            </DialogTitle>
            <DialogDescription>
              Banning <strong>{selectedUser?.full_name ?? "this user"}</strong> will restrict their access.
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4 py-2">
            <div className="space-y-2">
              <Label>Reason for Ban</Label>
              <Textarea
                placeholder="Provide a reason…"
                value={banReason}
                onChange={(e) => setBanReason(e.target.value)}
                rows={3}
              />
            </div>
            <div className="space-y-2">
              <Label>Duration</Label>
              <Select
                value={banDuration}
                onValueChange={(v) => setBanDuration(v as "temporary" | "permanent")}
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="temporary">Temporary (30 days)</SelectItem>
                  <SelectItem value="permanent">Permanent</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
          <DialogFooter>
            <DialogClose asChild>
              <Button variant="outline">Cancel</Button>
            </DialogClose>
            <Button
              variant="destructive"
              onClick={handleBan}
              disabled={!banReason.trim() || isMutating}
            >
              {isMutating && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
              Confirm Ban
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </AdminLayout>
  );
};

export default UserManagement;
