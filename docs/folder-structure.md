# Folder Structure

## What This Project Is
Tauri@2 + React@19 desktop IELTS prep app. Rust backend (`src/core`), TypeScript frontend (`src/ui`), Docusaurus site (`website/`), internal docs (`docs/`).

## Tree
```
.
├── AGENTS.md                        # Read this first — always
├── docs/                            # Internal architecture & product docs
│   └── prompts/                     # AI seed-generation prompt templates
├── public/                          # Static root-served assets (Vite)
├── src/
│   ├── core/                        # Rust / Tauri 2 backend
│   │   └── src/
│   │       ├── commands/            # #[tauri::command] — one file per domain
│   │       ├── repositories/        # Data access — one file per domain
│   │       └── database/
│   │           ├── migrations/      # SQL schema migrations
│   │           └── seeds/           # SQL seed data {listening,reading,writing}
│   └── ui/                          # React / TypeScript frontend
│       ├── components/
│       │   ├── ui/                  # Base design-system primitives (shadcn)
│       │   └── {feature}/           # admin, dashboard, listening, reading, writing, shared
│       ├── pages/                   # Route-level components
│       ├── services/                # Business logic + Tauri/Supabase calls
│       ├── hooks/                   # Shared custom hooks
│       ├── lib/
│       │   ├── tauri.ts             # ⚠️ ONLY place to call invoke()
│       │   └── utils.ts
│       ├── contexts/                # React context providers
│       └── integrations/supabase/   # Supabase client & generated types
└── website/                         # Docusaurus public site (independent)
```

## Where to Put New Code

| What | Where |
|---|---|
| New Tauri command | `src/core/src/commands/` |
| New DB query / data access | `src/core/src/repositories/` |
| New DB migration | `src/core/src/database/migrations/` |
| New DB seed | `src/core/src/database/seeds/{module}/` |
| New base UI primitive | `src/ui/components/ui/` |
| New feature component | `src/ui/components/{feature}/` |
| New route/page | `src/ui/pages/` |
| New business logic / API call | `src/ui/services/` |
| New Tauri IPC wrapper | `src/ui/lib/tauri.ts` — nowhere else |
| New shared hook | `src/ui/hooks/` |
| New component test | `__tests__/` colocated next to the component |
| New architecture/product doc | `docs/` |

## Critical Rules for AI

- **Read `AGENTS.md` first** — root, `src/core/`, and `src/ui/` each have one. Always read the closest one before editing.
- **Never call `invoke()` directly** — only through `src/ui/lib/tauri.ts`.
- **`components/` is presentation-only** — logic belongs in `services/`.
- **One file per domain** in `commands/` and `repositories/` — follow the pattern, don't consolidate.
- **Never edit generated files** — `src/ui/dist/`, `src/core/gen/schemas/`.
- **`docs/` ≠ `website/docs/`** — first is internal, second is public Docusaurus.
- **Rust → TS naming**: Rust uses `snake_case` + `#[serde(rename_all = "camelCase")]`; TS mirrors in `camelCase`. IPC command strings stay `snake_case` on both sides.