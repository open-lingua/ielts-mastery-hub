
-- Create user_test_sessions table to track student progress
CREATE TABLE public.user_test_sessions (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  test_id UUID NOT NULL,
  test_type TEXT NOT NULL CHECK (test_type IN ('reading', 'writing', 'listening')),
  status TEXT NOT NULL DEFAULT 'in_progress' CHECK (status IN ('in_progress', 'completed')),
  progress_percent INTEGER NOT NULL DEFAULT 0 CHECK (progress_percent >= 0 AND progress_percent <= 100),
  score_band NUMERIC(3,1) NULL,
  started_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  completed_at TIMESTAMP WITH TIME ZONE NULL,
  last_active_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Index for fast lookups
CREATE INDEX idx_user_test_sessions_user_id ON public.user_test_sessions(user_id);
CREATE UNIQUE INDEX idx_user_test_sessions_unique ON public.user_test_sessions(user_id, test_id, test_type);

-- Enable RLS
ALTER TABLE public.user_test_sessions ENABLE ROW LEVEL SECURITY;

-- Users can only see their own sessions
CREATE POLICY "Users can view their own sessions"
ON public.user_test_sessions FOR SELECT
USING (auth.uid() = user_id);

-- Users can create their own sessions
CREATE POLICY "Users can create their own sessions"
ON public.user_test_sessions FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Users can update their own sessions
CREATE POLICY "Users can update their own sessions"
ON public.user_test_sessions FOR UPDATE
USING (auth.uid() = user_id);

-- Users can delete their own sessions
CREATE POLICY "Users can delete their own sessions"
ON public.user_test_sessions FOR DELETE
USING (auth.uid() = user_id);
