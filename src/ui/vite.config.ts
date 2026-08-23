import { createRequire } from "node:module";
import path from "node:path";
import tailwindcss from "@tailwindcss/vite";
import react from "@vitejs/plugin-react-swc";
import { defineConfig } from "vite";

const require = createRequire(import.meta.url);
const { version: appVersion } = require("../../package.json") as { version: string };

export default defineConfig(({ mode: _mode }) => ({
  root: __dirname,
  envDir: path.resolve(__dirname, "../.."),
  clearScreen: false,
  envPrefix: ["VITE_", "TAURI_ENV_"],
  define: {
    __APP_VERSION__: JSON.stringify(appVersion),
  },
  server: {
    host: process.env.TAURI_DEV_HOST || "localhost",
    port: 8080,
    strictPort: true,
    forwardConsole: false,
    hmr: process.env.TAURI_DEV_HOST
      ? { protocol: "ws", host: process.env.TAURI_DEV_HOST, port: 8080 }
      : { overlay: false },
    watch: { ignored: ["**/src/core/**"] },
  },
  plugins: [react(), tailwindcss()],
  publicDir: path.resolve(__dirname, "../../public"),
  build: {
    outDir: path.resolve(__dirname, "dist"),
    emptyOutDir: true,
    target: process.env.TAURI_ENV_PLATFORM === "windows" ? "chrome105" : "safari13",
    minify: !process.env.TAURI_ENV_DEBUG,
    sourcemap: !!process.env.TAURI_ENV_DEBUG,
  },
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "."),
    },
  },
}));
