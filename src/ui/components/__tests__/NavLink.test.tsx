import { render, screen } from "@testing-library/react";
import { MemoryRouter } from "react-router-dom";
import { describe, expect, it } from "vitest";
import { NavLink } from "../NavLink";

describe("NavLink", () => {
  it("renders with correct text", () => {
    render(
      <MemoryRouter initialEntries={["/"]}>
        <NavLink to="/dashboard">Dashboard</NavLink>
      </MemoryRouter>
    );
    expect(screen.getByText("Dashboard")).toBeInTheDocument();
  });

  it("applies activeClassName when route matches", () => {
    render(
      <MemoryRouter initialEntries={["/dashboard"]}>
        <NavLink to="/dashboard" className="base" activeClassName="active-link">
          Dashboard
        </NavLink>
      </MemoryRouter>
    );
    const link = screen.getByText("Dashboard");
    expect(link.className).toContain("active-link");
  });

  it("does not apply activeClassName when route does not match", () => {
    render(
      <MemoryRouter initialEntries={["/other"]}>
        <NavLink to="/dashboard" className="base" activeClassName="active-link">
          Dashboard
        </NavLink>
      </MemoryRouter>
    );
    const link = screen.getByText("Dashboard");
    expect(link.className).not.toContain("active-link");
  });

  it("renders as an anchor tag with correct href", () => {
    render(
      <MemoryRouter initialEntries={["/"]}>
        <NavLink to="/tests">Tests</NavLink>
      </MemoryRouter>
    );
    const link = screen.getByText("Tests");
    expect(link.closest("a")).toHaveAttribute("href", "/tests");
  });
});
