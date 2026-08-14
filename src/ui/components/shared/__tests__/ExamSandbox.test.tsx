import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";
import ExamSandbox from "../ExamSandbox";

describe("ExamSandbox", () => {
  it("renders children", () => {
    render(
      <ExamSandbox>
        <div>Exam Content</div>
      </ExamSandbox>
    );
    expect(screen.getByText("Exam Content")).toBeInTheDocument();
  });

  it("applies user-select none when enabled", () => {
    const { container } = render(
      <ExamSandbox>
        <div>X</div>
      </ExamSandbox>
    );
    const wrapper = container.firstElementChild as HTMLElement;
    expect(wrapper.style.userSelect).toBe("none");
  });

  it("does not apply user-select when disabled", () => {
    const { container } = render(
      <ExamSandbox enabled={false}>
        <div>X</div>
      </ExamSandbox>
    );
    const wrapper = container.firstElementChild as HTMLElement;
    expect(wrapper.style.userSelect).toBe("");
  });

  it("blocks right-click when enabled", () => {
    const { container } = render(
      <ExamSandbox>
        <div>X</div>
      </ExamSandbox>
    );
    const wrapper = container.firstElementChild as HTMLElement;
    const event = new MouseEvent("contextmenu", { bubbles: true, cancelable: true });
    const prevented = !wrapper.dispatchEvent(event);
    expect(prevented).toBe(true);
  });

  it("blocks copy when enabled", () => {
    const { container } = render(
      <ExamSandbox>
        <div>X</div>
      </ExamSandbox>
    );
    const wrapper = container.firstElementChild as HTMLElement;
    const event = new Event("copy", { bubbles: true, cancelable: true });
    const prevented = !wrapper.dispatchEvent(event);
    expect(prevented).toBe(true);
  });

  it("blocks Ctrl+F keydown", () => {
    render(
      <ExamSandbox>
        <div>X</div>
      </ExamSandbox>
    );
    const event = new KeyboardEvent("keydown", {
      key: "f",
      ctrlKey: true,
      bubbles: true,
      cancelable: true,
    });
    const prevented = !window.dispatchEvent(event);
    expect(prevented).toBe(true);
  });

  it("blocks Ctrl+C keydown", () => {
    render(
      <ExamSandbox>
        <div>X</div>
      </ExamSandbox>
    );
    const event = new KeyboardEvent("keydown", {
      key: "c",
      ctrlKey: true,
      bubbles: true,
      cancelable: true,
    });
    const prevented = !window.dispatchEvent(event);
    expect(prevented).toBe(true);
  });

  it("does not block keys when disabled", () => {
    render(
      <ExamSandbox enabled={false}>
        <div>X</div>
      </ExamSandbox>
    );
    const event = new KeyboardEvent("keydown", {
      key: "f",
      ctrlKey: true,
      bubbles: true,
      cancelable: true,
    });
    const prevented = !window.dispatchEvent(event);
    expect(prevented).toBe(false);
  });

  it("passes className prop", () => {
    const { container } = render(
      <ExamSandbox className="custom-class">
        <div>X</div>
      </ExamSandbox>
    );
    expect(container.firstElementChild?.className).toContain("custom-class");
  });
});
