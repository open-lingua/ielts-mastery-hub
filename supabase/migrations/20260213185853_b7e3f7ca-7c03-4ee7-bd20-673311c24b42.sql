
-- ═══════════════════════════════════════════════
-- Listening Test Schema: listening_tests → listening_sections → listening_question_groups → listening_questions
-- ═══════════════════════════════════════════════

CREATE TABLE public.listening_tests (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  created_by UUID NOT NULL,
  title TEXT NOT NULL DEFAULT '',
  difficulty TEXT NOT NULL DEFAULT '7',
  duration TEXT NOT NULL DEFAULT '40 mins',
  status TEXT NOT NULL DEFAULT 'draft',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE public.listening_sections (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  test_id UUID NOT NULL REFERENCES public.listening_tests(id) ON DELETE CASCADE,
  section_number INT NOT NULL DEFAULT 1,
  title TEXT NOT NULL DEFAULT '',
  transcript TEXT DEFAULT '',
  audio_url TEXT DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE public.listening_question_groups (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  section_id UUID NOT NULL REFERENCES public.listening_sections(id) ON DELETE CASCADE,
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

CREATE TABLE public.listening_questions (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  group_id UUID NOT NULL REFERENCES public.listening_question_groups(id) ON DELETE CASCADE,
  question_order INT NOT NULL DEFAULT 0,
  text TEXT NOT NULL DEFAULT '',
  answer TEXT DEFAULT '',
  options JSONB DEFAULT '[]'::jsonb,
  matching_pairs JSONB DEFAULT '[]'::jsonb,
  completion_gaps JSONB DEFAULT '[]'::jsonb,
  accepted_answers JSONB DEFAULT '[]'::jsonb,
  timestamp TEXT DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes
CREATE INDEX idx_listening_tests_created_by ON public.listening_tests(created_by);
CREATE INDEX idx_listening_sections_test_id ON public.listening_sections(test_id);
CREATE INDEX idx_listening_question_groups_section_id ON public.listening_question_groups(section_id);
CREATE INDEX idx_listening_questions_group_id ON public.listening_questions(group_id);

-- ═══════════════════════════════════════════════
-- RLS
-- ═══════════════════════════════════════════════

ALTER TABLE public.listening_tests ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own listening tests" ON public.listening_tests FOR SELECT USING (auth.uid() = created_by);
CREATE POLICY "Users can create listening tests" ON public.listening_tests FOR INSERT WITH CHECK (auth.uid() = created_by);
CREATE POLICY "Users can update their own listening tests" ON public.listening_tests FOR UPDATE USING (auth.uid() = created_by);
CREATE POLICY "Users can delete their own listening tests" ON public.listening_tests FOR DELETE USING (auth.uid() = created_by);

ALTER TABLE public.listening_sections ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view sections of their tests" ON public.listening_sections FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.listening_tests WHERE id = test_id AND created_by = auth.uid()));
CREATE POLICY "Users can insert sections to their tests" ON public.listening_sections FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM public.listening_tests WHERE id = test_id AND created_by = auth.uid()));
CREATE POLICY "Users can update sections of their tests" ON public.listening_sections FOR UPDATE
  USING (EXISTS (SELECT 1 FROM public.listening_tests WHERE id = test_id AND created_by = auth.uid()));
CREATE POLICY "Users can delete sections of their tests" ON public.listening_sections FOR DELETE
  USING (EXISTS (SELECT 1 FROM public.listening_tests WHERE id = test_id AND created_by = auth.uid()));

ALTER TABLE public.listening_question_groups ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view listening question groups" ON public.listening_question_groups FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.listening_sections s JOIN public.listening_tests t ON t.id = s.test_id WHERE s.id = section_id AND t.created_by = auth.uid()));
CREATE POLICY "Users can insert listening question groups" ON public.listening_question_groups FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM public.listening_sections s JOIN public.listening_tests t ON t.id = s.test_id WHERE s.id = section_id AND t.created_by = auth.uid()));
CREATE POLICY "Users can update listening question groups" ON public.listening_question_groups FOR UPDATE
  USING (EXISTS (SELECT 1 FROM public.listening_sections s JOIN public.listening_tests t ON t.id = s.test_id WHERE s.id = section_id AND t.created_by = auth.uid()));
CREATE POLICY "Users can delete listening question groups" ON public.listening_question_groups FOR DELETE
  USING (EXISTS (SELECT 1 FROM public.listening_sections s JOIN public.listening_tests t ON t.id = s.test_id WHERE s.id = section_id AND t.created_by = auth.uid()));

ALTER TABLE public.listening_questions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view listening questions" ON public.listening_questions FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.listening_question_groups g JOIN public.listening_sections s ON s.id = g.section_id JOIN public.listening_tests t ON t.id = s.test_id WHERE g.id = group_id AND t.created_by = auth.uid()));
CREATE POLICY "Users can insert listening questions" ON public.listening_questions FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM public.listening_question_groups g JOIN public.listening_sections s ON s.id = g.section_id JOIN public.listening_tests t ON t.id = s.test_id WHERE g.id = group_id AND t.created_by = auth.uid()));
CREATE POLICY "Users can update listening questions" ON public.listening_questions FOR UPDATE
  USING (EXISTS (SELECT 1 FROM public.listening_question_groups g JOIN public.listening_sections s ON s.id = g.section_id JOIN public.listening_tests t ON t.id = s.test_id WHERE g.id = group_id AND t.created_by = auth.uid()));
CREATE POLICY "Users can delete listening questions" ON public.listening_questions FOR DELETE
  USING (EXISTS (SELECT 1 FROM public.listening_question_groups g JOIN public.listening_sections s ON s.id = g.section_id JOIN public.listening_tests t ON t.id = s.test_id WHERE g.id = group_id AND t.created_by = auth.uid()));

-- Updated_at trigger
CREATE TRIGGER update_listening_tests_updated_at
  BEFORE UPDATE ON public.listening_tests
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- ═══════════════════════════════════════════════
-- Storage bucket for listening audio files
-- ═══════════════════════════════════════════════
INSERT INTO storage.buckets (id, name, public) VALUES ('listening-audio', 'listening-audio', true);

CREATE POLICY "Anyone can view listening audio" ON storage.objects FOR SELECT USING (bucket_id = 'listening-audio');
CREATE POLICY "Authenticated users can upload listening audio" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'listening-audio' AND auth.role() = 'authenticated');
CREATE POLICY "Users can update their own listening audio" ON storage.objects FOR UPDATE USING (bucket_id = 'listening-audio' AND auth.uid()::text = (storage.foldername(name))[1]);
CREATE POLICY "Users can delete their own listening audio" ON storage.objects FOR DELETE USING (bucket_id = 'listening-audio' AND auth.uid()::text = (storage.foldername(name))[1]);
