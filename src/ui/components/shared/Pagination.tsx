import { ChevronLeft, ChevronRight } from "lucide-react";
import type React from "react";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";
import type { PaginationMeta } from "@/types/pagination";

interface PaginationProps {
  pagination: PaginationMeta;
  onPageChange: (page: number) => void;
}

const ELLIPSIS = "…" as const;

/** Builds a windowed list of page numbers with ellipses for large page counts. */
function buildPageWindow(current: number, totalPages: number): (number | typeof ELLIPSIS)[] {
  const windowSize = 1;
  const pages = new Set<number>([1, totalPages]);
  for (let i = current - windowSize; i <= current + windowSize; i++) {
    if (i >= 1 && i <= totalPages) pages.add(i);
  }
  const sorted = Array.from(pages).sort((a, b) => a - b);

  const result: (number | typeof ELLIPSIS)[] = [];
  let prev: number | null = null;
  for (const p of sorted) {
    if (prev !== null && p - prev > 1) {
      result.push(ELLIPSIS);
    }
    result.push(p);
    prev = p;
  }
  return result;
}

const Pagination: React.FC<PaginationProps> = ({ pagination, onPageChange }) => {
  const { page, page_size, total_pages, total_items, has_next, has_prev } = pagination;

  if (total_pages <= 1) return null;

  const rangeStart = (page - 1) * page_size + 1;
  const rangeEnd = Math.min(page * page_size, total_items);
  const pageWindow = buildPageWindow(page, total_pages);

  return (
    <nav
      className="flex flex-col sm:flex-row items-center justify-between gap-4 pt-4"
      aria-label="Pagination"
    >
      <p className="text-sm text-muted-foreground">
        Showing {rangeStart}–{rangeEnd} of {total_items} results
      </p>

      <div className="flex items-center gap-1">
        <Button
          variant="outline"
          size="sm"
          className="gap-1"
          disabled={!has_prev}
          onClick={() => onPageChange(page - 1)}
          aria-label="Previous page"
        >
          <ChevronLeft className="h-4 w-4" />
          Prev
        </Button>

        {pageWindow.map((entry, i) =>
          entry === ELLIPSIS ? (
            // biome-ignore lint/suspicious/noArrayIndexKey: ellipsis entries have no stable identity in this fixed-size window.
            <span key={`ellipsis-${i}`} className="px-2 text-sm text-muted-foreground select-none">
              {ELLIPSIS}
            </span>
          ) : (
            <Button
              key={entry}
              variant={entry === page ? "default" : "outline"}
              size="sm"
              className={cn("w-9 px-0", entry === page && "pointer-events-none")}
              onClick={() => onPageChange(entry)}
              aria-current={entry === page ? "page" : undefined}
            >
              {entry}
            </Button>
          )
        )}

        <Button
          variant="outline"
          size="sm"
          className="gap-1"
          disabled={!has_next}
          onClick={() => onPageChange(page + 1)}
          aria-label="Next page"
        >
          Next
          <ChevronRight className="h-4 w-4" />
        </Button>
      </div>
    </nav>
  );
};

export default Pagination;
