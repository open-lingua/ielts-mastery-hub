import { defineConfig } from "vitest/config";

// Separate from src/ui/vitest.config.ts, which only discovers *.{test,spec}.{ts,tsx}
// under src/ui. This config covers unit tests for the plain Node ESM scripts in
// this directory (e.g. sync-msi-version.mjs).
export default defineConfig({
  test: {
    include: ["**/*.test.mjs"],
    environment: "node",
  },
});
