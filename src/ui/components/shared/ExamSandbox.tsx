import type React from "react";
import { useEffect, useRef } from "react";

interface ExamSandboxProps {
  children: React.ReactNode;
  className?: string;
  enabled?: boolean;
}

/**
 * Wraps content in an exam-secure container that disables:
 * - Ctrl+F / Cmd+F (browser Find)
 * - Ctrl+C / Cmd+C (copy)
 * - Right-click context menu
 * - Text selection / highlighting
 */
const ExamSandbox: React.FC<ExamSandboxProps> = ({ children, className, enabled = true }) => {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!enabled) return;

    const handleKeyDown = (e: KeyboardEvent) => {
      const mod = e.metaKey || e.ctrlKey;
      // Block Ctrl/Cmd+F (find) and Ctrl/Cmd+C (copy)
      if (mod && (e.key === "f" || e.key === "F" || e.key === "c" || e.key === "C")) {
        e.preventDefault();
        e.stopPropagation();
      }
    };

    // Must capture on window to intercept before browser handles it
    window.addEventListener("keydown", handleKeyDown, true);
    return () => window.removeEventListener("keydown", handleKeyDown, true);
  }, [enabled]);

  if (!enabled) {
    return <div className={className}>{children}</div>;
  }

  return (
    // biome-ignore lint/a11y/noStaticElementInteractions: this wrapper only intercepts browser default context-menu/copy behavior for exam security, it introduces no user-facing interactive widget, so no ARIA role applies.
    <div
      ref={ref}
      className={className}
      onContextMenu={(e) => e.preventDefault()}
      onCopy={(e) => e.preventDefault()}
      style={{ userSelect: "none", WebkitUserSelect: "none" }}
    >
      {children}
    </div>
  );
};

export default ExamSandbox;
