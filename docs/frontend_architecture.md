# Frontend Architecture & Project Structure

> **IELTS Mastery Hub** — A comprehensive IELTS preparation platform built as a React Single-Page Application.

---

## 1. High-Level Overview

| Attribute | Detail |
|---|---|
| **Framework** | React 18 (SPA) |
| **Rendering** | Client-Side Rendering (CSR) via Vite dev server & static build |
| **Language** | TypeScript (strict mode) |
| **Architectural Pattern** | **Layered Modular** — Pages → Services → Tauri IPC. Components are grouped by domain feature (writing, reading, listening) with a shared UI library (shadcn/ui). |
| **Backend** | Tauri (Rust) — SQLite via `tauri-plugin-sql` |

### Request Lifecycle

```
User Interaction
  → React Component (pages/)
    → Service Layer (services/)
      → Tauri IPC (lib/tauri.ts)
        → Rust backend → SQLite
```

---

## 2. Tech Stack & Key Dependencies

### Core

| Technology | Role | Justification |
|---|---|---|
| **React 18** | UI Framework | Component model, hooks ecosystem, large community |
| **TypeScript** | Language | Type safety, IDE support, refactor confidence |
| **Vite + SWC** | Build Tool | Sub-second HMR, fast production builds |
| **React Router v6** | Routing | Declarative routing, nested layouts, `<Navigate>` guards |

### UI & Styling

| Technology | Role |
|---|---|
| **Tailwind CSS** | Utility-first styling with semantic design tokens |
| **shadcn/ui** | Pre-built accessible components (Radix UI primitives) |
| **Framer Motion** | Declarative animations and page transitions |
| **Lucide React** | Icon library (tree-shakeable SVG icons) |
| **Recharts** | Dashboard charts and data visualization |

### State & Data

| Technology | Role |
|---|---|
| **React Context** | Global state (Auth, Theme) |
| **TanStack React Query** | Server state, caching, and async data management |
| **Tauri IPC (`@tauri-apps/api`)** | Invoke Rust commands; read/write SQLite via backend |

### Forms & Validation

| Technology | Role |
|---|---|
| **React Hook Form** | Performant form state management |
| **Zod** | Schema-based validation (integrated via `@hookform/resolvers`) |

---

## 3. Directory Structure

```
src/
├── assets/                  # Static images imported as ES6 modules
├── components/
│   ├── ui/                  # shadcn/ui primitives (Button, Card, Dialog…)
│   ├── shared/              # Cross-module components (Timer, Overlay, Banner)
│   ├── admin/               # Admin-specific components (TestPreviewModal)
│   ├── dashboard/           # Dashboard widgets (StudyHeatmap)
│   ├── listening/           # Listening engine components (AudioPlayer, QuestionCard)
│   ├── reading/             # Reading engine components (QuestionRenderer)
│   ├── writing/             # Writing engine components (GradingLoader, ResultsDashboard)
│   ├── AdminLayout.tsx      # Admin shell layout
│   ├── DashboardLayout.tsx  # Main app shell (sidebar + header)
│   ├── ProtectedRoute.tsx   # Auth guard wrapper
│   ├── AuthDecorativePanel.tsx
│   ├── CountryPicker.tsx
│   └── NavLink.tsx
├── contexts/
│   ├── AuthContext.tsx       # User session, profile, sign-in/out
│   └── ThemeContext.tsx      # Light/dark mode toggle
├── data/                    # Static/mock data for offline development
│   ├── mockData.ts
│   ├── listeningTestData.ts
│   ├── readingTestData.ts
│   ├── writingTestData.ts
│   └── countries.ts
├── hooks/
│   ├── use-mobile.tsx       # Responsive breakpoint detection
│   ├── use-toast.ts         # Toast notification hook
│   ├── usePersistedTimer.ts # Timer with localStorage persistence
│   └── useTestTimer.ts      # Countdown timer for test sessions
├── integrations/            # (reserved for future third-party SDK clients)
├── lib/
│   └── utils.ts             # Tailwind `cn()` merge utility
├── pages/
│   ├── admin/               # Admin pages (Dashboard, ContentLibrary, CreateContent, UserManagement)
│   ├── Dashboard.tsx         # Student dashboard
│   ├── LandingPage.tsx       # Public marketing page
│   ├── LoginPage.tsx         # Authentication
│   ├── RegisterPage.tsx
│   ├── WritingSimulator.tsx  # Writing practice engine
│   ├── ReadingModule.tsx     # Reading practice engine
│   ├── ListeningModule.tsx   # Listening practice engine
│   ├── TestLibrary.tsx       # Browse available tests
│   └── NotFound.tsx          # 404 fallback
├── services/                # Data access layer (Tauri IPC calls)
│   ├── aiGradingService.ts           # Calls Tauri command for AI grading
│   ├── contentService.ts             # Admin CRUD for test content
│   ├── practiceLibraryService.ts     # Fetch published tests for library
│   ├── listeningService.ts           # Listening test CRUD
│   ├── listeningPracticeService.ts   # Listening test data → UI model mapper
│   ├── readingTestService.ts         # Reading test CRUD
│   ├── readingPracticeService.ts     # Reading test data → UI model mapper
│   ├── writingService.ts             # Writing test CRUD
│   └── writingPracticeService.ts     # Writing test data → UI model mapper
├── test/
│   ├── setup.ts             # Vitest setup
│   └── example.test.ts
├── utils/
│   └── ieltsGrading.ts      # Band score calculation logic
├── App.tsx                  # Root component (providers + routes)
├── main.tsx                 # Entry point (ReactDOM.createRoot)
└── index.css                # Tailwind directives + design tokens
```

