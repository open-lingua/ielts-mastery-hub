import React from "react";
import { Link } from "react-router-dom";
import { BookOpen, PenTool, Headphones, Mic, ArrowRight, Star, Moon, Sun } from "lucide-react";
import { useTheme } from "@/contexts/ThemeContext";
import { ieltsModules } from "@/data/mockData";

const iconMap: Record<string, React.FC<{ className?: string }>> = {
  Headphones,
  BookOpen,
  PenTool,
  Mic,
};

const LandingPage: React.FC = () => {
  const { theme, toggleTheme } = useTheme();

  return (
    <div className="min-h-screen bg-background text-foreground">
      {/* Nav */}
      <nav className="sticky top-0 z-50 border-b border-border bg-card/80 backdrop-blur-lg">
        <div className="mx-auto flex h-16 max-w-6xl items-center justify-between px-4">
          <div className="flex items-center gap-2">
            <BookOpen className="h-6 w-6 text-primary" />
            <span className="text-lg font-bold text-primary">IELTS</span>
            <span className="text-lg font-medium">Mastery Hub</span>
          </div>
          <div className="flex items-center gap-3">
            <button
              onClick={toggleTheme}
              className="rounded-xl border border-border p-2 text-muted-foreground hover:bg-secondary"
            >
              {theme === "light" ? <Moon className="h-4 w-4" /> : <Sun className="h-4 w-4" />}
            </button>
            <Link
              to="/dashboard"
              className="rounded-xl bg-primary px-5 py-2 text-sm font-semibold text-primary-foreground transition-transform hover:scale-105"
            >
              Get Started
            </Link>
          </div>
        </div>
      </nav>

      {/* Hero */}
      <section className="relative overflow-hidden py-24 md:py-32">
        <div className="absolute inset-0 bg-gradient-to-br from-primary/5 via-transparent to-warning/5" />
        <div className="relative mx-auto max-w-6xl px-4 text-center">
          <div className="mb-6 inline-flex items-center gap-2 rounded-full border border-border bg-card px-4 py-1.5 text-sm text-muted-foreground">
            <Star className="h-4 w-4 text-warning" /> Trusted by 50,000+ IELTS students
          </div>
          <h1 className="mx-auto max-w-4xl text-4xl font-extrabold leading-tight tracking-tight md:text-6xl lg:text-7xl">
            Master the IELTS with{" "}
            <span className="bg-gradient-to-r from-primary to-primary/60 bg-clip-text text-transparent">
              AI-Powered Practice
            </span>
          </h1>
          <p className="mx-auto mt-6 max-w-2xl text-lg text-muted-foreground md:text-xl">
            Practice Writing, Reading, and Listening with instant AI feedback. Track your progress and achieve your target band score.
          </p>
          <div className="mt-10 flex flex-col items-center justify-center gap-4 sm:flex-row">
            <Link
              to="/dashboard"
              className="group flex items-center gap-2 rounded-xl bg-primary px-8 py-3.5 text-base font-semibold text-primary-foreground shadow-lg shadow-primary/25 transition-all hover:scale-105"
            >
              Start Practicing <ArrowRight className="h-4 w-4 transition-transform group-hover:translate-x-1" />
            </Link>
          </div>
        </div>
      </section>

      {/* About IELTS Modules */}
      <section className="border-t border-border bg-card py-20">
        <div className="mx-auto max-w-6xl px-4">
          <div className="mb-12 text-center">
            <h2 className="text-3xl font-bold md:text-4xl">The 4 IELTS Modules</h2>
            <p className="mt-3 text-muted-foreground">Understand the exam structure and prepare with confidence</p>
          </div>
          <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
            {ieltsModules.map((mod) => {
              const Icon = iconMap[mod.icon] || BookOpen;
              return (
                <div
                  key={mod.title}
                  className="group rounded-2xl border border-border bg-background p-6 transition-all hover:-translate-y-1 hover:shadow-lg"
                >
                  <div className="mb-4 flex h-12 w-12 items-center justify-center rounded-xl bg-primary/10 text-primary transition-colors group-hover:bg-primary group-hover:text-primary-foreground">
                    <Icon className="h-6 w-6" />
                  </div>
                  <h3 className="text-lg font-bold">{mod.title}</h3>
                  <p className="mt-2 text-sm text-muted-foreground leading-relaxed">{mod.description}</p>
                  <div className="mt-4 inline-block rounded-full bg-secondary px-3 py-1 text-xs font-semibold text-muted-foreground">
                    {mod.duration}
                  </div>
                </div>
              );
            })}
          </div>

          {/* Band Score */}
          <div className="mt-16 rounded-2xl border border-border bg-background p-8 text-center">
            <h3 className="text-2xl font-bold mb-3">Band Score System (0–9)</h3>
            <p className="text-muted-foreground mb-6 max-w-2xl mx-auto">Each module is scored on a scale of 0–9. Your overall band score is the average of all four modules, rounded to the nearest half band.</p>
            <div className="flex flex-wrap justify-center gap-3">
              {[
                { band: "9", label: "Expert" },
                { band: "8", label: "Very Good" },
                { band: "7", label: "Good" },
                { band: "6", label: "Competent" },
                { band: "5", label: "Modest" },
              ].map((b) => (
                <div key={b.band} className="rounded-xl border border-border bg-card px-4 py-3 text-center min-w-[100px]">
                  <div className="text-2xl font-bold text-primary">{b.band}</div>
                  <div className="text-xs text-muted-foreground mt-1">{b.label}</div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-border bg-card py-12">
        <div className="mx-auto max-w-6xl px-4">
          <div className="flex flex-col items-center justify-between gap-4 md:flex-row">
            <div className="flex items-center gap-2">
              <BookOpen className="h-5 w-5 text-primary" />
              <span className="font-bold text-primary">IELTS</span>
              <span className="font-medium">Mastery Hub</span>
            </div>
            <div className="flex gap-6 text-sm text-muted-foreground">
              <a href="#" className="hover:text-foreground">Resources</a>
              <a href="#" className="hover:text-foreground">Privacy</a>
              <a href="#" className="hover:text-foreground">Terms</a>
              <a href="#" className="hover:text-foreground">Contact</a>
            </div>
          </div>
          <p className="mt-6 text-center text-xs text-muted-foreground">
            © 2026 IELTS Mastery Hub. All rights reserved. Not affiliated with IDP or British Council.
          </p>
        </div>
      </footer>
    </div>
  );
};

export default LandingPage;
