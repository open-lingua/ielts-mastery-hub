import { describe, it, expect, vi } from "vitest";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

vi.mock("@/data/readingTestData", () => ({
  tfngQuestions: [
    { id: "tfng1", label: "1", text: "The sky is blue.", answer: "TRUE" },
  ],
  mcQuestions: [
    { id: "mc1", label: "5", text: "What color is the sky?", options: ["Red", "Blue", "Green"], answer: "Blue" },
  ],
  ynngQuestions: [
    { id: "ynng1", label: "10", text: "The writer agrees with this view.", answer: "YES" },
  ],
}));

import { QuestionRenderer } from "../QuestionRenderer";

const tfngSection = {
  title: "Questions 1",
  instructions: "Do the following statements agree?",
  data: { id: "s1", type: "TRUE_FALSE_NOT_GIVEN" } as any,
};

const ynngSection = {
  title: "Questions 10",
  instructions: "Do the following statements agree?",
  data: { id: "s2", type: "YES_NO_NOT_GIVEN" } as any,
};

describe("QuestionRenderer (TFNG)", () => {
  it("renders TFNG question text", () => {
    render(<QuestionRenderer section={tfngSection} answers={{}} onAnswer={vi.fn()} submitted={false} />);
    expect(screen.getByText("The sky is blue.")).toBeInTheDocument();
  });

  it("renders TRUE/FALSE/NOT GIVEN buttons", () => {
    render(<QuestionRenderer section={tfngSection} answers={{}} onAnswer={vi.fn()} submitted={false} />);
    expect(screen.getByText("TRUE")).toBeInTheDocument();
    expect(screen.getByText("FALSE")).toBeInTheDocument();
    expect(screen.getByText("NOT GIVEN")).toBeInTheDocument();
  });

  it("calls onAnswer when selecting an option", async () => {
    const onAnswer = vi.fn();
    const user = userEvent.setup();
    render(<QuestionRenderer section={tfngSection} answers={{}} onAnswer={onAnswer} submitted={false} />);
    await user.click(screen.getByText("TRUE"));
    expect(onAnswer).toHaveBeenCalledWith("tfng1", "TRUE");
  });

  it("shows correct feedback when submitted", () => {
    render(<QuestionRenderer section={tfngSection} answers={{ tfng1: "TRUE" }} onAnswer={vi.fn()} submitted={true} />);
    expect(screen.getByText("Correct")).toBeInTheDocument();
  });

  it("shows wrong answer feedback when submitted", () => {
    render(<QuestionRenderer section={tfngSection} answers={{ tfng1: "FALSE" }} onAnswer={vi.fn()} submitted={true} />);
    expect(screen.getByText(/Answer: TRUE/)).toBeInTheDocument();
  });

  it("renders section title and instructions", () => {
    render(<QuestionRenderer section={tfngSection} answers={{}} onAnswer={vi.fn()} submitted={false} />);
    expect(screen.getByText("Questions 1")).toBeInTheDocument();
    expect(screen.getByText("Do the following statements agree?")).toBeInTheDocument();
  });
});

describe("QuestionRenderer (YNNG)", () => {
  it("renders YES/NO/NOT GIVEN buttons", () => {
    render(<QuestionRenderer section={ynngSection} answers={{}} onAnswer={vi.fn()} submitted={false} />);
    expect(screen.getByText("YES")).toBeInTheDocument();
    expect(screen.getByText("NO")).toBeInTheDocument();
  });
});
