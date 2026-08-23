import { ArrowUpCircle } from "lucide-react";
import type React from "react";
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip";
import { useVersionCheck } from "@/hooks/useVersionCheck";
import { cn } from "@/lib/utils";

interface SidebarVersionInfoProps {
  /** Render the compact, icon-only form used when the sidebar rail is collapsed. */
  collapsed?: boolean;
  className?: string;
}

/**
 * Shows the current app version (read from package.json) and, when a newer
 * LTS build is available, a subtle "Update available" indicator. Shared by
 * both the admin and student-facing sidebars so the two stay in sync.
 */
export const SidebarVersionInfo: React.FC<SidebarVersionInfoProps> = ({ collapsed = false, className }) => {
  const { currentVersion, hasUpdate, latestVersion, onUpdate } = useVersionCheck();

  if (collapsed) {
    return (
      <div className={cn("flex justify-center py-1", className)}>
        {hasUpdate ? (
          <Tooltip delayDuration={0}>
            <TooltipTrigger asChild>
              <button
                type="button"
                onClick={onUpdate}
                aria-label={`Update available: v${latestVersion}`}
                className="flex h-6 w-6 items-center justify-center rounded-full text-amber-500 transition-colors hover:text-amber-600"
              >
                <ArrowUpCircle className="h-4 w-4" />
              </button>
            </TooltipTrigger>
            <TooltipContent side="right">
              v{currentVersion} · Update available (v{latestVersion})
            </TooltipContent>
          </Tooltip>
        ) : (
          <span className="text-[10px] text-muted-foreground">v{currentVersion}</span>
        )}
      </div>
    );
  }

  return (
    <div className={cn("flex items-center justify-between gap-2 px-1 py-1", className)}>
      <span className="text-[10px] text-muted-foreground">v{currentVersion}</span>
      {hasUpdate && (
        <button
          type="button"
          onClick={onUpdate}
          className="inline-flex items-center gap-1 rounded-full border border-amber-500/50 bg-amber-500/10 px-2 py-0.5 text-[10px] font-medium text-amber-600 transition-colors hover:bg-amber-500/20 dark:text-amber-400"
        >
          <ArrowUpCircle className="h-3 w-3" />
          Update available
        </button>
      )}
    </div>
  );
};
