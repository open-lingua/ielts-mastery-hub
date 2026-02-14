
-- Drop the RESTRICTIVE owner-only SELECT policies on all test-related tables
-- and recreate them as PERMISSIVE so they OR with the published-test policies.

-- listening_tests
DROP POLICY IF EXISTS "Users can view their own listening tests" ON public.listening_tests;
CREATE POLICY "Users can view their own listening tests"
ON public.listening_tests AS PERMISSIVE FOR SELECT TO authenticated
USING (auth.uid() = created_by);

-- listening_sections
DROP POLICY IF EXISTS "Users can view sections of their tests" ON public.listening_sections;
CREATE POLICY "Users can view sections of their tests"
ON public.listening_sections AS PERMISSIVE FOR SELECT TO authenticated
USING (EXISTS (
  SELECT 1 FROM listening_tests WHERE listening_tests.id = listening_sections.test_id AND listening_tests.created_by = auth.uid()
));

-- listening_question_groups
DROP POLICY IF EXISTS "Users can view listening question groups" ON public.listening_question_groups;
CREATE POLICY "Users can view listening question groups"
ON public.listening_question_groups AS PERMISSIVE FOR SELECT TO authenticated
USING (EXISTS (
  SELECT 1 FROM listening_sections s JOIN listening_tests t ON t.id = s.test_id
  WHERE s.id = listening_question_groups.section_id AND t.created_by = auth.uid()
));

-- listening_questions
DROP POLICY IF EXISTS "Users can view listening questions" ON public.listening_questions;
CREATE POLICY "Users can view listening questions"
ON public.listening_questions AS PERMISSIVE FOR SELECT TO authenticated
USING (EXISTS (
  SELECT 1 FROM listening_question_groups g JOIN listening_sections s ON s.id = g.section_id JOIN listening_tests t ON t.id = s.test_id
  WHERE g.id = listening_questions.group_id AND t.created_by = auth.uid()
));

-- reading_tests
DROP POLICY IF EXISTS "Users can view their own reading tests" ON public.reading_tests;
CREATE POLICY "Users can view their own reading tests"
ON public.reading_tests AS PERMISSIVE FOR SELECT TO authenticated
USING (auth.uid() = created_by);

-- reading_passages
DROP POLICY IF EXISTS "Users can view passages of their tests" ON public.reading_passages;
CREATE POLICY "Users can view passages of their tests"
ON public.reading_passages AS PERMISSIVE FOR SELECT TO authenticated
USING (EXISTS (
  SELECT 1 FROM reading_tests WHERE reading_tests.id = reading_passages.test_id AND reading_tests.created_by = auth.uid()
));

-- reading_question_groups
DROP POLICY IF EXISTS "Users can view question groups of their tests" ON public.reading_question_groups;
CREATE POLICY "Users can view question groups of their tests"
ON public.reading_question_groups AS PERMISSIVE FOR SELECT TO authenticated
USING (EXISTS (
  SELECT 1 FROM reading_passages p JOIN reading_tests t ON t.id = p.test_id
  WHERE p.id = reading_question_groups.passage_id AND t.created_by = auth.uid()
));

-- reading_questions
DROP POLICY IF EXISTS "Users can view questions of their tests" ON public.reading_questions;
CREATE POLICY "Users can view questions of their tests"
ON public.reading_questions AS PERMISSIVE FOR SELECT TO authenticated
USING (EXISTS (
  SELECT 1 FROM reading_question_groups g JOIN reading_passages p ON p.id = g.passage_id JOIN reading_tests t ON t.id = p.test_id
  WHERE g.id = reading_questions.group_id AND t.created_by = auth.uid()
));

-- writing_tests
DROP POLICY IF EXISTS "Users can view their own writing tests" ON public.writing_tests;
CREATE POLICY "Users can view their own writing tests"
ON public.writing_tests AS PERMISSIVE FOR SELECT TO authenticated
USING (auth.uid() = created_by);

-- writing_tasks
DROP POLICY IF EXISTS "Users can view tasks of their tests" ON public.writing_tasks;
CREATE POLICY "Users can view tasks of their tests"
ON public.writing_tasks AS PERMISSIVE FOR SELECT TO authenticated
USING (EXISTS (
  SELECT 1 FROM writing_tests WHERE writing_tests.id = writing_tasks.test_id AND writing_tests.created_by = auth.uid()
));

-- Also convert the "Authenticated users can view published" policies that were already RESTRICTIVE
DROP POLICY IF EXISTS "Authenticated users can view published listening question group" ON public.listening_question_groups;
CREATE POLICY "Authenticated users can view published listening question group"
ON public.listening_question_groups AS PERMISSIVE FOR SELECT TO authenticated
USING (EXISTS (
  SELECT 1 FROM listening_sections s JOIN listening_tests t ON t.id = s.test_id
  WHERE s.id = listening_question_groups.section_id AND t.status = 'published'
));

DROP POLICY IF EXISTS "Authenticated users can view published listening questions" ON public.listening_questions;
CREATE POLICY "Authenticated users can view published listening questions"
ON public.listening_questions AS PERMISSIVE FOR SELECT TO authenticated
USING (EXISTS (
  SELECT 1 FROM listening_question_groups g JOIN listening_sections s ON s.id = g.section_id JOIN listening_tests t ON t.id = s.test_id
  WHERE g.id = listening_questions.group_id AND t.status = 'published'
));

DROP POLICY IF EXISTS "Authenticated users can view published listening sections" ON public.listening_sections;
CREATE POLICY "Authenticated users can view published listening sections"
ON public.listening_sections AS PERMISSIVE FOR SELECT TO authenticated
USING (EXISTS (
  SELECT 1 FROM listening_tests WHERE listening_tests.id = listening_sections.test_id AND listening_tests.status = 'published'
));

DROP POLICY IF EXISTS "Authenticated users can view published reading passages" ON public.reading_passages;
CREATE POLICY "Authenticated users can view published reading passages"
ON public.reading_passages AS PERMISSIVE FOR SELECT TO authenticated
USING (EXISTS (
  SELECT 1 FROM reading_tests WHERE reading_tests.id = reading_passages.test_id AND reading_tests.status = 'published'
));

DROP POLICY IF EXISTS "Authenticated users can view published reading question groups" ON public.reading_question_groups;
CREATE POLICY "Authenticated users can view published reading question groups"
ON public.reading_question_groups AS PERMISSIVE FOR SELECT TO authenticated
USING (EXISTS (
  SELECT 1 FROM reading_passages p JOIN reading_tests t ON t.id = p.test_id
  WHERE p.id = reading_question_groups.passage_id AND t.status = 'published'
));

DROP POLICY IF EXISTS "Authenticated users can view published reading questions" ON public.reading_questions;
CREATE POLICY "Authenticated users can view published reading questions"
ON public.reading_questions AS PERMISSIVE FOR SELECT TO authenticated
USING (EXISTS (
  SELECT 1 FROM reading_question_groups g JOIN reading_passages p ON p.id = g.passage_id JOIN reading_tests t ON t.id = p.test_id
  WHERE g.id = reading_questions.group_id AND t.status = 'published'
));

DROP POLICY IF EXISTS "Authenticated users can view published writing tasks" ON public.writing_tasks;
CREATE POLICY "Authenticated users can view published writing tasks"
ON public.writing_tasks AS PERMISSIVE FOR SELECT TO authenticated
USING (EXISTS (
  SELECT 1 FROM writing_tests WHERE writing_tests.id = writing_tasks.test_id AND writing_tests.status = 'published'
));
