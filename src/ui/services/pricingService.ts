import { supabase } from "@/integrations/supabase/client";

export interface Plan {
  id: string;
  name: string;
  description: string | null;
  price: number;
  billing_period: "monthly" | "yearly";
  features: string[];
  checkout_url: string;
  is_popular: boolean;
  sort_order: number;
  lemon_squeezy_variant_id: string | null;
}

export async function fetchPlans(): Promise<Plan[]> {
  const { data, error } = await supabase
    .from("plans")
    .select("*")
    .order("sort_order", { ascending: true });

  if (error) throw error;

  return (data ?? []).map((row) => ({
    ...row,
    billing_period: row.billing_period as "monthly" | "yearly",
    price: Number(row.price),
    features:
      typeof row.features === "string"
        ? JSON.parse(row.features)
        : (row.features as string[]),
  }));
}
