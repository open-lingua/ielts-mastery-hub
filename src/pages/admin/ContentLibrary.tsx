import React, { useState } from "react";
import { Link } from "react-router-dom";
import {
  PlusCircle,
  Search,
  MoreHorizontal,
  BookOpen,
  PenTool,
  Headphones,
  Clock,
  Eye,
  Trash2,
  Edit3,
} from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { AdminLayout } from "@/components/AdminLayout";
import { cn } from "@/lib/utils";

interface ContentItem {
  id: number;
  title: string;
  module: "Reading" | "Writing" | "Listening";
  status: "Draft" | "Published" | "Archived";
  questions: number;
  lastEdited: string;
  band: string;
}

const allContent: ContentItem[] = [
  { id: 101, title: "The Future of AI", module: "Reading", status: "Draft", questions: 13, lastEdited: "2 mins ago", band: "7-8" },
  { id: 102, title: "Section 2: Campus Tour", module: "Listening", status: "Published", questions: 10, lastEdited: "1 day ago", band: "6-7" },
  { id: 103, title: "Task 2: Climate Change Essay", module: "Writing", status: "Draft", questions: 1, lastEdited: "3 hours ago", band: "7-8" },
  { id: 104, title: "Academic Reading: Coral Reefs", module: "Reading", status: "Published", questions: 14, lastEdited: "2 days ago", band: "8-9" },
  { id: 105, title: "Section 4: Renewable Energy Lecture", module: "Listening", status: "Archived", questions: 10, lastEdited: "1 week ago", band: "7-8" },
  { id: 106, title: "Task 1: Bar Chart – Tourism", module: "Writing", status: "Published", questions: 1, lastEdited: "5 days ago", band: "6-7" },
];

const moduleIcons: Record<string, React.ElementType> = {
  Reading: BookOpen,
  Writing: PenTool,
  Listening: Headphones,
};

const moduleColors: Record<string, string> = {
  Reading: "text-blue-500",
  Writing: "text-amber-500",
  Listening: "text-rose-500",
};

const statusColors: Record<string, string> = {
  Draft: "bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400",
  Published: "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400",
  Archived: "bg-secondary text-muted-foreground",
};

const ContentLibrary: React.FC = () => {
  const [search, setSearch] = useState("");
  const [filterModule, setFilterModule] = useState<string>("All");

  const filtered = allContent.filter((c) => {
    const matchSearch = c.title.toLowerCase().includes(search.toLowerCase());
    const matchModule = filterModule === "All" || c.module === filterModule;
    return matchSearch && matchModule;
  });

  const tabs = ["All", "Reading", "Writing", "Listening"];

  return (
    <AdminLayout>
      <div className="p-6 md:p-8 max-w-6xl mx-auto space-y-6">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <h1 className="text-2xl font-bold md:text-3xl">Content Library</h1>
            <p className="text-muted-foreground mt-1">Manage all your IELTS test content.</p>
          </div>
          <Button asChild className="gap-2 bg-violet-600 hover:bg-violet-700 text-white">
            <Link to="/admin/create"><PlusCircle className="h-4 w-4" /> Create New</Link>
          </Button>
        </div>

        {/* Filters */}
        <div className="flex flex-col sm:flex-row gap-3">
          <div className="relative flex-1 max-w-sm">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
            <Input
              placeholder="Search content..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="pl-9"
            />
          </div>
          <div className="inline-flex h-10 items-center rounded-lg bg-muted p-1 text-muted-foreground">
            {tabs.map((t) => (
              <button
                key={t}
                onClick={() => setFilterModule(t)}
                className={cn(
                  "px-4 py-1.5 rounded-md text-sm font-medium transition-all",
                  filterModule === t
                    ? "bg-background text-foreground shadow-sm"
                    : "hover:bg-accent hover:text-accent-foreground"
                )}
              >
                {t}
              </button>
            ))}
          </div>
        </div>

        {/* Table */}
        <Card>
          <CardContent className="p-0">
            <div className="divide-y divide-border">
              {/* Header */}
              <div className="grid grid-cols-12 gap-4 px-6 py-3 text-xs font-medium text-muted-foreground uppercase tracking-wider bg-muted/50">
                <div className="col-span-5">Title</div>
                <div className="col-span-2">Status</div>
                <div className="col-span-1 text-center">Qs</div>
                <div className="col-span-1">Band</div>
                <div className="col-span-2">Edited</div>
                <div className="col-span-1"></div>
              </div>
              {filtered.map((item) => {
                const ModIcon = moduleIcons[item.module];
                return (
                  <div key={item.id} className="grid grid-cols-12 gap-4 px-6 py-4 items-center hover:bg-muted/30 transition-colors">
                    <div className="col-span-5 flex items-center gap-3">
                      <ModIcon className={cn("h-4 w-4 shrink-0", moduleColors[item.module])} />
                      <div className="min-w-0">
                        <p className="text-sm font-semibold truncate">{item.title}</p>
                        <p className="text-xs text-muted-foreground">{item.module}</p>
                      </div>
                    </div>
                    <div className="col-span-2">
                      <Badge variant="secondary" className={cn("text-[10px]", statusColors[item.status])}>{item.status}</Badge>
                    </div>
                    <div className="col-span-1 text-center text-sm text-muted-foreground">{item.questions}</div>
                    <div className="col-span-1 text-sm text-muted-foreground">{item.band}</div>
                    <div className="col-span-2 text-xs text-muted-foreground flex items-center gap-1">
                      <Clock className="h-3 w-3" /> {item.lastEdited}
                    </div>
                    <div className="col-span-1 flex justify-end">
                      <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                          <Button variant="ghost" size="icon" className="h-8 w-8">
                            <MoreHorizontal className="h-4 w-4" />
                          </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="end">
                          <DropdownMenuItem className="gap-2"><Edit3 className="h-3.5 w-3.5" /> Edit</DropdownMenuItem>
                          <DropdownMenuItem className="gap-2"><Eye className="h-3.5 w-3.5" /> Preview</DropdownMenuItem>
                          <DropdownMenuItem className="gap-2 text-destructive"><Trash2 className="h-3.5 w-3.5" /> Delete</DropdownMenuItem>
                        </DropdownMenuContent>
                      </DropdownMenu>
                    </div>
                  </div>
                );
              })}
              {filtered.length === 0 && (
                <div className="py-12 text-center text-muted-foreground">No content found.</div>
              )}
            </div>
          </CardContent>
        </Card>
      </div>
    </AdminLayout>
  );
};

export default ContentLibrary;
