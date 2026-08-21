import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import React from "react";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { Toaster } from "@/components/ui/toaster";
import { TooltipProvider } from "@/components/ui/tooltip";

class ErrorBoundary extends React.Component<{ children: React.ReactNode }, { error: Error | null }> {
  state = { error: null };
  static getDerivedStateFromError(error: Error) {
    return { error };
  }
  render() {
    if (this.state.error) {
      return (
        <div style={{ padding: 32, fontFamily: "monospace", color: "red" }}>
          <h2>App crashed</h2>
          <pre style={{ whiteSpace: "pre-wrap" }}>{(this.state.error as Error).message}</pre>
          <pre style={{ whiteSpace: "pre-wrap", fontSize: 12 }}>{(this.state.error as Error).stack}</pre>
        </div>
      );
    }
    return this.props.children;
  }
}

import { ThemeProvider } from "@/contexts/ThemeContext";
import AdminDashboard from "./pages/admin/AdminDashboard";
import ContentLibrary from "./pages/admin/ContentLibrary";
import CreateContent from "./pages/admin/CreateContent";
import ImportDataset from "./pages/admin/ImportDataset";
import Dashboard from "./pages/Dashboard";
import ListeningModule from "./pages/ListeningModule";
import NotFound from "./pages/NotFound";
import ReadingModule from "./pages/ReadingModule";
import TestLibrary from "./pages/TestLibrary";
import WritingSimulator from "./pages/WritingSimulator";

const queryClient = new QueryClient();

const App = () => (
  <ErrorBoundary>
    <QueryClientProvider client={queryClient}>
      <ThemeProvider>
        <TooltipProvider>
          <Toaster />
          <Sonner />
          <BrowserRouter>
            <Routes>
              <Route path="/" element={<Dashboard />} />
              <Route path="/dashboard" element={<Dashboard />} />
              <Route path="/writing" element={<WritingSimulator />} />
              <Route path="/reading" element={<ReadingModule />} />
              <Route path="/listening" element={<ListeningModule />} />
              <Route path="/tests" element={<TestLibrary />} />
              <Route path="/admin" element={<AdminDashboard />} />
              <Route path="/admin/content" element={<ContentLibrary />} />
              <Route path="/admin/create" element={<CreateContent />} />
              <Route path="/admin/import" element={<ImportDataset />} />
              <Route path="*" element={<NotFound />} />
            </Routes>
          </BrowserRouter>
        </TooltipProvider>
      </ThemeProvider>
    </QueryClientProvider>
  </ErrorBoundary>
);

export default App;
