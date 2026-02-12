import React, { useState } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import { BookOpen, PenTool, Headphones, LayoutDashboard, Moon, Sun, Menu, LogOut, UserPlus, ChevronLeft, ChevronRight, Library } from "lucide-react";
import { useTheme } from "@/contexts/ThemeContext";
import { useAuth } from "@/contexts/AuthContext";
import { cn } from "@/lib/utils";
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@/components/ui/tooltip";

const navItems = [
  { label: "Dashboard", path: "/dashboard", icon: LayoutDashboard },
  { label: "Test Library", path: "/tests", icon: Library },
  { label: "Writing", path: "/writing", icon: PenTool },
  { label: "Reading", path: "/reading", icon: BookOpen },
  { label: "Listening", path: "/listening", icon: Headphones },
];

export const DashboardLayout: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { theme, toggleTheme } = useTheme();
  const { user, logout } = useAuth();
  const location = useLocation();
  const navigate = useNavigate();
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [collapsed, setCollapsed] = useState(false);

  const isGuest = !user;
  const initials = user?.name
    ? user.name.split(" ").map((n) => n[0]).join("").toUpperCase().slice(0, 2)
    : "G";

  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  return (
    <div className="flex h-screen overflow-hidden bg-background">
      {/* Mobile overlay */}
      {sidebarOpen && (
        <div className="fixed inset-0 z-40 bg-foreground/20 backdrop-blur-sm md:hidden" onClick={() => setSidebarOpen(false)} />
      )}

      {/* Sidebar */}
      <aside
        className={cn(
          "fixed inset-y-0 left-0 z-50 flex flex-col border-r border-border bg-card transition-all duration-300 ease-in-out md:static md:translate-x-0",
          sidebarOpen ? "translate-x-0" : "-translate-x-full",
          collapsed ? "w-[70px]" : "w-64"
        )}
      >
        {/* Brand */}
        <div className={cn(
          "flex h-16 items-center border-b border-border transition-all duration-300",
          collapsed ? "justify-center px-2" : "gap-2 px-6"
        )}>
          <BookOpen className="h-6 w-6 shrink-0 text-primary" />
          {!collapsed && (
            <>
              <span className="text-lg font-bold text-primary">IELTS</span>
              <span className="text-lg font-medium text-foreground">Mastery Hub</span>
            </>
          )}
        </div>

        {/* Nav */}
        <TooltipProvider delayDuration={0}>
          <nav className={cn("flex-1 space-y-1 p-4 transition-all duration-300", collapsed && "px-2")}>
            {navItems.map((item) => {
              const isActive = location.pathname === item.path;
              const linkContent = (
                <Link
                  key={item.path}
                  to={item.path}
                  onClick={() => setSidebarOpen(false)}
                  className={cn(
                    "flex items-center rounded-xl text-sm font-medium transition-colors",
                    collapsed ? "justify-center px-0 py-3" : "gap-3 px-4 py-3",
                    isActive
                      ? "bg-primary text-primary-foreground shadow-md"
                      : "text-muted-foreground hover:bg-secondary hover:text-foreground"
                  )}
                >
                  <item.icon className="h-5 w-5 shrink-0" />
                  {!collapsed && <span className="truncate">{item.label}</span>}
                </Link>
              );

              if (collapsed) {
                return (
                  <Tooltip key={item.path}>
                    <TooltipTrigger asChild>{linkContent}</TooltipTrigger>
                    <TooltipContent side="right" sideOffset={8}>
                      {item.label}
                    </TooltipContent>
                  </Tooltip>
                );
              }

              return linkContent;
            })}
          </nav>
        </TooltipProvider>

        {/* Premium CTA - hide when collapsed */}
        {!collapsed && (
          <div className="border-t border-border p-4">
            <div className="rounded-xl bg-primary/10 p-4">
              <p className="text-sm font-semibold text-foreground">Go Premium ✨</p>
              <p className="mt-1 text-xs text-muted-foreground">Unlock unlimited practice & AI feedback</p>
              <Link
                to="/#pricing"
                className="mt-3 block rounded-lg bg-warning px-3 py-2 text-center text-xs font-bold text-warning-foreground transition-transform hover:scale-105"
              >
                Upgrade Now
              </Link>
            </div>
          </div>
        )}

        {/* Collapse toggle */}
        <div className={cn("hidden md:flex border-t border-border p-3", collapsed ? "justify-center" : "justify-end")}>
          <button
            onClick={() => setCollapsed((prev) => !prev)}
            aria-label="Toggle Sidebar"
            className="rounded-lg border border-border p-2 text-muted-foreground transition-colors hover:bg-secondary hover:text-foreground"
          >
            {collapsed ? <ChevronRight className="h-4 w-4" /> : <ChevronLeft className="h-4 w-4" />}
          </button>
        </div>
      </aside>

      {/* Main content */}
      <div className="flex flex-1 flex-col overflow-hidden">
        {/* Top bar */}
        <header className="flex h-16 items-center justify-between border-b border-border bg-card px-4 md:px-6">
          <button
            onClick={() => setSidebarOpen(true)}
            className="rounded-lg p-2 text-muted-foreground hover:bg-secondary md:hidden"
          >
            <Menu className="h-5 w-5" />
          </button>

          <div className="md:hidden flex items-center gap-2">
            <BookOpen className="h-5 w-5 text-primary" />
            <span className="font-bold text-primary text-sm">IELTS</span>
          </div>

          <div className="hidden md:block" />

          <div className="flex items-center gap-3">
            <button
              onClick={toggleTheme}
              className="rounded-xl border border-border p-2.5 text-muted-foreground transition-colors hover:bg-secondary hover:text-foreground"
              aria-label="Toggle theme"
            >
              {theme === "light" ? <Moon className="h-4 w-4" /> : <Sun className="h-4 w-4" />}
            </button>
            {isGuest ? (
              <Link
                to="/register"
                className="flex items-center gap-2 rounded-xl border border-primary bg-primary/5 px-3 py-2 text-xs font-semibold text-primary transition-colors hover:bg-primary/10"
              >
                <UserPlus className="h-3.5 w-3.5" />
                <span className="hidden sm:inline">Sign Up to Save Progress</span>
                <span className="sm:hidden">Sign Up</span>
              </Link>
            ) : (
              <>
                <button
                  onClick={handleLogout}
                  className="rounded-xl border border-border p-2.5 text-muted-foreground transition-colors hover:bg-secondary hover:text-destructive"
                  aria-label="Logout"
                >
                  <LogOut className="h-4 w-4" />
                </button>
                <div className="flex h-9 w-9 items-center justify-center rounded-full bg-primary text-sm font-bold text-primary-foreground">
                  {initials}
                </div>
              </>
            )}
          </div>
        </header>

        {/* Page content */}
        <main className="flex-1 overflow-y-auto">{children}</main>
      </div>
    </div>
  );
};
