import { render, screen } from "@testing-library/react";
import type React from "react";
import { describe, expect, it, vi } from "vitest";
import type { PreviewProps } from "../TestPreviewModal";

// We only test the exported types and basic render since the modal is a complex Dialog
// For a minimal smoke test, we verify the module can be imported without error

// TestPreviewModal is a named export, not default
let TestPreviewModal: React.ComponentType<PreviewProps>;

beforeAll(async () => {
  const mod = (await import("../TestPreviewModal")) as {
    default?: React.ComponentType<PreviewProps>;
    TestPreviewModal?: React.ComponentType<PreviewProps>;
  };
  // It could be either default or named — grab whichever exists
  TestPreviewModal = (mod.default || mod.TestPreviewModal) as React.ComponentType<PreviewProps>;
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
