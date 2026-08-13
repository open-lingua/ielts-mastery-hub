import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";
import tailwindcss from "@tailwindcss/vite";
import path from "path";
export default defineConfig(({ mode: _mode }) => ({
  root: __dirname,
  envDir: path.resolve(__dirname, "../.."),
  clearScreen: false,
  envPrefix: ["VITE_", "TAURI_ENV_"],
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
