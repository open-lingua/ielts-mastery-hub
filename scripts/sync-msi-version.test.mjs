import { describe, expect, it } from "vitest";
import { deriveWixVersion } from "./sync-msi-version.mjs";

describe("deriveWixVersion", () => {
  it("maps an -rc.N pre-release to a numeric build field", () => {
    expect(deriveWixVersion("1.0.1-rc.2")).toBe("1.0.1.2");
  });

  it("maps a plain semver with no pre-release to build 0", () => {
    expect(deriveWixVersion("2.0.0")).toBe("2.0.0.0");
  });

  it("maps rc.0 to build 0", () => {
    expect(deriveWixVersion("1.0.0-rc.0")).toBe("1.0.0.0");
  });

  it("rejects a non-rc pre-release identifier", () => {
    expect(() => deriveWixVersion("1.0.0-beta.3")).toThrow();
  });

  it("rejects a non-numeric rc identifier", () => {
    expect(() => deriveWixVersion("1.0.0-rc.abc")).toThrow();
  });

  it("rejects a build field greater than 65535", () => {
    expect(() => deriveWixVersion("1.0.0-rc.65536")).toThrow();
  });

  it("rejects a major/minor/patch field greater than 65535", () => {
    expect(() => deriveWixVersion("65536.0.0")).toThrow();
  });

  it("accepts a build field at the 65535 boundary", () => {
    expect(deriveWixVersion("1.0.0-rc.65535")).toBe("1.0.0.65535");
  });
});
