import {
  ChevronLeft,
  ChevronRight,
  Cpu,
  FileJson,
  GraduationCap,
  LayoutDashboard,
  Library,
  LogOut,
  Moon,
  PlusCircle,
  Sun,
} from "lucide-react";
import type React from "react";
import { useState } from "react";
import { Link, useLocation } from "react-router-dom";
import { SidebarVersionInfo } from "@/components/SidebarVersionInfo";
import { Button } from "@/components/ui/button";
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip";
import { useTheme } from "@/contexts/ThemeContext";
import { cn } from "@/lib/utils";

const navItems = [
  { label: "Dashboard", icon: LayoutDashboard, path: "/admin" },
  { label: "Content Library", icon: Library, path: "/admin/content" },
  { label: "Create New", icon: PlusCircle, path: "/admin/create" },
  { label: "Import Dataset", icon: FileJson, path: "/admin/import" },
  { label: "AI Configurations", icon: Cpu, path: "/admin/ai-configurations" },
  //  { label: "Settings", icon: Settings, path: "/admin/settings" },
];

export const AdminLayout: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [collapsed, setCollapsed] = useState(false);
  const location = useLocation();
  const { theme, toggleTheme } = useTheme();

  const isActive = (path: string) =>
    path === "/admin" ? location.pathname === "/admin" : location.pathname.startsWith(path);

  return (
    <div className="flex min-h-screen bg-background">
      {/* Sidebar */}
      <aside
        className={cn(
          "sticky top-0 h-screen flex flex-col border-r border-border bg-card transition-all duration-300 ease-in-out z-30",
          collapsed ? "w-[70px]" : "w-64"
        )}
      >
        {/* Brand */}
        <div className="flex items-center gap-3 px-4 h-16 border-b border-border shrink-0">
          <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-violet-600 text-white">
            <GraduationCap className="h-5 w-5" />
          </div>
          {!collapsed && (
            <div className="overflow-hidden">
              <p className="text-sm font-bold text-foreground truncate">Admin Portal</p>
              <p className="text-[10px] text-muted-foreground">IELTS Mastery Hub</p>
            </div>
          )}
        </div>

        {/* Nav */}
        <nav className="flex-1 py-4 px-2 space-y-1 overflow-y-auto">
          {navItems.map((item) => {
            const active = isActive(item.path);
            const btn = (
              <Link
                to={item.path}
                className={cn(
                  "flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-colors",
                  active
                    ? "bg-violet-100 text-violet-700 dark:bg-violet-900/30 dark:text-violet-400"
                    : "text-muted-foreground hover:bg-accent/50 hover:text-foreground",
                  collapsed && "justify-center px-2"
                )}
              >
                <item.icon className="h-5 w-5 shrink-0" />
                {!collapsed && <span>{item.label}</span>}
              </Link>
            );

            if (collapsed) {
              return (
                <Tooltip key={item.path} delayDuration={0}>
                  <TooltipTrigger asChild>{btn}</TooltipTrigger>
                  <TooltipContent side="right">{item.label}</TooltipContent>
                </Tooltip>
              );
            }
            return <div key={item.path}>{btn}</div>;
          })}
        </nav>

        {/* Footer */}
        <div className="border-t border-border p-2 space-y-1 shrink-0">
          <SidebarVersionInfo collapsed={collapsed} />
          <Button
            variant="ghost"
            size="sm"
            onClick={toggleTheme}
            className={cn("w-full gap-2", collapsed ? "justify-center" : "justify-start")}
          >
            {theme === "dark" ? <Sun className="h-4 w-4" /> : <Moon className="h-4 w-4" />}
            {!collapsed && (theme === "dark" ? "Light Mode" : "Dark Mode")}
          </Button>
          <Link to="/dashboard">
            <Button
              variant="ghost"
              size="sm"
              className={cn("w-full gap-2 text-muted-foreground", collapsed ? "justify-center" : "justify-start")}
            >
              <LogOut className="h-4 w-4" />
              {!collapsed && "Back to App"}
            </Button>
          </Link>
          <Button
            variant="ghost"
            size="icon"
            onClick={() => setCollapsed(!collapsed)}
            className="w-full"
            aria-label="Toggle Sidebar"
          >
            {collapsed ? <ChevronRight className="h-4 w-4" /> : <ChevronLeft className="h-4 w-4" />}
          </Button>
        </div>
      </aside>

      {/* Main content */}
      <main className="flex-1 overflow-auto">{children}</main>
    </div>
  );
};