### Directory Responsibilities

| Directory | Purpose | Rules |
|---|---|---|
| `components/ui/` | Atomic UI primitives from shadcn/ui | Never contain business logic. Styled via Tailwind tokens only. |
| `components/{module}/` | Domain-specific composites (e.g., `reading/QuestionRenderer`) | May import from `ui/` and `shared/`. Must not import from other modules. |
| `components/shared/` | Cross-cutting components used by multiple modules | Timer, Overlays, Banners. No domain-specific logic. |
| `pages/` | Route-level components | Compose layouts + domain components. Orchestrate data fetching. |
| `services/` | Data access & transformation layer | All Tauri IPC calls live here. Map DB rows → UI models. No React imports. |
| `contexts/` | React Context providers for global state | Auth and Theme only. Kept minimal. |
| `hooks/` | Reusable stateful logic | Must be generic and composable. Prefixed with `use`. |
| `data/` | Static seed/mock data | Used for offline dev and fallback. No runtime DB calls. |
| `utils/` | Pure utility functions | No side effects. No React dependencies. |

---

## 4. Core Architectural Patterns

### 4.1 State Management

The application uses a **three-tier state model**:

| Tier | Mechanism | Examples |
|---|---|---|
| **Local State** | `useState`, `useReducer` | Form inputs, sidebar collapsed, current section index |
| **Global State** | React Context | `AuthContext` (user session, profile), `ThemeContext` (light/dark) |
| **Server State** | TanStack React Query | Test data, practice sessions, content library listings |

**Key principle:** Server state is never duplicated into global state. React Query handles caching, background refetching, and stale-while-revalidate semantics.

### 4.2 Data Fetching & API Layer

```
Page Component
  └── useQuery({ queryFn: () => practiceLibraryService.fetchTests() })
        └── practiceLibraryService.ts
              └── invoke('fetch_reading_tests') → Rust → SQLite
```

- **Service Layer** (`services/`): All database interactions are encapsulated in plain async functions. Services call Tauri commands via `lib/tauri.ts` and **map raw DB rows to typed UI models**.
- **AI Grading**: Grading calls go through `aiGradingService.ts` → Tauri command → Rust → AI gateway (API key stays in Rust, never exposed to the frontend).
- **Caching**: React Query provides automatic caching. `staleTime` and `gcTime` are configured per-query as needed.
- **Error Handling**: Errors from Tauri commands are surfaced via toast notifications using the `sonner` library.

### 4.3 Component Design

The project follows a **Smart/Presentational split**:

| Type | Location | Responsibility |
|---|---|---|
| **Smart (Container)** | `pages/` | Route rendering, data orchestration, state coordination |
| **Presentational** | `components/ui/`, `components/{module}/` | Render props/state, emit events, zero data fetching |
| **Layout** | `DashboardLayout`, `AdminLayout` | Shell chrome (sidebar, header, navigation) |
| **Guard** | `ProtectedRoute` | Auth gate — redirects unauthenticated users to `/login` |

