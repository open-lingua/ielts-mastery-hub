import { useEffect, useState } from "react";
import { CreditCard, Receipt, ShieldCheck, AlertCircle, ExternalLink, Loader2 } from "lucide-react";
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { DashboardLayout } from "@/components/DashboardLayout";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/contexts/AuthContext";
import { format } from "date-fns";

interface Subscription {
  id: string;
  status: string;
  current_period_end: string | null;
  current_period_start: string | null;
  cancelled_at: string | null;
  plans: { name: string; price: number; billing_period: string } | null;
}

interface Payment {
  id: string;
  amount: number;
  currency: string;
  status: string;
  created_at: string;
  receipt_url: string | null;
  payment_method: string | null;
  plans: { name: string } | null;
}

const statusColors: Record<string, string> = {
  active: "bg-success/15 text-success border-success/30",
  completed: "bg-success/15 text-success border-success/30",
  cancelled: "bg-destructive/15 text-destructive border-destructive/30",
  pending: "bg-warning/15 text-warning border-warning/30",
  expired: "bg-muted text-muted-foreground border-border",
};

export default function BillingPage() {
  const { user } = useAuth();
  const [subscription, setSubscription] = useState<Subscription | null>(null);
  const [payments, setPayments] = useState<Payment[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!user) return;

    const fetchBilling = async () => {
      const [subRes, payRes] = await Promise.all([
        supabase
          .from("subscriptions")
          .select("id, status, current_period_end, current_period_start, cancelled_at, plans(name, price, billing_period)")
          .eq("user_id", user.id)
          .order("created_at", { ascending: false })
          .limit(1)
          .maybeSingle(),
        supabase
          .from("payments")
          .select("id, amount, currency, status, created_at, receipt_url, payment_method, plans(name)")
          .eq("user_id", user.id)
          .order("created_at", { ascending: false }),
      ]);

      if (subRes.data) setSubscription(subRes.data as unknown as Subscription);
      if (payRes.data) setPayments(payRes.data as unknown as Payment[]);
      setLoading(false);
    };

    fetchBilling();
  }, [user]);

  if (loading) {
    return (
      <DashboardLayout>
        <div className="flex items-center justify-center h-full">
          <Loader2 className="h-8 w-8 animate-spin text-muted-foreground" />
        </div>
      </DashboardLayout>
    );
  }

  return (
    <DashboardLayout>
      <div className="max-w-4xl mx-auto p-6 space-y-8">
        <div>
          <h1 className="text-2xl font-bold text-foreground">Billing & Subscription</h1>
          <p className="text-muted-foreground mt-1">Manage your plan and view payment history.</p>
        </div>

        {/* Current Plan */}
        <Card>
          <CardHeader className="flex flex-row items-start gap-4">
            <div className="rounded-lg bg-primary/10 p-2.5">
              <ShieldCheck className="h-5 w-5 text-primary" />
            </div>
            <div className="flex-1">
              <CardTitle className="text-lg">Current Plan</CardTitle>
              <CardDescription>Your active subscription details</CardDescription>
            </div>
          </CardHeader>
          <CardContent>
            {subscription ? (
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div className="space-y-1">
                  <p className="text-xl font-semibold text-foreground">
                    {subscription.plans?.name ?? "Unknown Plan"}
                  </p>
                  <p className="text-sm text-muted-foreground">
                    ${subscription.plans?.price?.toFixed(2)} / {subscription.plans?.billing_period}
                  </p>
                  {subscription.current_period_end && (
                    <p className="text-sm text-muted-foreground">
                      Renews on {format(new Date(subscription.current_period_end), "MMM d, yyyy")}
                    </p>
                  )}
                </div>
                <Badge variant="outline" className={statusColors[subscription.status] || statusColors.pending}>
                  {subscription.status}
                </Badge>
              </div>
            ) : (
              <div className="flex items-center gap-3 text-muted-foreground">
                <AlertCircle className="h-5 w-5" />
                <p>No active subscription. <a href="/pricing" className="text-primary underline">View plans</a></p>
              </div>
            )}
          </CardContent>
        </Card>

        {/* Payment History */}
        <Card>
          <CardHeader className="flex flex-row items-start gap-4">
            <div className="rounded-lg bg-primary/10 p-2.5">
              <CreditCard className="h-5 w-5 text-primary" />
            </div>
            <div className="flex-1">
              <CardTitle className="text-lg">Payment History</CardTitle>
              <CardDescription>Your recent transactions</CardDescription>
            </div>
          </CardHeader>
          <CardContent>
            {payments.length === 0 ? (
              <p className="text-sm text-muted-foreground">No payments recorded yet.</p>
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Date</TableHead>
                    <TableHead>Plan</TableHead>
                    <TableHead>Amount</TableHead>
                    <TableHead>Status</TableHead>
                    <TableHead className="text-right">Receipt</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {payments.map((p) => (
                    <TableRow key={p.id}>
                      <TableCell className="text-sm">
                        {format(new Date(p.created_at), "MMM d, yyyy")}
                      </TableCell>
                      <TableCell className="text-sm">{p.plans?.name ?? "—"}</TableCell>
                      <TableCell className="text-sm font-medium">
                        {p.currency} ${p.amount.toFixed(2)}
                      </TableCell>
                      <TableCell>
                        <Badge variant="outline" className={statusColors[p.status] || statusColors.pending}>
                          {p.status}
                        </Badge>
                      </TableCell>
                      <TableCell className="text-right">
                        {p.receipt_url ? (
                          <Button variant="ghost" size="sm" asChild>
                            <a href={p.receipt_url} target="_blank" rel="noopener noreferrer">
                              <Receipt className="h-4 w-4 mr-1" />
                              View
                            </a>
                          </Button>
                        ) : (
                          <span className="text-xs text-muted-foreground">—</span>
                        )}
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            )}
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  );
}
