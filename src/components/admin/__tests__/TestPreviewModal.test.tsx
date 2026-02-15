import { describe, it, expect, vi } from "vitest";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import type { PreviewProps } from "../TestPreviewModal";

// We only test the exported types and basic render since the modal is a complex Dialog
// For a minimal smoke test, we verify the module can be imported without error

// TestPreviewModal is a named export, not default
let TestPreviewModal: any;

beforeAll(async () => {
  const mod = await import("../TestPreviewModal");
  // It could be either default or named — grab whichever exists
  TestPreviewModal = (mod as any).default || (mod as any).TestPreviewModal;
});

describe("TestPreviewModal", () => {
  it("module can be imported (smoke test)", () => {
    expect(TestPreviewModal).toBeDefined();
  });

  it("does not render content when open is false", () => {
    const props: PreviewProps = {
      open: false,
      onOpenChange: vi.fn(),
      activeModule: "reading",
      reading: {
        testTitle: "Test",
        testType: "academic",
        difficulty: "medium",
        duration: "60",
        passages: [],
      },
      listening: {
        testTitle: "",
        difficulty: "",
        duration: "",
        sections: [],
      },
      writing: {
        taskType: "task1",
        title: "",
        difficulty: "",
        suggestedTime: "",
        prompt: "",
        minWords: 150,
        maxWords: "",
      },
    };

    render(<TestPreviewModal {...props} />);
    expect(screen.queryByText("Student Preview")).not.toBeInTheDocument();
  });
});
