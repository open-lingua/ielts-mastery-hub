import {
  BookOpen,
  ChevronLeft,
  ChevronRight,
  Headphones,
  LayoutDashboard,
  Library,
  Menu,
  Moon,
  PenTool,
  Shield,
  Sun,
} from "lucide-react";
import type React from "react";
import { useState } from "react";
import { Link, useLocation } from "react-router-dom";
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip";
import { useTheme } from "@/contexts/ThemeContext";
import { cn } from "@/lib/utils";

const navItems = [
  { label: "Dashboard", path: "/dashboard", icon: LayoutDashboard },
  { label: "Test Library", path: "/tests", icon: Library },
  { label: "Writing", path: "/tests?tab=Writing", icon: PenTool },
  { label: "Reading", path: "/tests?tab=Reading", icon: BookOpen },
  { label: "Listening", path: "/tests?tab=Listening", icon: Headphones },
  { label: "Admin Portal", path: "/admin", icon: Shield },
];

export const DashboardLayout: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { theme, toggleTheme } = useTheme();
  const location = useLocation();
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [collapsed, setCollapsed] = useState(false);

  return (
    <div className="flex h-screen overflow-hidden bg-background">
      {sidebarOpen && (
        <div
          className="fixed inset-0 z-40 bg-foreground/20 backdrop-blur-sm md:hidden"
          onClick={() => setSidebarOpen(false)}
        />
      )}

      <aside
        className={cn(
          "fixed inset-y-0 left-0 z-50 flex flex-col border-r border-border bg-card transition-all duration-300 ease-in-out md:static md:translate-x-0",
          sidebarOpen ? "translate-x-0" : "-translate-x-full",
          collapsed ? "w-[70px]" : "w-64"
        )}
      >
        <div
          className={cn(
            "flex h-16 items-center border-b border-border transition-all duration-300",
            collapsed ? "justify-center px-2" : "gap-2 px-6"
          )}
        >
          <BookOpen className="h-6 w-6 shrink-0 text-primary" />
          {!collapsed && (
            <>
              <span className="text-lg font-bold text-primary">IELTS</span>
              <span className="text-lg font-medium text-foreground">Mastery Hub</span>
            </>
          )}
        </div>

        <TooltipProvider delayDuration={0}>
          <nav className={cn("flex-1 space-y-1 p-4 transition-all duration-300", collapsed && "px-2")}>
            {navItems.map((item) => {
              const [itemPath, itemQuery] = item.path.split("?");
              const isActive = location.pathname === itemPath && (!itemQuery || location.search.includes(itemQuery));
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

      <div className="flex flex-1 flex-col overflow-hidden">
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

          <button
            onClick={toggleTheme}
            className="rounded-xl border border-border p-2.5 text-muted-foreground transition-colors hover:bg-secondary hover:text-foreground"
            aria-label="Toggle theme"
          >
            {theme === "light" ? <Moon className="h-4 w-4" /> : <Sun className="h-4 w-4" />}
          </button>
        </header>

        <main className="flex-1 overflow-y-auto">{children}</main>
      </div>
    </div>
  );
};
