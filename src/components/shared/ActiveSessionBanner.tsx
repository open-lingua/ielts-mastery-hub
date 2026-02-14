import React from "react";
import { Link } from "react-router-dom";
import { AlertTriangle, ArrowRight } from "lucide-react";
import { motion } from "framer-motion";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import type { TestModule } from "@/services/practiceLibraryService";

interface ActiveSessionBannerProps {
  testTitle: string;
  testType: TestModule;
  testId: string;
}

const moduleLabels: Record<TestModule, string> = {
  reading: "Reading",
  writing: "Writing",
  listening: "Listening",
};

const ActiveSessionBanner: React.FC<ActiveSessionBannerProps> = ({
  testTitle,
  testType,
  testId,
}) => {
  const route = `/${testType}?id=${testId}`;

  return (
    <motion.div
      initial={{ height: 0, opacity: 0 }}
      animate={{ height: "auto", opacity: 1 }}
      transition={{ duration: 0.3 }}
      className="rounded-xl border border-warning/30 bg-warning/5 p-4"
    >
      <div className="flex flex-col sm:flex-row items-start sm:items-center gap-3">
        <div className="flex items-center gap-2 shrink-0">
          <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-warning/10">
            <AlertTriangle className="h-4 w-4 text-warning" />
          </div>
        </div>
        <div className="flex-1 min-w-0 space-y-0.5">
          <p className="text-sm font-semibold text-foreground">
            You have an active test in progress
          </p>
          <p className="text-xs text-muted-foreground truncate">
            <Badge variant="outline" className="text-[10px] mr-1.5">
              {moduleLabels[testType]}
            </Badge>
            {testTitle}
          </p>
        </div>
        <Button asChild size="sm" className="gap-1.5 shrink-0">
          <Link to={route}>
            Resume Test
            <ArrowRight className="h-3.5 w-3.5" />
          </Link>
        </Button>
      </div>
    </motion.div>
  );
};

export default ActiveSessionBanner;
