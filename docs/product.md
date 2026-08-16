# IELTS Mastery Hub — PRD & Story Backlog

---

## 1. Product Requirements Document

### Executive Summary

IELTS Mastery Hub is a desktop IELTS preparation platform built with Tauri + React that provides AI-graded Writing practice alongside timed Reading and Listening simulation engines. It covers all 13 official IELTS question types, uses real exam-format timing, and stores progress locally via SQLite. The core value proposition is **exam-realistic practice with instant, AI-powered feedback** — works fully offline.

### Target Audience / User Personas

| Persona | Description |
|---|---|
| **IELTS Student (Primary)** | Self-studying candidate preparing for Academic/General IELTS. Needs realistic timed practice, score tracking, and actionable feedback. |
| **Content Creator / Admin** | Teacher or platform admin who authors tests (Reading passages, Listening sections, Writing prompts) and publishes them for students. |
| **Premium Student** | Power user wanting unlimited AI grading, full mock exams, and advanced analytics. |

### Project Goals & Scope

| Goal | In Scope | Out of Scope |
|---|---|---|
| Exam-realistic modules | Writing (Task 1 & 2), Reading (3 passages, 40 Qs), Listening (4 sections, 40 Qs) | Speaking module |
| AI Grading | Writing essays graded on 4 IELTS criteria via AI | Reading/Listening AI explanations |
| Content Management | Admin CRUD for all test types, publish/draft workflow | Bulk CSV import |
| Progress Tracking | Session history, band scores, streak tracking | Spaced repetition / adaptive learning |
| Auth & Profiles | Email signup/login, profile, plan type | OAuth / SSO |

### Core Features (Prioritized)

1. **Authentication & Profiles** — Signup, login, profile with plan type
2. **Practice Library** — Browse published Reading, Listening, Writing tests
3. **Writing Simulator** — Two-pane editor, timer, word count, AI grading with 4-criteria feedback
4. **Reading Practice Engine** — Split-screen passage/questions, 13 question types, auto-scoring
5. **Listening Practice Engine** — Audio player, 4-section flow, 13 question types, auto-scoring
6. **Dashboard** — Streak, recent activity, score trends (Recharts)
7. **Admin CMS** — Create/edit/publish tests, manage users
8. **Session Persistence** — Save in-progress tests, resume later
9. **Landing Page** — Marketing page with pricing cards
10. **Dark/Light Theme** — System-wide toggle

### Non-Functional Requirements

| Category | Requirement |
|---|---|
| **Performance** | < 2s initial load; lazy-load audio assets; paginate large question sets |
| **Security** | API keys stay in Rust layer; never exposed to frontend; no anonymous network access |
| **Scalability** | Local SQLite; no server required; data lives on-device |
| **Accessibility** | Semantic HTML; keyboard navigation for question types; ARIA labels on interactive elements |
| **Browser Support** | Modern evergreen browsers (Chrome, Firefox, Safari, Edge) |
| **Data Integrity** | Deterministic UUIDs in seed data; foreign key constraints; cascade deletes |

---

## 2. User & Application Stories

### Module: Authentication

**US-1: Email Registration**
- **Story:** As a student, I want to register with my email and password so that I can save my progress.
- **Acceptance Criteria:**
  - Form validates email format and password strength
  - Email confirmation required before first login
  - Profile row auto-created via `handle_new_user` trigger

**US-2: Login & Session**
- **Story:** As a registered user, I want to log in and stay authenticated so that I can resume my practice.
- **Acceptance Criteria:**
  - JWT persisted in localStorage with auto-refresh
  - Redirects to `/dashboard` on success
  - Shows error toast on invalid credentials

---

### Module: Practice Library

**US-3: Browse Available Tests**
- **Story:** As a student, I want to browse all published tests filtered by module type so that I can choose what to practice.
- **Acceptance Criteria:**
  - Lists Reading, Listening, Writing tests with difficulty badges
  - Only `status = 'published'` tests visible
  - Shows attempt count and last score if previously taken

**US-4: Resume In-Progress Test**
- **Story:** As a student, I want to see an active session banner so that I can resume a test I started.
- **Acceptance Criteria:**
  - Banner appears on dashboard and library pages
  - Links directly to the in-progress module with saved answers
  - Session expires after configurable inactivity period

---

### Module: Writing Simulator

**US-5: Timed Writing Practice**
- **Story:** As a student, I want to write essays under timed conditions so that I simulate exam pressure.
- **Acceptance Criteria:**
  - Timer starts on first keystroke (20 min Task 1, 40 min Task 2)
  - Live word count with color-coded min-word indicator
  - Auto-save draft to `user_test_sessions` in SQLite

**US-6: AI Essay Grading**
- **Story:** As a student, I want AI feedback on my essay so that I know my estimated band score and how to improve.
- **Acceptance Criteria:**
  - Grading returns 4 sub-scores (Task Achievement, Coherence, Lexical, Grammar)
  - Overall band calculated with Task 2 weighted 2/3
  - Feedback includes strengths, weaknesses, and actionable improvements

