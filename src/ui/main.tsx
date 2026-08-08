import { createRoot } from "react-dom/client";
import App from "./App.tsx";
import "./index.css";

window.addEventListener("error", (e) => {
  document.body.innerHTML = `<pre style="color:red;padding:32px;font-family:monospace;white-space:pre-wrap">JS Error:\n${e.message}\n${e.error?.stack ?? ""}</pre>`;
});
window.addEventListener("unhandledrejection", (e) => {
  document.body.innerHTML = `<pre style="color:red;padding:32px;font-family:monospace;white-space:pre-wrap">Unhandled promise rejection:\n${e.reason}</pre>`;
});

createRoot(document.getElementById("root")!).render(<App />);
