import React, { useState } from "react";
import { Play, Pause, SkipForward, Volume2, Headphones } from "lucide-react";
import { listeningQuestions } from "@/data/mockData";
import { DashboardLayout } from "@/components/DashboardLayout";

const ListeningModule: React.FC = () => {
  const [isPlaying, setIsPlaying] = useState(false);
  const [progress, setProgress] = useState(35);
  const [answers, setAnswers] = useState<Record<number, string>>({});
  const [submitted, setSubmitted] = useState(false);

  const allQuestions = listeningQuestions.flatMap((s) => s.questions);

  const handleAnswer = (qId: number, value: string) => {
    if (submitted) return;
    setAnswers((prev) => ({ ...prev, [qId]: value }));
  };

  const getScore = () => allQuestions.filter((q) => answers[q.id]?.toLowerCase() === q.answer.toLowerCase()).length;

  return (
    <DashboardLayout>
      <div className="flex flex-col h-[calc(100vh-4rem)]">
        {/* Content */}
        <div className="flex-1 overflow-y-auto p-4 md:p-8">
          <div className="max-w-3xl mx-auto space-y-8">
            <div className="flex items-center gap-2">
              <Headphones className="h-5 w-5 text-primary" />
              <h1 className="text-xl font-bold text-foreground">Listening Practice</h1>
            </div>

            {submitted && (
              <div className="rounded-xl bg-primary/10 border border-primary/20 p-4 text-center">
                <span className="text-2xl font-bold text-primary">{getScore()}/{allQuestions.length}</span>
                <span className="text-sm text-muted-foreground block mt-1">Correct Answers</span>
              </div>
            )}

            {listeningQuestions.map((section) => (
              <div key={section.id} className="rounded-2xl border border-border bg-card p-6">
                <div className="flex items-center gap-2 mb-1">
                  <span className="text-xs font-bold text-primary uppercase tracking-wider">{section.section}</span>
                </div>
                <h2 className="text-lg font-bold text-foreground mb-4">{section.title}</h2>

                <div className="space-y-4">
                  {section.questions.map((q, i) => (
                    <div key={q.id} className="rounded-xl bg-background border border-border p-4">
                      <p className="text-sm font-semibold text-foreground mb-3">Q{q.id}. {q.text}</p>
                      {q.type === "fill" ? (
                        <input
                          type="text"
                          value={answers[q.id] || ""}
                          onChange={(e) => handleAnswer(q.id, e.target.value)}
                          disabled={submitted}
                          placeholder="Type your answer..."
                          className="w-full rounded-lg border border-border bg-card px-4 py-2.5 text-sm text-foreground placeholder:text-muted-foreground/40 outline-none focus:ring-2 focus:ring-primary/30 disabled:opacity-60"
                        />
                      ) : (
                        <div className="space-y-2">
                          {q.options?.map((opt) => (
                            <button
                              key={opt}
                              onClick={() => handleAnswer(q.id, opt)}
                              className={`w-full text-left rounded-lg border px-4 py-2.5 text-sm transition-colors ${
                                answers[q.id] === opt
                                  ? "border-primary bg-primary/10 text-primary"
                                  : "border-border text-muted-foreground hover:bg-secondary"
                              } ${submitted && q.answer === opt ? "!border-success !bg-success/10 !text-success" : ""}`}
                            >
                              {opt}
                            </button>
                          ))}
                        </div>
                      )}
                      {submitted && (
                        <p className={`mt-2 text-xs font-medium ${answers[q.id]?.toLowerCase() === q.answer.toLowerCase() ? "text-success" : "text-destructive"}`}>
                          {answers[q.id]?.toLowerCase() === q.answer.toLowerCase() ? "✓ Correct" : `✗ Answer: ${q.answer}`}
                        </p>
                      )}
                    </div>
                  ))}
                </div>
              </div>
            ))}

            {!submitted ? (
              <button
                onClick={() => setSubmitted(true)}
                className="w-full rounded-xl bg-primary py-3 text-sm font-semibold text-primary-foreground shadow-lg shadow-primary/20 transition-all hover:scale-[1.02]"
              >
                Check Answers
              </button>
            ) : (
              <button
                onClick={() => { setAnswers({}); setSubmitted(false); }}
                className="w-full rounded-xl border border-border py-3 text-sm font-semibold text-foreground hover:bg-secondary transition-colors"
              >
                Try Again
              </button>
            )}
          </div>
        </div>

        {/* Audio Player Bar */}
        <div className="shrink-0 border-t border-border bg-card px-4 py-3 md:px-8">
          <div className="max-w-3xl mx-auto flex items-center gap-4">
            <button
              onClick={() => setIsPlaying(!isPlaying)}
              className="flex h-10 w-10 items-center justify-center rounded-full bg-primary text-primary-foreground shadow-md hover:scale-105 transition-transform"
            >
              {isPlaying ? <Pause className="h-4 w-4" /> : <Play className="h-4 w-4 ml-0.5" />}
            </button>
            <div className="flex-1">
              <div className="h-2 w-full rounded-full bg-secondary overflow-hidden">
                <div className="h-full rounded-full bg-primary transition-all" style={{ width: `${progress}%` }} />
              </div>
              <div className="flex justify-between mt-1 text-[10px] text-muted-foreground font-mono">
                <span>02:48</span>
                <span>08:00</span>
              </div>
            </div>
            <Volume2 className="h-4 w-4 text-muted-foreground" />
          </div>
        </div>
      </div>
    </DashboardLayout>
  );
};

export default ListeningModule;