**TS-1: Grade-Writing Tauri Command**
- **Story:** As the system, I need a Rust command that calls the AI gateway so that essays are graded securely without exposing API keys.
- **Acceptance Criteria:**
  - Uses `AI_API_KEY` stored in Rust environment; never exposed to frontend
  - Returns structured `WritingGradingResult` JSON via Tauri IPC
  - Handles token limits and returns graceful errors

---

### Module: Reading Practice Engine

**US-7: Split-Screen Reading**
- **Story:** As a student, I want to read a passage on the left and answer questions on the right so that I replicate the exam layout.
- **Acceptance Criteria:**
  - Passage scrollable independently from question panel
  - Questions grouped with instructions per group
  - 60-minute countdown timer with color warnings

**US-8: All 13 Question Types**
- **Story:** As a student, I want to encounter all official IELTS question types so that I'm prepared for any exam format.
- **Acceptance Criteria:**
  - `QuestionRenderer` handles: TFNG, YNNG, MCQ, Short Answer, Sentence/Note/Table/Summary/Flowchart Completion, Matching Headings/Information/Features/Sentence Endings
  - Each type renders appropriate UI (radio, text input, dropdown, drag-drop)
  - Accepted answers support multiple valid responses

**US-9: Auto-Scoring & Review**
- **Story:** As a student, I want instant scoring after submission so that I can review correct vs incorrect answers.
- **Acceptance Criteria:**
  - Band score calculated from raw score using official conversion
  - Review mode highlights correct/incorrect with explanations
  - Results persisted to `user_test_sessions` in SQLite

---

### Module: Listening Practice Engine

**US-10: Audio-Driven Listening Test**
- **Story:** As a student, I want to listen to audio and answer questions section by section so that I simulate the listening exam.
- **Acceptance Criteria:**
  - Audio player with play/pause/seek controls
  - 4 sections with progressive question numbering (Q1–40)
  - "Submit & Continue" advances to next section

**US-11: Section Stepper Navigation**
- **Story:** As a student, I want to see which section I'm on and navigate between completed sections so that I can review before final submission.
- **Acceptance Criteria:**
  - Stepper shows sections 1–4 with completion status
  - Can revisit completed sections before final submit
  - Final results show per-section and overall breakdown

---

### Module: Dashboard

**US-12: Progress Overview**
- **Story:** As a student, I want to see my score trends and streak so that I stay motivated.
- **Acceptance Criteria:**
  - Line chart of band scores over recent sessions (Recharts)
  - Current streak count with fire emoji
  - Last 3 completed exercises with scores and dates

**US-13: Study Heatmap**
- **Story:** As a student, I want to see a heatmap of my study activity so that I can identify consistency gaps.
- **Acceptance Criteria:**
  - GitHub-style contribution grid
  - Sourced from `user_test_sessions` timestamps in SQLite
  - Covers last 12 weeks

---

### Module: Admin CMS

**US-14: Create & Publish Tests**
- **Story:** As an admin, I want to create reading/listening/writing tests and publish them so that students can practice.
- **Acceptance Criteria:**
  - Form-based creation with nested passages/sections/question groups
  - Draft/Published toggle enforced in the Rust command layer
  - Preview modal before publishing

**US-15: User Management**
- **Story:** As an admin, I want to view registered users and their plan types so that I can manage access.
- **Acceptance Criteria:**
  - Table of users with name, email, plan, last active
  - Ability to upgrade/downgrade plan type
  - Protected by admin-only route

**TS-2: Admin Role Authorization**
- **Story:** As the system, I need role-based access control so that only admins can access CMS routes.
- **Acceptance Criteria:**
  - Admin role stored in the local SQLite `profiles` table
  - `ProtectedRoute` component checks role before rendering
  - Non-admin users redirected to dashboard

---

### Module: Infrastructure & Data

**TS-3: Seed Data Integrity**
- **Story:** As the system, I need comprehensive seed data so that all question types and UI components can be tested.
- **Acceptance Criteria:**
  - Deterministic UUIDs across all tables
  - Covers all 13 reading + listening question types
  - `TRUNCATE CASCADE` cleanup prevents duplication

**TS-4: Data Access Control**
- **Story:** As the system, I need access control in Rust commands so that users only access their own data and published content.
- **Acceptance Criteria:**
  - Students: read published tests; full CRUD on own sessions
  - Admins: full CRUD on tests they created
  - Access checks enforced in the Rust command layer, not the frontend

**TS-5: Dark/Light Theme System**
- **Story:** As the system, I need a theme provider with CSS custom properties so that all components respect the user's preference.
- **Acceptance Criteria:**
  - `ThemeContext` toggles `dark` class on ``
  - All colors use HSL semantic tokens from `index.css`
  - Persisted in localStorage

---

This document covers the current state and planned scope. Stories marked **TS-** are technical; **US-** are user-facing.

Save PRD to project
Create project milestones
Test Reading module E2E