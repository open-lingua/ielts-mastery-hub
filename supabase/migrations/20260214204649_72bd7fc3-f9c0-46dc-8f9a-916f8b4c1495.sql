
-- Create plans table
CREATE TABLE public.plans (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  billing_period TEXT NOT NULL CHECK (billing_period IN ('monthly', 'yearly')),
  features JSONB NOT NULL DEFAULT '[]',
  checkout_url TEXT NOT NULL,
  is_popular BOOLEAN DEFAULT false,
  sort_order INTEGER DEFAULT 0,
  lemon_squeezy_variant_id TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS (public read access for plans)
ALTER TABLE public.plans ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Plans are publicly readable" 
ON public.plans 
FOR SELECT 
USING (true);

CREATE TRIGGER update_plans_updated_at
BEFORE UPDATE ON public.plans
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Create subscriptions table
CREATE TABLE public.subscriptions (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID,
  user_email TEXT NOT NULL,
  plan_id UUID REFERENCES public.plans(id) ON DELETE SET NULL,
  lemon_squeezy_subscription_id TEXT,
  lemon_squeezy_customer_id TEXT,
  lemon_squeezy_order_id TEXT,
  status TEXT NOT NULL DEFAULT 'pending',
  variant_id TEXT,
  current_period_start TIMESTAMP WITH TIME ZONE,
  current_period_end TIMESTAMP WITH TIME ZONE,
  cancelled_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  CONSTRAINT subscriptions_lemon_squeezy_subscription_id_key UNIQUE (lemon_squeezy_subscription_id)
);

-- Create payments table
CREATE TABLE public.payments (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID,
  user_email TEXT NOT NULL,
  subscription_id UUID REFERENCES public.subscriptions(id) ON DELETE SET NULL,
  plan_id UUID REFERENCES public.plans(id) ON DELETE SET NULL,
  lemon_squeezy_order_id TEXT,
  lemon_squeezy_payment_id TEXT,
  amount NUMERIC NOT NULL,
  currency TEXT NOT NULL DEFAULT 'USD',
  status TEXT NOT NULL DEFAULT 'pending',
  payment_method TEXT,
  receipt_url TEXT,
  refunded_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;

-- RLS policies
CREATE POLICY "Users can view their own subscriptions" 
ON public.subscriptions 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can view their own payments" 
ON public.payments 
FOR SELECT 
USING (auth.uid() = user_id);

-- Indexes
CREATE INDEX idx_subscriptions_user_id ON public.subscriptions(user_id);
CREATE INDEX idx_subscriptions_user_email ON public.subscriptions(user_email);
CREATE INDEX idx_subscriptions_lemon_squeezy_subscription_id ON public.subscriptions(lemon_squeezy_subscription_id);
CREATE INDEX idx_payments_user_id ON public.payments(user_id);
CREATE INDEX idx_payments_user_email ON public.payments(user_email);
CREATE INDEX idx_payments_subscription_id ON public.payments(subscription_id);

-- Triggers
CREATE TRIGGER update_subscriptions_updated_at
BEFORE UPDATE ON public.subscriptions
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_payments_updated_at
BEFORE UPDATE ON public.payments
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Seed monthly plans
INSERT INTO public.plans (name, description, price, billing_period, features, checkout_url, is_popular, sort_order) VALUES
('Basic', 'Perfect for getting started', 9.99, 'monthly', '["5 tool uses per day", "Basic support", "Standard processing"]', 'https://eulim.lemonsqueezy.com/buy/b6314e3d-7ed1-468f-aef0-23b27b6d7f74', false, 1),
('Standard', 'Best for regular users', 19.99, 'monthly', '["50 tool uses per day", "Priority support", "Fast processing", "Advanced features"]', 'https://eulim.lemonsqueezy.com/buy/b6314e3d-7ed1-468f-aef0-23b27b6d7f74', true, 2),
('Gold', 'For power users', 49.99, 'monthly', '["Unlimited tool uses", "24/7 Premium support", "Fastest processing", "All features", "API access"]', 'https://eulim.lemonsqueezy.com/buy/b6314e3d-7ed1-468f-aef0-23b27b6d7f74', false, 3);

-- Seed yearly plans
INSERT INTO public.plans (name, description, price, billing_period, features, checkout_url, is_popular, sort_order) VALUES
('Basic', 'Perfect for getting started', 95.99, 'yearly', '["5 tool uses per day", "Basic support", "Standard processing"]', 'https://eulim.lemonsqueezy.com/buy/b6314e3d-7ed1-468f-aef0-23b27b6d7f74', false, 1),
('Standard', 'Best for regular users', 191.99, 'yearly', '["50 tool uses per day", "Priority support", "Fast processing", "Advanced features"]', 'https://eulim.lemonsqueezy.com/buy/b6314e3d-7ed1-468f-aef0-23b27b6d7f74', true, 2),
('Gold', 'For power users', 479.99, 'yearly', '["Unlimited tool uses", "24/7 Premium support", "Fastest processing", "All features", "API access"]', 'https://eulim.lemonsqueezy.com/buy/b6314e3d-7ed1-468f-aef0-23b27b6d7f74', false, 3);
