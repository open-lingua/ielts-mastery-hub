import React, { useState } from "react";
import { CheckCircle, XCircle, BookOpen } from "lucide-react";
import { readingPassage } from "@/data/mockData";
import { DashboardLayout } from "@/components/DashboardLayout";

const ReadingModule: React.FC = () => {
  const [answers, setAnswers] = useState<Record<number, string>>({});
  const [submitted, setSubmitted] = useState(false);

  const handleAnswer = (qId: number, value: string) => {
    if (submitted) return;
    setAnswers((prev) => ({ ...prev, [qId]: value }));
  };

  const getScore = () => {
    return readingPassage.questions.filter((q) => answers[q.id]?.toLowerCase() === q.answer.toLowerCase()).length;
  };

  return (
    <DashboardLayout>
      <div className="flex flex-col md:flex-row h-[calc(100vh-4rem)] overflow-hidden">
        {/* Passage */}
        <div className="flex-1 overflow-y-auto border-b md:border-b-0 md:border-r border-border bg-card p-6 md:p-10">
          <div className="max-w-2xl mx-auto">
            <div className="flex items-center gap-2 mb-6">
              <BookOpen className="h-5 w-5 text-primary" />
              <h1 className="text-xl font-bold text-foreground">Reading Passage</h1>
            </div>
            <h2 className="text-2xl font-serif font-bold text-foreground mb-6">{readingPassage.title}</h2>
            {readingPassage.text.split("\n\n").map((para, i) => (
              <p key={i} className="text-base font-serif leading-[1.9] text-foreground/90 mb-4">{para}</p>
            ))}
          </div>
        </div>

        {/* Questions */}
        <div className="w-full md:w-[420px] lg:w-[480px] overflow-y-auto bg-background p-6 shrink-0">
          <h2 className="text-lg font-bold text-foreground mb-6">Questions</h2>

          {submitted && (
            <div className="mb-6 rounded-xl bg-primary/10 border border-primary/20 p-4 text-center">
              <span className="text-2xl font-bold text-primary">{getScore()}/{readingPassage.questions.length}</span>
              <span className="text-sm text-muted-foreground block mt-1">Correct Answers</span>
            </div>
          )}

          <div className="space-y-6">
            {readingPassage.questions.map((q, i) => (
              <div key={q.id} className="rounded-xl border border-border bg-card p-4">
                <p className="text-sm font-semibold text-foreground mb-3">
                  {i + 1}. {q.text}
                </p>
                {q.type === "tf" ? (
                  <div className="flex gap-2">
                    {["True", "False", "Not Given"].map((opt) => (
                      <button
                        key={opt}
                        onClick={() => handleAnswer(q.id, opt.toLowerCase())}
                        className={`rounded-lg border px-4 py-2 text-sm font-medium transition-colors ${
                          answers[q.id] === opt.toLowerCase()
                            ? "border-primary bg-primary/10 text-primary"
                            : "border-border text-muted-foreground hover:bg-secondary"
                        } ${submitted && q.answer === opt.toLowerCase() ? "!border-success !bg-success/10 !text-success" : ""} ${
                          submitted && answers[q.id] === opt.toLowerCase() && q.answer !== opt.toLowerCase()
                            ? "!border-destructive !bg-destructive/10 !text-destructive"
                            : ""
                        }`}
                      >
                        {opt}
                      </button>
                    ))}
                  </div>
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
                        } ${submitted && q.answer === opt ? "!border-success !bg-success/10 !text-success" : ""} ${
                          submitted && answers[q.id] === opt && q.answer !== opt
                            ? "!border-destructive !bg-destructive/10 !text-destructive"
                            : ""
                        }`}
                      >
                        {opt}
                      </button>
                    ))}
                  </div>
                )}
                {submitted && (
                  <div className="mt-2 flex items-center gap-1 text-xs">
                    {answers[q.id]?.toLowerCase() === q.answer.toLowerCase() ? (
                      <span className="text-success flex items-center gap-1"><CheckCircle className="h-3 w-3" /> Correct</span>
                    ) : (
                      <span className="text-destructive flex items-center gap-1"><XCircle className="h-3 w-3" /> Answer: {q.answer}</span>
                    )}
                  </div>
                )}
              </div>
            ))}
          </div>

          {!submitted ? (
            <button
              onClick={() => setSubmitted(true)}
              disabled={Object.keys(answers).length < readingPassage.questions.length}
              className="mt-6 w-full rounded-xl bg-primary py-3 text-sm font-semibold text-primary-foreground shadow-lg shadow-primary/20 disabled:opacity-50 transition-all hover:scale-[1.02]"
            >
              Check Answers
            </button>
          ) : (
            <button
              onClick={() => { setAnswers({}); setSubmitted(false); }}
              className="mt-6 w-full rounded-xl border border-border py-3 text-sm font-semibold text-foreground hover:bg-secondary transition-colors"
            >
              Try Again
            </button>
          )}
        </div>
      </div>
    </DashboardLayout>
  );
};

export default ReadingModule;
