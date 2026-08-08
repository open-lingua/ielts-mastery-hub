# src/ui — React / TypeScript Layer

## Key Libraries

| Library                        | Purpose                                      |
|-------------------------------|----------------------------------------------|
| React [YOUR VERSION]          | UI framework                                 |
| TypeScript (strict mode)      | Type safety                                  |
| Vite                          | Dev server and bundler                       |
| `@tauri-apps/api`             | Tauri IPC bindings (`invoke`, `listen`)      |
| `[YOUR STATE LIB]`            | [e.g. Zustand → global state management]     |
| `[YOUR UI LIB]`               | [e.g. shadcn/ui + Tailwind → component kit]  |
| `[YOUR ROUTER]`               | [e.g. React Router v6 → client-side routing] |
| `[YOUR QUERY LIB]`            | [e.g. TanStack Query → async data fetching]  |

## Calling Tauri Commands

Always use the typed wrapper in `src/ui/src/lib/tauri.ts` — never call `invoke` directly in components.

```typescript
// src/ui/src/lib/tauri.ts
import { invoke } from '@tauri-apps/api/core';

export async function myCommand(arg: string): Promise<MyResponse> {
  return invoke<MyResponse>('my_command', { arg });
}
```

- Command name strings must exactly match the Rust `#[tauri::command]` function name (snake_case).
- Always type the generic on `invoke<T>` — never use `invoke` without a return type.
- Wrap all `invoke` calls in `try/catch`; backend errors arrive as thrown values (not rejected with `Error` instances).

## Listening to Tauri Events

```typescript
import { listen } from '@tauri-apps/api/event';

const unlisten = await listen<MyPayload>('event_name', (event) => {
  console.log(event.payload);
});

// Always clean up in useEffect return
return () => { unlisten(); };
```

## Folder Structure

```
src/ui/src/
├── assets/          # Static assets (images, fonts)
├── components/      # Reusable UI components (no business logic)
│   └── ui/          # Base design system components
├── features/        # Feature-scoped folders (reading/, writing/, listening/)
│   └── [feature]/
│       ├── components/
│       ├── hooks/
│       └── [feature].store.ts
├── hooks/           # Shared custom hooks
├── lib/
│   ├── tauri.ts     # All typed invoke() wrappers — single source of truth
│   └── utils.ts     # Pure utility functions
├── stores/          # Global state (Zustand stores or equivalent)
├── types/           # Shared TypeScript interfaces and enums
│   └── index.ts
├── pages/           # Route-level components (one per route)
└── main.tsx         # App entry point
```

## TypeScript Conventions

- `strict: true` is enabled — no implicit `any`, no non-null assertions without justification.
- All IPC payload types live in `src/ui/src/types/` and mirror the Rust structs (camelCase fields).
- Use `interface` for object shapes, `type` for unions and aliases.
- Prefix event handler props with `on` (e.g., `onSubmit`, `onClose`).
- Enums: use `const enum` only for pure compile-time constants; prefer union string types otherwise.

## Styling

- **[YOUR STYLING APPROACH e.g. Tailwind CSS v3]** — utility-first, no custom CSS unless unavoidable.
- Design tokens / theme config in `tailwind.config.ts`.
- Component variants managed with `[YOUR TOOL e.g. cva (class-variance-authority)]`.
- Do not use inline `style={{}}` props — use Tailwind classes or CSS variables.

## State Management

- **[YOUR TOOL e.g. Zustand]**: one store file per feature domain in `features/[feature]/[feature].store.ts`.
- Global cross-feature state in `src/ui/src/stores/`.
- Server/async state (Tauri command results) managed via **[YOUR TOOL e.g. TanStack Query]** — do not cache Tauri responses manually in component state.

## Do NOT

- Do not call `invoke` directly inside components or pages — always go through `src/lib/tauri.ts`.
- Do not use `any` — use `unknown` and narrow with type guards.
- Do not store derived data in state — compute it from source state.
- Do not use `useEffect` to sync state to state — use derived values or selectors.
- Do not import from `@tauri-apps/api` anywhere except `src/lib/tauri.ts` — keeps IPC calls auditable.
- Do not use `window.__TAURI__` directly — always use the official API package.
