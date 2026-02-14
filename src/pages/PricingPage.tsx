import { useEffect, useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { CheckCircle2, Sparkles, Loader2 } from "lucide-react";
import { Switch } from "@/components/ui/switch";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter } from "@/components/ui/card";
import { fetchPlans, type Plan } from "@/services/pricingService";
import { useNavigate } from "react-router-dom";

export default function PricingPage() {
  const [isYearly, setIsYearly] = useState(false);
  const [plans, setPlans] = useState<Plan[]>([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    fetchPlans()
      .then(setPlans)
      .catch(console.error)
      .finally(() => setLoading(false));
  }, []);

  const displayed = plans.filter(
    (p) => p.billing_period === (isYearly ? "yearly" : "monthly")
  );

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="border-b border-border bg-card/60 backdrop-blur-sm sticky top-0 z-30">
        <div className="max-w-6xl mx-auto flex items-center justify-between px-6 py-4">
          <button onClick={() => navigate("/")} className="text-xl font-bold text-primary tracking-tight">
            SkillUp IELTS
          </button>
          <Button variant="outline" size="sm" onClick={() => navigate("/login")}>
            Sign In
          </Button>
        </div>
      </header>

      <main className="max-w-6xl mx-auto px-6 py-16">
        {/* Title */}
        <div className="text-center space-y-4 mb-12">
          <h1 className="text-4xl md:text-5xl font-extrabold tracking-tight text-foreground">
            Simple, Transparent Pricing
          </h1>
          <p className="text-lg text-muted-foreground max-w-2xl mx-auto">
            Choose the plan that fits your IELTS preparation journey. Upgrade or cancel anytime.
          </p>

          {/* Toggle */}
          <div className="flex items-center justify-center gap-3 pt-4">
            <span className={`text-sm font-medium ${!isYearly ? "text-foreground" : "text-muted-foreground"}`}>
              Monthly
            </span>
            <Switch checked={isYearly} onCheckedChange={setIsYearly} />
            <span className={`text-sm font-medium ${isYearly ? "text-foreground" : "text-muted-foreground"}`}>
              Yearly
            </span>
            {isYearly && (
              <Badge variant="secondary" className="ml-1 bg-success/15 text-success border-success/30 text-xs">
                Save ~20%
              </Badge>
            )}
          </div>
        </div>

        {/* Cards */}
        {loading ? (
          <div className="flex justify-center py-20">
            <Loader2 className="h-8 w-8 animate-spin text-muted-foreground" />
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <AnimatePresence mode="wait">
              {displayed.map((plan) => (
                <motion.div
                  key={plan.id}
                  initial={{ opacity: 0, y: 16 }}
                  animate={{ opacity: 1, y: 0 }}
                  exit={{ opacity: 0, y: -16 }}
                  transition={{ duration: 0.3 }}
                  className="flex"
                >
                  <Card
                    className={`flex flex-col w-full relative ${
                      plan.is_popular
                        ? "border-primary shadow-lg shadow-primary/10 ring-2 ring-primary/20"
                        : "border-border"
                    }`}
                  >
                    {plan.is_popular && (
                      <div className="absolute -top-3 left-1/2 -translate-x-1/2">
                        <Badge className="bg-primary text-primary-foreground gap-1">
                          <Sparkles className="h-3 w-3" /> Most Popular
                        </Badge>
                      </div>
                    )}

                    <CardHeader className="pt-8">
                      <CardTitle className="text-xl">{plan.name}</CardTitle>
                      <CardDescription>{plan.description}</CardDescription>
                    </CardHeader>

                    <CardContent className="flex-1 space-y-6">
                      <div>
                        <span className="text-4xl font-extrabold text-foreground">
                          ${plan.price.toFixed(2)}
                        </span>
                        <span className="text-muted-foreground ml-1">
                          /{isYearly ? "year" : "month"}
                        </span>
                      </div>

                      <ul className="space-y-3">
                        {plan.features.map((f, i) => (
                          <li key={i} className="flex items-start gap-2 text-sm text-foreground">
                            <CheckCircle2 className="h-4 w-4 mt-0.5 shrink-0 text-success" />
                            {f}
                          </li>
                        ))}
                      </ul>
                    </CardContent>

                    <CardFooter>
                      <Button
                        className="w-full"
                        variant={plan.is_popular ? "default" : "outline"}
                        onClick={() => {
                          window.location.href = plan.checkout_url;
                        }}
                      >
                        Subscribe
                      </Button>
                    </CardFooter>
                  </Card>
                </motion.div>
              ))}
            </AnimatePresence>
          </div>
        )}
      </main>
    </div>
  );
}
