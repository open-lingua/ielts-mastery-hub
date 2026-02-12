

# IELTS Mastery Hub - Implementation Plan

## Overview
A comprehensive IELTS preparation platform with a clean academic aesthetic, featuring a landing page, dashboard hub, and practice modules for Writing, Reading, and Listening — all powered by mock data for an immediately interactive prototype.

---

## Phase 1: Foundation & Design System

### Theme & Layout Shell
- Configure the color palette: Primary Royal Blue (#1e3a8a), Success Green (#10b981), Accent Amber (#f59e0b), with Slate backgrounds
- Set up Dark/Light mode toggle using Context API and `next-themes`
- Apply rounded-xl radius globally for cards and inputs
- Use Inter font for UI elements; serif font (Georgia/Merriweather via Google Fonts) for reading passages
- Build the sidebar navigation (collapsible on mobile) with links to Dashboard, Writing, Reading, and Listening
- Build the top bar with user avatar, theme toggle, and branding

### Mock Data Layer
- Create `src/data/mockData.ts` with:
  - `mockUser` (name, premium status, streak, recent scores)
  - `ieltsInfo` (tips, facts, band score explanations)
  - `practiceTests` (writing prompts, reading passages, listening scripts with questions)

---

## Phase 2: Landing Page (`/`)

### Hero Section
- Bold headline: "Master the IELTS with AI-Powered Practice"
- Two CTAs: "Start Free Practice" and "Go Premium"
- Subtle scroll-triggered animations using Tailwind CSS transitions

### About IELTS Section
- Four visually engaging cards explaining Listening, Reading, Writing, and Speaking modules
- Band Score system explanation (0–9 scale)

### Pricing Section
- Two pricing cards side-by-side:
  - **Free Tier:** 1 practice test/day, basic stats
  - **Premium Tier:** Unlimited feedback, full mock exams, advanced analytics (highlighted with Amber accent)

### Footer
- Links to resources, terms, social media icons

---

## Phase 3: Dashboard (`/dashboard`)

### Welcome & Streak
- Personalized greeting: "Welcome back, [User]! You are on a 3-day streak 🔥"

### Quick Action Cards (Bento Grid)
- Three large cards with distinct icons and colors:
  1. **Practice Writing** → navigates to `/writing`
  2. **Practice Reading** → navigates to `/reading`
  3. **Practice Listening** → navigates to `/listening`

### Progress Overview
- Line chart (Recharts) showing "Band Score Estimate" over the last several sessions

### Recent Activity
- List of last 3 completed exercises with scores and dates

---

## Phase 4: Writing Simulator (`/writing`) — Core Feature

### Two-Pane Layout
- **Left Pane (Editor):** Distraction-free textarea with serif font, auto-saving indicator
- **Right Pane (Prompt):** Displays the selected Task 1 or Task 2 question with context, labeled Academic/General, plus examiner tips

### Toolbar & Controls
- **Task Selector:** Dropdown in the header to switch between writing prompts (resets timer and editor)
- **Live Word Count:** Shows current count vs. minimum requirement (color-coded amber/green)
- **Countdown Timer:** Starts on first keystroke (20 min for Task 1, 40 min for Task 2), color changes at 10 min and 5 min warnings
- **Submit Button:** Prominent "Submit Essay" action

### Feedback Modal (Mock AI Grading)
- Loading state on submit, then displays:
  - Overall Band Score with circular progress visualization
  - Four sub-scores: Task Achievement, Coherence & Cohesion, Lexical Resource, Grammatical Range
  - AI feedback text with actionable suggestions
  - Actions: "Review Essay" or "Start New Task"

---

## Phase 5: Reading & Listening Modules

### Reading Module (`/reading`)
- Split-screen layout: scrollable passage on the left, questions on the right
- Question types: Multiple Choice, True/False/Not Given
- Submit and check answers with score display

### Listening Module (`/listening`)
- Audio player bar fixed at the bottom of the screen
- Questions displayed in the center content area
- Mock audio controls (play/pause/progress) with question sections

---

## Technical Notes
- Tailwind CSS animations will be used instead of Framer Motion (not installed) for scroll effects and transitions
- All pages fully support Dark and Light modes with high-contrast text
- Mobile-first responsive design throughout
- No backend needed — all data is mock/local for this prototype

