import {
  BookOpen,
  Clock,
  Download,
  Edit3,
  Headphones,
  Loader2,
  MoreHorizontal,
  PenTool,
  PlusCircle,
  Search,
  Trash2,
} from "lucide-react";
import type React from "react";
import { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { AdminLayout } from "@/components/AdminLayout";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Input } from "@/components/ui/input";
import { Skeleton } from "@/components/ui/skeleton";
import { toast } from "@/hooks/use-toast";
import { cn } from "@/lib/utils";
import { type ContentItem, deleteContent, exportContent, fetchAllContent } from "@/services/contentService";

const moduleIcons: Record<string, React.ElementType> = {
  Reading: BookOpen,
  Writing: PenTool,
  Listening: Headphones,
};

const moduleColors: Record<string, string> = {
  Reading: "text-blue-500",
  Writing: "text-amber-500",
  Listening: "text-rose-500",
};

const statusColors: Record<string, string> = {
  Draft: "bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400",
  Published: "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400",
  Archived: "bg-secondary text-muted-foreground",
};

const ContentLibrary: React.FC = () => {
  const navigate = useNavigate();
  const [search, setSearch] = useState("");
  const [filterModule, setFilterModule] = useState<string>("All");
  const [content, setContent] = useState<ContentItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [deleteTarget, setDeleteTarget] = useState<ContentItem | null>(null);
  const [deleting, setDeleting] = useState(false);
  const [exportingId, setExportingId] = useState<string | null>(null);

  const loadContent = async () => {
    setLoading(true);
    try {
      const data = await fetchAllContent();
      setContent(data);
    } catch {
      toast({ title: "Failed to load content", variant: "destructive" });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadContent();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleDelete = async () => {
    if (!deleteTarget) return;
    setDeleting(true);
    try {
      await deleteContent(deleteTarget.id, deleteTarget.module);
      setContent((prev) => prev.filter((c) => c.id !== deleteTarget.id));
      toast({ title: "Content deleted successfully" });
    } catch {
      toast({ title: "Failed to delete content", variant: "destructive" });
    } finally {
      setDeleting(false);
      setDeleteTarget(null);
    }
  };

  const handleEdit = (item: ContentItem) => {
    const type = item.module.toLowerCase();
    navigate(`/admin/create?type=${type}&id=${item.id}`);
  };

  const handleExport = async (item: ContentItem) => {
    setExportingId(item.id);
    try {
      const result = await exportContent(item);
      if (result === null) {
        return;
      }
      toast({
        title: "Export complete",
        description: `Saved ${result.fileName} to ${result.filePath}`,
      });
      if (result.warnings.length > 0) {
        toast({
          title: "Exported with missing resources",
          description: result.warnings.join(", "),
          variant: "destructive",
        });
      }
    } catch {
      toast({ title: "Failed to export content", variant: "destructive" });
    } finally {
      setExportingId(null);
    }
  };

  const filtered = content.filter((c) => {
    const matchSearch = c.title.toLowerCase().includes(search.toLowerCase());
    const matchModule = filterModule === "All" || c.module === filterModule;
    return matchSearch && matchModule;
  });

  const tabs = ["All", "Reading", "Writing", "Listening"];

  return (
    <AdminLayout>
      <div className="p-6 md:p-8 max-w-6xl mx-auto space-y-6">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <h1 className="text-2xl font-bold md:text-3xl">Content Library</h1>
            <p className="text-muted-foreground mt-1">Manage all your IELTS test content.</p>
          </div>
          <Button asChild className="gap-2 bg-violet-600 hover:bg-violet-700 text-white">
            <Link to="/admin/create">
              <PlusCircle className="h-4 w-4" /> Create New
            </Link>
          </Button>
        </div>

        {/* Filters */}
        <div className="flex flex-col sm:flex-row gap-3">
          <div className="relative flex-1 max-w-sm">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
            <Input
              placeholder="Search content..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="pl-9"
            />
          </div>
          <div className="inline-flex h-10 items-center rounded-lg bg-muted p-1 text-muted-foreground">
            {tabs.map((t) => (
              <button
                key={t}
                onClick={() => setFilterModule(t)}
                className={cn(
                  "px-4 py-1.5 rounded-md text-sm font-medium transition-all",
                  filterModule === t
                    ? "bg-background text-foreground shadow-sm"
                    : "hover:bg-accent hover:text-accent-foreground"
                )}
              >
                {t}
              </button>
            ))}
          </div>
        </div>

        {/* Table */}
        <Card>
          <CardContent className="p-0">
            <div className="divide-y divide-border">
              {/* Header */}
              <div className="grid grid-cols-12 gap-4 px-6 py-3 text-xs font-medium text-muted-foreground uppercase tracking-wider bg-muted/50">
                <div className="col-span-5">Title</div>
                <div className="col-span-2">Status</div>
                <div className="col-span-1 text-center">Qs</div>
                <div className="col-span-1">Band</div>
                <div className="col-span-2">Edited</div>
                <div className="col-span-1"></div>
              </div>

              {loading ? (
                Array.from({ length: 4 }).map((_, i) => (
                  <div key={i} className="grid grid-cols-12 gap-4 px-6 py-4 items-center">
                    <div className="col-span-5 flex items-center gap-3">
                      <Skeleton className="h-4 w-4 rounded" />
                      <div className="space-y-1.5 flex-1">
                        <Skeleton className="h-4 w-3/4" />
                        <Skeleton className="h-3 w-16" />
                      </div>
                    </div>
                    <div className="col-span-2">
                      <Skeleton className="h-5 w-16 rounded-full" />
                    </div>
                    <div className="col-span-1 text-center">
                      <Skeleton className="h-4 w-6 mx-auto" />
                    </div>
                    <div className="col-span-1">
                      <Skeleton className="h-4 w-8" />
                    </div>
                    <div className="col-span-2">
                      <Skeleton className="h-4 w-20" />
                    </div>
                    <div className="col-span-1">
                      <Skeleton className="h-8 w-8 ml-auto rounded" />
                    </div>
                  </div>
                ))
              ) : filtered.length === 0 ? (
                <div className="py-12 text-center text-muted-foreground">
                  {content.length === 0 ? "No content yet. Create your first test!" : "No content found."}
                </div>
              ) : (
                filtered.map((item) => {
                  const ModIcon = moduleIcons[item.module];
                  return (
                    <div
                      key={item.id}
                      className="grid grid-cols-12 gap-4 px-6 py-4 items-center hover:bg-muted/30 transition-colors"
                    >
                      <div className="col-span-5 flex items-center gap-3">
                        <ModIcon className={cn("h-4 w-4 shrink-0", moduleColors[item.module])} />
                        <div className="min-w-0">
                          <p className="text-sm font-semibold truncate">{item.title}</p>
                          <p className="text-xs text-muted-foreground">{item.module}</p>
                        </div>
                      </div>
                      <div className="col-span-2">
                        <Badge variant="secondary" className={cn("text-[10px]", statusColors[item.status])}>
                          {item.status}
                        </Badge>
                      </div>
                      <div className="col-span-1 text-center text-sm text-muted-foreground">{item.questions}</div>
                      <div className="col-span-1 text-sm text-muted-foreground">{item.band}</div>
                      <div className="col-span-2 text-xs text-muted-foreground flex items-center gap-1">
                        <Clock className="h-3 w-3" /> {item.lastEdited}
                      </div>
                      <div className="col-span-1 flex justify-end">
                        <DropdownMenu>
                          <DropdownMenuTrigger asChild>
                            <Button variant="ghost" size="icon" className="h-8 w-8">
                              <MoreHorizontal className="h-4 w-4" />
                            </Button>
                          </DropdownMenuTrigger>
                          <DropdownMenuContent align="end">
                            <DropdownMenuItem className="gap-2" onClick={() => handleEdit(item)}>
                              <Edit3 className="h-3.5 w-3.5" /> Edit
                            </DropdownMenuItem>
                            <DropdownMenuItem
                              className="gap-2"
                              disabled={exportingId === item.id}
                              onClick={() => handleExport(item)}
                            >
                              {exportingId === item.id ? (
                                <Loader2 className="h-3.5 w-3.5 animate-spin" />
                              ) : (
                                <Download className="h-3.5 w-3.5" />
                              )}
                              Export
                            </DropdownMenuItem>
                            <DropdownMenuItem className="gap-2 text-destructive" onClick={() => setDeleteTarget(item)}>
                              <Trash2 className="h-3.5 w-3.5" /> Delete
                            </DropdownMenuItem>
                          </DropdownMenuContent>
                        </DropdownMenu>
                      </div>
                    </div>
                  );
                })
              )}
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Delete Confirmation */}
      <AlertDialog open={!!deleteTarget} onOpenChange={(open) => !open && setDeleteTarget(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete "{deleteTarget?.title}"?</AlertDialogTitle>
            <AlertDialogDescription>
              This will permanently delete this {deleteTarget?.module.toLowerCase()} test and all its associated
              content. This action cannot be undone.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={deleting}>Cancel</AlertDialogCancel>
            <AlertDialogAction
              onClick={handleDelete}
              disabled={deleting}
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
            >
              {deleting ? (
                <>
                  <Loader2 className="h-4 w-4 animate-spin mr-2" /> Deleting...
                </>
              ) : (
                "Delete"
              )}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </AdminLayout>
  );
};

export default ContentLibrary;
