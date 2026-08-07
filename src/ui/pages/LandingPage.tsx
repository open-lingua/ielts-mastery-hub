import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { BookOpen, PenTool, Headphones, Mic, ArrowRight, CheckCircle2, Star, Moon, Sun, ChevronRight, Sparkles, Loader2 } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { Switch } from "@/components/ui/switch";
import { Badge } from "@/components/ui/badge";
import { fetchPlans, type Plan } from "@/services/pricingService";
import { useTheme } from "@/contexts/ThemeContext";
import { useAuth } from "@/contexts/AuthContext";
import { ieltsModules } from "@/data/mockData";

const iconMap: Record<string, React.FC<{ className?: string }>> = {
  Headphones,
  BookOpen,
  PenTool,
  Mic,
};

const LandingPricing: React.FC = () => {
  const [isYearly, setIsYearly] = useState(false);
  const [plans, setPlans] = useState<Plan[]>([]);
  const [loading, setLoading] = useState(true);
  const { user } = useAuth();

  useEffect(() => {
    fetchPlans().then(setPlans).catch(console.error).finally(() => setLoading(false));
  }, []);

  const displayed = plans.filter(p => p.billing_period === (isYearly ? "yearly" : "monthly"));

  return (
    <section id="pricing" className="py-20">
      <div className="mx-auto max-w-6xl px-4">
        <div className="mb-12 text-center">
          <h2 className="text-3xl font-bold md:text-4xl">Simple, Transparent Pricing</h2>
          <p className="mt-3 text-muted-foreground">Start free. Upgrade when you're ready.</p>
          <div className="flex items-center justify-center gap-3 mt-6">
            <span className={`text-sm font-medium ${!isYearly ? "text-foreground" : "text-muted-foreground"}`}>Monthly</span>
            <Switch checked={isYearly} onCheckedChange={setIsYearly} />
            <span className={`text-sm font-medium ${isYearly ? "text-foreground" : "text-muted-foreground"}`}>Yearly</span>
            {isYearly && (
              <Badge variant="secondary" className="ml-1 bg-success/15 text-success border-success/30 text-xs">Save ~20%</Badge>
            )}
          </div>
        </div>

        {loading ? (
          <div className="flex justify-center py-16"><Loader2 className="h-8 w-8 animate-spin text-muted-foreground" /></div>
        ) : (
          <div className="mx-auto grid max-w-5xl gap-8 md:grid-cols-3">
            <AnimatePresence mode="wait">
              {displayed.map((plan) => (
                <motion.div
                  key={plan.id}
                  initial={{ opacity: 0, y: 16 }}
                  animate={{ opacity: 1, y: 0 }}
                  exit={{ opacity: 0, y: -16 }}
                  transition={{ duration: 0.25 }}
                  className={`relative rounded-2xl border bg-card p-8 flex flex-col ${
                    plan.is_popular
                      ? "border-2 border-primary shadow-lg shadow-primary/10 ring-2 ring-primary/20"
                      : "border-border"
                  }`}
                >
                  {plan.is_popular && (
                    <div className="absolute -top-3 left-1/2 -translate-x-1/2">
                      <Badge className="bg-primary text-primary-foreground gap-1"><Sparkles className="h-3 w-3" /> Most Popular</Badge>
                    </div>
                  )}
                  <h3 className="text-xl font-bold">{plan.name}</h3>
                  <p className="mt-1 text-sm text-muted-foreground">{plan.description}</p>
                  <div className="mt-5">
                    <span className="text-4xl font-extrabold">${plan.price.toFixed(2)}</span>
                    <span className="text-muted-foreground ml-1">/{isYearly ? "year" : "month"}</span>
                  </div>
                  <ul className="mt-6 space-y-3 text-sm flex-1">
                    {plan.features.map((f, i) => (
                      <li key={i} className="flex items-start gap-2 text-muted-foreground">
                        <CheckCircle2 className="h-4 w-4 mt-0.5 shrink-0 text-success" /> {f}
                      </li>
                    ))}
                  </ul>
                  <button
                    onClick={() => {
                      const url = new URL(plan.checkout_url);
                      if (user?.email) {
                        url.searchParams.set("checkout[custom][user_email]", user.email);
                        url.searchParams.set("checkout[email]", user.email);
                      }
                      window.location.href = url.toString();
                    }}
                    className={`mt-8 w-full rounded-xl py-3 text-sm font-bold transition-transform hover:scale-105 ${
                      plan.is_popular
                        ? "bg-primary text-primary-foreground shadow-lg shadow-primary/25"
                        : "border border-border text-foreground hover:bg-secondary"
                    }`}
                  >
                    Subscribe
                  </button>
                </motion.div>
              ))}
            </AnimatePresence>
          </div>
        )}
      </div>
    </section>
  );
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
              Start Free Practice <ArrowRight className="h-4 w-4 transition-transform group-hover:translate-x-1" />
            </Link>
            <a
              href="#pricing"
              className="flex items-center gap-2 rounded-xl border border-border bg-card px-8 py-3.5 text-base font-semibold text-foreground transition-colors hover:bg-secondary"
            >
              Go Premium <ChevronRight className="h-4 w-4" />
            </a>
          </div>
          <Link to="/dashboard" className="mt-4 inline-block text-sm text-muted-foreground hover:text-foreground transition-colors">
            Try for free — no login required →
          </Link>
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

      <LandingPricing />

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
