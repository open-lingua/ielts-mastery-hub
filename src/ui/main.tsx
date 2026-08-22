import { createRoot } from "react-dom/client";
import App from "./App.tsx";
import "./index.css";

window.addEventListener("error", (e) => {
  document.body.innerHTML = `<pre style="color:red;padding:32px;font-family:monospace;white-space:pre-wrap">JS Error:\n${e.message}\n${e.error?.stack ?? ""}</pre>`;
});
window.addEventListener("unhandledrejection", (e) => {
  document.body.innerHTML = `<pre style="color:red;padding:32px;font-family:monospace;white-space:pre-wrap">Unhandled promise rejection:\n${e.reason}</pre>`;
});

const rootElement = document.getElementById("root");
if (!rootElement) {
  throw new Error("Root element with id 'root' was not found in the document.");
}

createRoot(rootElement).render(<App />);
