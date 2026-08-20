import { useCallback, useEffect, useRef, type RefObject } from "react";
import { useSearchParams } from "react-router-dom";

export interface UsePaginationOptions {
  /** URL query param name used to store the current page. Defaults to "page". */
  paramName?: string;
  /** Fixed page size for this list. Defaults to 10. */
  pageSize?: number;
  /**
   * When this value changes (e.g. the active tab/section), the page resets
   * back to 1 and the URL param is cleared.
   */
  resetKey?: unknown;
  /** Optional element to scroll into view on every page change. Falls back to window top. */
  scrollTargetRef?: RefObject<HTMLElement>;
}

export interface UsePaginationReturn {
  page: number;
  pageSize: number;
  setPage: (page: number) => void;
}

/**
 * Manages the current page number in sync with a URL query param so pages are
 * shareable and survive browser navigation. Resets to page 1 whenever
 * `resetKey` changes (e.g. switching sections/tabs).
 */
export function usePagination({
  paramName = "page",
  pageSize = 10,
  resetKey,
  scrollTargetRef,
}: UsePaginationOptions = {}): UsePaginationReturn {
  const [searchParams, setSearchParams] = useSearchParams();

  const rawPage = Number(searchParams.get(paramName));
  const page = Number.isFinite(rawPage) && rawPage >= 1 ? Math.floor(rawPage) : 1;

  const scrollToTop = useCallback(() => {
    if (scrollTargetRef?.current) {
      scrollTargetRef.current.scrollIntoView({ behavior: "smooth", block: "start" });
    } else {
      window.scrollTo({ top: 0, behavior: "smooth" });
    }
  }, [scrollTargetRef]);

  const setPage = useCallback(
    (next: number) => {
      setSearchParams(
        (prev) => {
          const params = new URLSearchParams(prev);
          if (next <= 1) {
            params.delete(paramName);
          } else {
            params.set(paramName, String(next));
          }
          return params;
        },
        { replace: false }
      );
      scrollToTop();
    },
    [paramName, scrollToTop, setSearchParams]
  );

  // Reset to page 1 whenever the reset key (e.g. active section/tab) changes
  // — but not on initial mount, so a shared/reloaded URL keeps its page.
  const isFirstRender = useRef(true);
  // biome-ignore lint/correctness/useExhaustiveDependencies: resetKey is the deliberate change trigger for this effect.
  useEffect(() => {
    if (isFirstRender.current) {
      isFirstRender.current = false;
      return;
    }
    setSearchParams(
      (prev) => {
        const params = new URLSearchParams(prev);
        params.delete(paramName);
        return params;
      },
      { replace: true }
    );
  }, [resetKey, paramName, setSearchParams]);

  return { page, pageSize, setPage };
}
