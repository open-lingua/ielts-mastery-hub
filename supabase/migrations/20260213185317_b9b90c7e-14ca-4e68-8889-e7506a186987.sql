
-- ═══════════════════════════════════════════════
-- Writing Test Schema: writing_tests → writing_tasks
-- ═══════════════════════════════════════════════

-- 1. writing_tests (parent entity)
CREATE TABLE public.writing_tests (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  created_by UUID NOT NULL,
  title TEXT NOT NULL DEFAULT '',
  status TEXT NOT NULL DEFAULT 'draft',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. writing_tasks (Task 1 and Task 2)
CREATE TABLE public.writing_tasks (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  test_id UUID NOT NULL REFERENCES public.writing_tests(id) ON DELETE CASCADE,
  task_number INT NOT NULL DEFAULT 1,
  task_type TEXT NOT NULL DEFAULT 'task1',
  title TEXT NOT NULL DEFAULT '',
  difficulty TEXT NOT NULL DEFAULT '7',
  suggested_time TEXT NOT NULL DEFAULT '20 mins',
  prompt TEXT NOT NULL DEFAULT '',
  min_words INT NOT NULL DEFAULT 150,
  max_words TEXT DEFAULT '',
  image_url TEXT DEFAULT '',
  include_model_answer BOOLEAN NOT NULL DEFAULT false,
  model_answer TEXT DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes
CREATE INDEX idx_writing_tests_created_by ON public.writing_tests(created_by);
CREATE INDEX idx_writing_tasks_test_id ON public.writing_tasks(test_id);

-- ═══════════════════════════════════════════════
-- RLS Policies
-- ═══════════════════════════════════════════════

ALTER TABLE public.writing_tests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own writing tests"
  ON public.writing_tests FOR SELECT USING (auth.uid() = created_by);
CREATE POLICY "Users can create writing tests"
  ON public.writing_tests FOR INSERT WITH CHECK (auth.uid() = created_by);
CREATE POLICY "Users can update their own writing tests"
  ON public.writing_tests FOR UPDATE USING (auth.uid() = created_by);
CREATE POLICY "Users can delete their own writing tests"
  ON public.writing_tests FOR DELETE USING (auth.uid() = created_by);

ALTER TABLE public.writing_tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view tasks of their tests"
  ON public.writing_tasks FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.writing_tests WHERE id = test_id AND created_by = auth.uid()));
CREATE POLICY "Users can insert tasks to their tests"
  ON public.writing_tasks FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM public.writing_tests WHERE id = test_id AND created_by = auth.uid()));
CREATE POLICY "Users can update tasks of their tests"
  ON public.writing_tasks FOR UPDATE
  USING (EXISTS (SELECT 1 FROM public.writing_tests WHERE id = test_id AND created_by = auth.uid()));
CREATE POLICY "Users can delete tasks of their tests"
  ON public.writing_tasks FOR DELETE
  USING (EXISTS (SELECT 1 FROM public.writing_tests WHERE id = test_id AND created_by = auth.uid()));

-- Updated_at trigger
CREATE TRIGGER update_writing_tests_updated_at
  BEFORE UPDATE ON public.writing_tests
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- ═══════════════════════════════════════════════
-- Storage bucket for writing assets (charts/graphs)
-- ═══════════════════════════════════════════════
INSERT INTO storage.buckets (id, name, public) VALUES ('writing-assets', 'writing-assets', true);

-- Storage policies
CREATE POLICY "Anyone can view writing assets"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'writing-assets');

CREATE POLICY "Authenticated users can upload writing assets"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'writing-assets' AND auth.role() = 'authenticated');

CREATE POLICY "Users can update their own writing assets"
  ON storage.objects FOR UPDATE
  USING (bucket_id = 'writing-assets' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can delete their own writing assets"
  ON storage.objects FOR DELETE
  USING (bucket_id = 'writing-assets' AND auth.uid()::text = (storage.foldername(name))[1]);
