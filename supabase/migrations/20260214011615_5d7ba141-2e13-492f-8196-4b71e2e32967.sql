
-- Add attempt_number column with default 1 for existing rows
ALTER TABLE public.user_test_sessions
  ADD COLUMN attempt_number integer NOT NULL DEFAULT 1;

-- Drop the old unique index that enforces 1:1
DROP INDEX IF EXISTS public.idx_user_test_sessions_unique;

-- Create a new index for efficient lookups (non-unique)
CREATE INDEX idx_user_test_sessions_lookup
  ON public.user_test_sessions (user_id, test_id, test_type, attempt_number DESC);
