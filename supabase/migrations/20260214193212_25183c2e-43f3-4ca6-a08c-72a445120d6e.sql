
-- Allow all authenticated users to view published reading tests
CREATE POLICY "Authenticated users can view published reading tests"
ON public.reading_tests
AS PERMISSIVE
FOR SELECT
TO authenticated
USING (status = 'published');

-- Allow all authenticated users to view published writing tests
CREATE POLICY "Authenticated users can view published writing tests"
ON public.writing_tests
AS PERMISSIVE
FOR SELECT
TO authenticated
USING (status = 'published');

-- Allow all authenticated users to view published listening tests
CREATE POLICY "Authenticated users can view published listening tests"
ON public.listening_tests
AS PERMISSIVE
FOR SELECT
TO authenticated
USING (status = 'published');

-- Allow authenticated users to view passages of published reading tests
CREATE POLICY "Authenticated users can view published reading passages"
ON public.reading_passages
AS PERMISSIVE
FOR SELECT
TO authenticated
USING (EXISTS (
  SELECT 1 FROM reading_tests
  WHERE reading_tests.id = reading_passages.test_id
  AND reading_tests.status = 'published'
));

-- Allow authenticated users to view question groups of published reading tests
CREATE POLICY "Authenticated users can view published reading question groups"
ON public.reading_question_groups
AS PERMISSIVE
FOR SELECT
TO authenticated
USING (EXISTS (
  SELECT 1 FROM reading_passages p
  JOIN reading_tests t ON t.id = p.test_id
  WHERE p.id = reading_question_groups.passage_id
  AND t.status = 'published'
));

-- Allow authenticated users to view questions of published reading tests
CREATE POLICY "Authenticated users can view published reading questions"
ON public.reading_questions
AS PERMISSIVE
FOR SELECT
TO authenticated
USING (EXISTS (
  SELECT 1 FROM reading_question_groups g
  JOIN reading_passages p ON p.id = g.passage_id
  JOIN reading_tests t ON t.id = p.test_id
  WHERE g.id = reading_questions.group_id
  AND t.status = 'published'
));

-- Allow authenticated users to view sections of published listening tests
CREATE POLICY "Authenticated users can view published listening sections"
ON public.listening_sections
AS PERMISSIVE
FOR SELECT
TO authenticated
USING (EXISTS (
  SELECT 1 FROM listening_tests
  WHERE listening_tests.id = listening_sections.test_id
  AND listening_tests.status = 'published'
));

-- Allow authenticated users to view question groups of published listening tests
CREATE POLICY "Authenticated users can view published listening question groups"
ON public.listening_question_groups
AS PERMISSIVE
FOR SELECT
TO authenticated
USING (EXISTS (
  SELECT 1 FROM listening_sections s
  JOIN listening_tests t ON t.id = s.test_id
  WHERE s.id = listening_question_groups.section_id
  AND t.status = 'published'
));

-- Allow authenticated users to view questions of published listening tests
CREATE POLICY "Authenticated users can view published listening questions"
ON public.listening_questions
AS PERMISSIVE
FOR SELECT
TO authenticated
USING (EXISTS (
  SELECT 1 FROM listening_question_groups g
  JOIN listening_sections s ON s.id = g.section_id
  JOIN listening_tests t ON t.id = s.test_id
  WHERE g.id = listening_questions.group_id
  AND t.status = 'published'
));

-- Allow authenticated users to view tasks of published writing tests
CREATE POLICY "Authenticated users can view published writing tasks"
ON public.writing_tasks
AS PERMISSIVE
FOR SELECT
TO authenticated
USING (EXISTS (
  SELECT 1 FROM writing_tests
  WHERE writing_tests.id = writing_tasks.test_id
  AND writing_tests.status = 'published'
));