**Component hierarchy example:**
```
ReadingModule (page — smart)
  └── DashboardLayout (layout)
        └── QuestionRenderer (presentational — renders 13 IELTS question types)
              └── ui/RadioGroup, ui/Input, ui/Checkbox (primitives)
```

### 4.4 Styling Strategy

**Utility-first with semantic design tokens:**

1. **Design Tokens** are defined as HSL CSS custom properties in `src/index.css` (`:root` and `.dark` variants).
2. **Tailwind Config** (`tailwind.config.ts`) maps tokens to classes: `bg-primary`, `text-muted-foreground`, etc.
3. **Components** use only semantic classes — never raw color values like `bg-blue-500`.
4. **Dark Mode** is toggled via a `.dark` class on `<html>`, managed by `ThemeContext`.
5. **`cn()` utility** (`lib/utils.ts`) merges Tailwind classes with conflict resolution via `tailwind-merge`.
6. **shadcn/ui** components use `class-variance-authority` (CVA) for type-safe variant props.

```tsx
// ✅ Correct — uses semantic tokens
<div className="bg-card text-card-foreground border-border" />

// ❌ Wrong — hardcoded color
<div className="bg-white text-gray-900 border-gray-200" />
```

### 4.5 Routing

**Configuration:** Flat route definitions in `App.tsx` using React Router v6.

| Route Pattern | Component | Access |
|---|---|---|
| `/` | `LandingPage` | Public |
| `/login`, `/register` | `LoginPage`, `RegisterPage` | Public |
| `/dashboard` | `Dashboard` | Public (guest mode) / Authenticated |
| `/writing`, `/reading`, `/listening` | Module engines | Public (guest mode) / Authenticated |
| `/tests` | `TestLibrary` | Public |
| `/admin/*` | Admin pages | Authenticated (no RBAC yet) |
| `*` | `NotFound` | Catch-all 404 |

**Route protection** is handled by `<ProtectedRoute>`, which checks `AuthContext.isAuthenticated` and renders a loading spinner during session hydration.

**Layout wrapping** is done inside each page component (e.g., `<DashboardLayout>` wraps the main content), not at the route level.

---

## 5. Standards & Best Practices

### File Naming

| Element | Convention | Example |
|---|---|---|
| Components | PascalCase | `QuestionRenderer.tsx` |
| Hooks | camelCase, `use` prefix | `useTestTimer.ts` |
| Services | camelCase, `Service` suffix | `readingPracticeService.ts` |
| Utilities | camelCase | `ieltsGrading.ts` |
| Pages | PascalCase | `WritingSimulator.tsx` |
| Test files | `.test.ts` / `.test.tsx` suffix | `example.test.ts` |

### Error Handling

- **Database errors**: Caught in service layer, surfaced via `toast()` from sonner.
- **Auth errors**: Returned as `{ error: Error | null }` from `AuthContext` methods; displayed in form UI.
- **Edge Function errors**: Handled in `aiGradingService.ts` with try/catch and user-facing error messages.
- **404 routes**: Caught by the `*` wildcard route rendering `NotFound`.

### Code Colocation

- Domain-specific components live next to their module pages: `components/reading/` serves `pages/ReadingModule.tsx`.
- Services are colocated by module: `readingPracticeService.ts` + `readingTestService.ts` for the reading domain.
- Shared utilities (`cn()`, `ieltsGrading`) live in `lib/` and `utils/` respectively.

### Performance Optimization

| Technique | Implementation |
|---|---|
| **Code Splitting** | Vite automatic chunk splitting on dynamic imports |
| **SWC Compiler** | `@vitejs/plugin-react-swc` for faster transpilation |
| **React Query Caching** | Prevents redundant network requests for test data |
| **Lazy Images** | Static assets imported as ES6 modules for Vite optimization |
| **CSS Purging** | Tailwind's JIT compiler removes unused utility classes |
| **Timer Persistence** | `usePersistedTimer` saves countdown to `localStorage` to survive page refreshes |
| **HMR Overlay Disabled** | `hmr.overlay: false` in Vite config for cleaner development UX |

### Key Conventions

1. **All colors must use HSL design tokens** — no hardcoded hex/rgb values in components.
2. **Services are framework-agnostic** — pure async functions, no React imports.
3. **Database schema changes** go through migration tooling, never manual SQL.
4. **Secrets** are stored in the Rust environment, never committed to source or exposed to the frontend.
