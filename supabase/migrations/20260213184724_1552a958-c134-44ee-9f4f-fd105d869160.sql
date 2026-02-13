
-- ═══════════════════════════════════════════════
-- Reading Test Schema: 4-level hierarchy
-- reading_tests → reading_passages → reading_question_groups → reading_questions
-- ═══════════════════════════════════════════════

-- 1. reading_tests (top-level entity)
CREATE TABLE public.reading_tests (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  created_by UUID NOT NULL,
  title TEXT NOT NULL DEFAULT '',
  test_type TEXT NOT NULL DEFAULT 'Academic',
  difficulty TEXT NOT NULL DEFAULT '7',
  duration TEXT NOT NULL DEFAULT '60 mins',
  status TEXT NOT NULL DEFAULT 'draft',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. reading_passages (belongs to a test)
CREATE TABLE public.reading_passages (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  test_id UUID NOT NULL REFERENCES public.reading_tests(id) ON DELETE CASCADE,
  passage_number INT NOT NULL DEFAULT 1,
  title TEXT NOT NULL DEFAULT '',
  content TEXT NOT NULL DEFAULT '',
  notes TEXT DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 3. reading_question_groups (belongs to a passage)
CREATE TABLE public.reading_question_groups (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  passage_id UUID NOT NULL REFERENCES public.reading_passages(id) ON DELETE CASCADE,
  group_order INT NOT NULL DEFAULT 0,
  question_type TEXT NOT NULL DEFAULT 'multiple-choice',
  instructions TEXT NOT NULL DEFAULT '',
  word_limit TEXT DEFAULT '',
  has_word_bank BOOLEAN NOT NULL DEFAULT false,
  word_bank JSONB DEFAULT '[]'::jsonb,
  sequential_order BOOLEAN NOT NULL DEFAULT true,
  multiple_selection BOOLEAN NOT NULL DEFAULT false,
  select_count INT NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 4. reading_questions (belongs to a question group)
CREATE TABLE public.reading_questions (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  group_id UUID NOT NULL REFERENCES public.reading_question_groups(id) ON DELETE CASCADE,
  question_order INT NOT NULL DEFAULT 0,
  text TEXT NOT NULL DEFAULT '',
  answer TEXT DEFAULT '',
  options JSONB DEFAULT '[]'::jsonb,
  matching_pairs JSONB DEFAULT '[]'::jsonb,
  completion_gaps JSONB DEFAULT '[]'::jsonb,
  accepted_answers JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ═══════════════════════════════════════════════
-- Indexes
-- ═══════════════════════════════════════════════
CREATE INDEX idx_reading_passages_test_id ON public.reading_passages(test_id);
CREATE INDEX idx_reading_question_groups_passage_id ON public.reading_question_groups(passage_id);
CREATE INDEX idx_reading_questions_group_id ON public.reading_questions(group_id);
CREATE INDEX idx_reading_tests_created_by ON public.reading_tests(created_by);

-- ═══════════════════════════════════════════════
-- RLS Policies
-- ═══════════════════════════════════════════════

-- reading_tests
ALTER TABLE public.reading_tests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own reading tests"
  ON public.reading_tests FOR SELECT
  USING (auth.uid() = created_by);

CREATE POLICY "Users can create reading tests"
  ON public.reading_tests FOR INSERT
  WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can update their own reading tests"
  ON public.reading_tests FOR UPDATE
  USING (auth.uid() = created_by);

CREATE POLICY "Users can delete their own reading tests"
  ON public.reading_tests FOR DELETE
  USING (auth.uid() = created_by);

-- reading_passages
ALTER TABLE public.reading_passages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view passages of their tests"
  ON public.reading_passages FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.reading_tests WHERE id = test_id AND created_by = auth.uid()));

CREATE POLICY "Users can insert passages to their tests"
  ON public.reading_passages FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM public.reading_tests WHERE id = test_id AND created_by = auth.uid()));

CREATE POLICY "Users can update passages of their tests"
  ON public.reading_passages FOR UPDATE
  USING (EXISTS (SELECT 1 FROM public.reading_tests WHERE id = test_id AND created_by = auth.uid()));

CREATE POLICY "Users can delete passages of their tests"
  ON public.reading_passages FOR DELETE
  USING (EXISTS (SELECT 1 FROM public.reading_tests WHERE id = test_id AND created_by = auth.uid()));

-- reading_question_groups
ALTER TABLE public.reading_question_groups ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view question groups of their tests"
  ON public.reading_question_groups FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM public.reading_passages p
    JOIN public.reading_tests t ON t.id = p.test_id
    WHERE p.id = passage_id AND t.created_by = auth.uid()
  ));

CREATE POLICY "Users can insert question groups to their tests"
  ON public.reading_question_groups FOR INSERT
  WITH CHECK (EXISTS (
    SELECT 1 FROM public.reading_passages p
    JOIN public.reading_tests t ON t.id = p.test_id
    WHERE p.id = passage_id AND t.created_by = auth.uid()
  ));

CREATE POLICY "Users can update question groups of their tests"
  ON public.reading_question_groups FOR UPDATE
  USING (EXISTS (
    SELECT 1 FROM public.reading_passages p
    JOIN public.reading_tests t ON t.id = p.test_id
    WHERE p.id = passage_id AND t.created_by = auth.uid()
  ));

CREATE POLICY "Users can delete question groups of their tests"
  ON public.reading_question_groups FOR DELETE
  USING (EXISTS (
    SELECT 1 FROM public.reading_passages p
    JOIN public.reading_tests t ON t.id = p.test_id
    WHERE p.id = passage_id AND t.created_by = auth.uid()
  ));

-- reading_questions
ALTER TABLE public.reading_questions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view questions of their tests"
  ON public.reading_questions FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM public.reading_question_groups g
    JOIN public.reading_passages p ON p.id = g.passage_id
    JOIN public.reading_tests t ON t.id = p.test_id
    WHERE g.id = group_id AND t.created_by = auth.uid()
  ));

CREATE POLICY "Users can insert questions to their tests"
  ON public.reading_questions FOR INSERT
  WITH CHECK (EXISTS (
    SELECT 1 FROM public.reading_question_groups g
    JOIN public.reading_passages p ON p.id = g.passage_id
    JOIN public.reading_tests t ON t.id = p.test_id
    WHERE g.id = group_id AND t.created_by = auth.uid()
  ));

CREATE POLICY "Users can update questions of their tests"
  ON public.reading_questions FOR UPDATE
  USING (EXISTS (
    SELECT 1 FROM public.reading_question_groups g
    JOIN public.reading_passages p ON p.id = g.passage_id
    JOIN public.reading_tests t ON t.id = p.test_id
    WHERE g.id = group_id AND t.created_by = auth.uid()
  ));

CREATE POLICY "Users can delete questions of their tests"
  ON public.reading_questions FOR DELETE
  USING (EXISTS (
    SELECT 1 FROM public.reading_question_groups g
    JOIN public.reading_passages p ON p.id = g.passage_id
    JOIN public.reading_tests t ON t.id = p.test_id
    WHERE g.id = group_id AND t.created_by = auth.uid()
  ));

-- ═══════════════════════════════════════════════
-- Updated_at trigger
-- ═══════════════════════════════════════════════
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SET search_path = public;

CREATE TRIGGER update_reading_tests_updated_at
  BEFORE UPDATE ON public.reading_tests
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();
