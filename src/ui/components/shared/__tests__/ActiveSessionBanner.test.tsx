import { render, screen } from "@testing-library/react";
import { MemoryRouter } from "react-router-dom";
import { describe, expect, it } from "vitest";
import ActiveSessionBanner from "../ActiveSessionBanner";

describe("ActiveSessionBanner", () => {
  it("renders the active session message", () => {
    render(
      <MemoryRouter>
        <ActiveSessionBanner testTitle="Reading Practice Test 1" testType="reading" testId="test-001" />
      </MemoryRouter>
    );
    expect(screen.getByText("You have an active test in progress")).toBeInTheDocument();
  });

  it("renders the test title", () => {
    render(
      <MemoryRouter>
        <ActiveSessionBanner testTitle="Reading Practice Test 1" testType="reading" testId="test-001" />
      </MemoryRouter>
    );
    expect(screen.getByText("Reading Practice Test 1")).toBeInTheDocument();
  });

  it("renders the module badge", () => {
    render(
      <MemoryRouter>
        <ActiveSessionBanner testTitle="Listening Test" testType="listening" testId="test-002" />
      </MemoryRouter>
    );
    expect(screen.getByText("Listening")).toBeInTheDocument();
  });

  it("renders Resume Test button with correct link", () => {
    render(
      <MemoryRouter>
        <ActiveSessionBanner testTitle="Writing Test" testType="writing" testId="test-003" />
      </MemoryRouter>
    );
    const link = screen.getByText("Resume Test").closest("a");
    expect(link).toHaveAttribute("href", "/writing?id=test-003");
  });
});
