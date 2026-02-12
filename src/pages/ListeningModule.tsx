import React, { useState, useCallback, useRef } from "react";
import { Headphones, ChevronRight, Lock, Info } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { DashboardLayout } from "@/components/DashboardLayout";
import { TooltipProvider } from "@/components/ui/tooltip";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import SectionStepper from "@/components/listening/SectionStepper";
import AudioPlayer from "@/components/listening/AudioPlayer";
import QuestionCard from "@/components/listening/QuestionCard";
import ResultsCard from "@/components/listening/ResultsCard";
import UnifiedTimer, { TimeUpOverlay } from "@/components/shared/UnifiedTimer";
import { mockListeningTest } from "@/data/listeningTestData";
import { cn } from "@/lib/utils";

const ListeningModule: React.FC = () => {
  const test = mockListeningTest;
  const totalSections = test.sections.length;

  const [activeSection, setActiveSection] = useState(0);
  const [unlockedSections, setUnlockedSections] = useState<boolean[]>([true, false, false, false]);
  const [completedSections, setCompletedSections] = useState<boolean[]>([false, false, false, false]);
  const [audioEnded, setAudioEnded] = useState<boolean[]>([false, false, false, false]);
  const [answers, setAnswers] = useState<Record<string, string>>({});
  const [testFinished, setTestFinished] = useState(false);
  const [reviewMode, setReviewMode] = useState(false);
  const [autoSubmitted, setAutoSubmitted] = useState(false);
  const [timerKey, setTimerKey] = useState(0); // for resetting timer on retry

  const contentRef = useRef<HTMLDivElement>(null);

  const scrollToTop = () => {
    contentRef.current?.scrollTo({ top: 0, behavior: "smooth" });
  };

  const handleAudioEnded = useCallback((sectionIndex: number) => {
    setAudioEnded((prev) => {
      const next = [...prev];
      next[sectionIndex] = true;
      return next;
    });
  }, []);

  const handleAnswer = (qId: string, value: string) => {
    if (testFinished) return;
    setAnswers((prev) => ({ ...prev, [qId]: value }));
  };

  const handleSubmitSection = () => {
    const nextIndex = activeSection + 1;
    setCompletedSections((prev) => {
      const next = [...prev];
      next[activeSection] = true;
      return next;
    });
    if (nextIndex < totalSections) {
      setUnlockedSections((prev) => {
        const next = [...prev];
        next[nextIndex] = true;
        return next;
      });
      setActiveSection(nextIndex);
      scrollToTop();
    } else {
      setTestFinished(true);
      scrollToTop();
    }
  };

  const handleTimeUp = useCallback(() => {
    if (testFinished) return;
    setAutoSubmitted(true);
    setCompletedSections([true, true, true, true]);
    setTestFinished(true);
  }, [testFinished]);

  const handleRetry = () => {
    setActiveSection(0);
    setUnlockedSections([true, false, false, false]);
    setCompletedSections([false, false, false, false]);
    setAudioEnded([false, false, false, false]);
    setAnswers({});
    setTestFinished(false);
    setReviewMode(false);
    setAutoSubmitted(false);
    setTimerKey((k) => k + 1);
    scrollToTop();
  };

  const currentSection = test.sections[activeSection];
  const sectionQuestions = currentSection.questions;
  const answeredCount = sectionQuestions.filter((q) => answers[q.id]?.trim()).length;
  const hasAtLeastOne = answeredCount > 0;
  const canSubmit = hasAtLeastOne;
  const globalOffset = test.sections
    .slice(0, activeSection)
    .reduce((acc, s) => acc + s.questions.length, 0);

  return (
    <DashboardLayout>
      <TooltipProvider>
        <div className="flex flex-col h-[calc(100vh-4rem)]">
          {/* Unified Timer */}
          <UnifiedTimer
            key={timerKey}
            totalSeconds={1800}
            onTimeUp={handleTimeUp}
            testFinished={testFinished}
          />

          {/* Sticky Header */}
          <div className="shrink-0 border-b border-border bg-card px-4 py-3 md:px-8 space-y-3">
            <div className="max-w-4xl mx-auto">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <Headphones className="h-5 w-5 text-primary" />
                  <h1 className="text-lg font-bold text-foreground">{test.title}</h1>
                </div>
                {!testFinished && (
                  <Badge variant="outline" className="text-xs">
                    Section {activeSection + 1} of {totalSections}
                  </Badge>
                )}
              </div>
              <div className="mt-3">
                <SectionStepper
                  totalSections={totalSections}
                  activeSection={activeSection}
                  completedSections={completedSections}
                  unlockedSections={unlockedSections}
                  onSectionClick={(i) => {
                    if (unlockedSections[i]) {
                      setActiveSection(i);
                      scrollToTop();
                    }
                  }}
                />
              </div>
            </div>
          </div>

          {/* Scrollable Content */}
          <div ref={contentRef} className="flex-1 overflow-y-auto p-4 md:p-8">
            <div className="max-w-4xl mx-auto">
              <AnimatePresence mode="wait">
                {testFinished ? (
                  <motion.div
                    key="results"
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -20 }}
                    transition={{ duration: 0.3 }}
                    className="space-y-6"
                  >
                    <ResultsCard
                      test={test}
                      answers={answers}
                      reviewMode={reviewMode}
                      onToggleReview={() => setReviewMode((r) => !r)}
                      onRetry={handleRetry}
                    />
                    {reviewMode && (
                      <div className="space-y-6">
                        {test.sections.map((section) => {
                          const offset = test.sections
                            .slice(0, section.id - 1)
                            .reduce((acc, s) => acc + s.questions.length, 0);
                          return (
                            <div key={section.id} className="rounded-2xl border border-border bg-card p-6 space-y-4">
                              <div>
                                <Badge variant="secondary" className="text-[10px] uppercase tracking-wider mb-2">
                                  {section.context}
                                </Badge>
                                <h3 className="text-base font-bold text-foreground">{section.title}</h3>
                              </div>
                              <div className="space-y-3">
                                {section.questions.map((q, qi) => (
                                  <QuestionCard
                                    key={q.id}
                                    question={q}
                                    index={offset + qi + 1}
                                    answer={answers[q.id] || ""}
                                    onAnswer={() => {}}
                                    submitted={true}
                                    reviewMode={true}
                                  />
                                ))}
                              </div>
                            </div>
                          );
                        })}
                      </div>
                    )}
                  </motion.div>
                ) : (
                  <motion.div
                    key={`section-${activeSection}`}
                    initial={{ opacity: 0, x: 40 }}
                    animate={{ opacity: 1, x: 0 }}
                    exit={{ opacity: 0, x: -40 }}
                    transition={{ duration: 0.3 }}
                    className="space-y-6"
                  >
                    <div className="rounded-2xl border border-border bg-card p-6">
                      <Badge variant="secondary" className="text-[10px] uppercase tracking-wider mb-2">
                        {currentSection.context}
                      </Badge>
                      <h2 className="text-xl font-bold text-foreground">{currentSection.title}</h2>
                      <p className="text-sm text-muted-foreground mt-1">{currentSection.subtitle}</p>
                      <Separator className="my-4" />
                      <AudioPlayer
                        sectionIndex={activeSection}
                        onEnded={() => handleAudioEnded(activeSection)}
                        disabled={completedSections[activeSection]}
                      />
                      <div className="mt-4 flex items-start gap-2 rounded-lg bg-primary/5 border border-primary/10 p-3">
                        <Info className="h-4 w-4 text-primary shrink-0 mt-0.5" />
                        <p className="text-xs text-foreground leading-relaxed">{currentSection.instructions}</p>
                      </div>
                    </div>

                    <div className="space-y-3">
                      <div className="flex items-center justify-between">
                        <p className="text-sm font-semibold text-foreground">
                          Questions {globalOffset + 1}–{globalOffset + sectionQuestions.length}
                        </p>
                        <p className="text-xs text-muted-foreground">
                          {answeredCount}/{sectionQuestions.length} answered
                        </p>
                      </div>
                      {sectionQuestions.map((q, qi) => (
                        <QuestionCard
                          key={q.id}
                          question={q}
                          index={globalOffset + qi + 1}
                          answer={answers[q.id] || ""}
                          onAnswer={(val) => handleAnswer(q.id, val)}
                          submitted={testFinished}
                          reviewMode={reviewMode}
                        />
                      ))}
                    </div>

                    <motion.div
                      animate={canSubmit ? { scale: [1, 1.02, 1] } : {}}
                      transition={{ duration: 0.4 }}
                    >
                      <Button
                        onClick={handleSubmitSection}
                        disabled={!canSubmit}
                        className="w-full gap-2 rounded-xl py-3 text-sm font-semibold shadow-lg shadow-primary/20"
                        size="lg"
                      >
                        {activeSection < totalSections - 1 ? (
                          <>Submit & Continue to Section {activeSection + 2} <ChevronRight className="h-4 w-4" /></>
                        ) : (
                          "Submit & View Results"
                        )}
                      </Button>
                    </motion.div>
                    {!canSubmit && (
                      <p className="text-center text-xs text-muted-foreground">
                        Answer at least one question to proceed.
                      </p>
                    )}
                  </motion.div>
                )}
              </AnimatePresence>
            </div>
          </div>
        </div>

        <TimeUpOverlay show={autoSubmitted} onDismiss={() => setAutoSubmitted(false)} />
      </TooltipProvider>
    </DashboardLayout>
  );
};

export default ListeningModule;
