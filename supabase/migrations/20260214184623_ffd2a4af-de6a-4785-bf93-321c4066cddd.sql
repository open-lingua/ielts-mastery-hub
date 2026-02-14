ALTER TABLE public.user_test_sessions
  ADD COLUMN IF NOT EXISTS feedback_data jsonb DEFAULT NULL;