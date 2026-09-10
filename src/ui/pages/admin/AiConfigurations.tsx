import {
  Bot,
  Check,
  Eye,
  EyeOff,
  Globe,
  HardDrive,
  MessageSquareText,
  RotateCcw,
  Save,
  Sparkles,
  Zap,
} from "lucide-react";
import type React from "react";
import { useMemo, useState } from "react";
import { AdminLayout } from "@/components/AdminLayout";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { cn } from "@/lib/utils";

// ── Types ──────────────────────────────────────────────────
type ProviderId = "gemini" | "chatgpt" | "claude" | "local" | "general";

interface ProviderField {
  key: string;
  label: string;
  type: "text" | "password";
  placeholder: string;
  required: boolean;
  hint?: string;
}

interface Provider {
  id: ProviderId;
  name: string;
  vendor: string;
  tagline: string;
  icon: React.ElementType;
  fields: ProviderField[];
}

type DraftValues = Record<string, string>;
type SaveState = "idle" | "saving" | "saved";

// ── Provider schema ────────────────────────────────────────
const PROVIDERS: Provider[] = [
  {
    id: "gemini",
    name: "Gemini",
    vendor: "Google",
    tagline: "Multimodal generation and scoring.",
    icon: Sparkles,
    fields: [
      {
        key: "apiKey",
        label: "API Key",
        type: "password",
        placeholder: "AIzaSy…",
        required: true,
        hint: "Generate from Google AI Studio.",
      },
    ],
  },
  {
    id: "chatgpt",
    name: "ChatGPT",
    vendor: "OpenAI",
    tagline: "GPT-family reasoning and feedback.",
    icon: MessageSquareText,
    fields: [
      {
        key: "apiKey",
        label: "API Key",
        type: "password",
        placeholder: "sk-…",
        required: true,
        hint: "Found under platform.openai.com → API keys.",
      },
    ],
  },
  {
    id: "claude",
    name: "Claude",
    vendor: "Anthropic",
    tagline: "Long-form writing evaluation.",
    icon: Bot,
    fields: [
      {
        key: "apiKey",
        label: "API Key",
        type: "password",
        placeholder: "sk-ant-…",
        required: true,
        hint: "Issued from console.anthropic.com.",
      },
    ],
  },
  {
    id: "local",
    name: "Local Model",
    vendor: "On-device",
    tagline: "Route requests to a local runtime.",
    icon: HardDrive,
    fields: [
      {
        key: "endpoint",
        label: "Path or Endpoint URL",
        type: "text",
        placeholder: "http://localhost:11434/v1",
        required: true,
        hint: "Works with Ollama, llama.cpp, LM Studio.",
      },
    ],
  },
  {
    id: "general",
    name: "General",
    vendor: "Custom",
    tagline: "Any OpenAI-compatible endpoint.",
    icon: Globe,
    fields: [
      {
        key: "endpoint",
        label: "Endpoint URL",
        type: "text",
        placeholder: "https://api.example.com/v1/chat/completions",
        required: true,
      },
      {
        key: "headerName",
        label: "Auth Header Name",
        type: "text",
        placeholder: "Authorization",
        required: true,
        hint: "The header the provider expects the key on.",
      },
      {
        key: "apiKey",
        label: "API Key",
        type: "password",
        placeholder: "your-secret-key",
        required: false,
      },
    ],
  },
];

// ── Provider rail item ─────────────────────────────────────
interface ProviderRailItemProps {
  provider: Provider;
  selected: boolean;
  isActive: boolean;
  isConfigured: boolean;
  onSelect: (id: ProviderId) => void;
}

const ProviderRailItem: React.FC<ProviderRailItemProps> = ({
  provider,
  selected,
  isActive,
  isConfigured,
  onSelect,
}) => {
  const Icon = provider.icon;
  return (
    <button
      type="button"
      onClick={() => onSelect(provider.id)}
      className={cn(
        "w-full text-left px-3 py-3 rounded-xl transition-all flex items-center gap-3 border",
        selected
          ? "bg-accent/50 border-border shadow-[inset_2px_0_0_theme(colors.violet.600)]"
          : "bg-transparent border-transparent hover:bg-accent/50"
      )}
    >
      <div
        className={cn(
          "w-9 h-9 rounded-lg grid place-items-center shrink-0 transition-colors",
          selected ? "bg-violet-100 text-violet-600 dark:bg-violet-900/30 dark:text-violet-400" : "bg-muted text-muted-foreground"
        )}
      >
        <Icon size={17} strokeWidth={1.75} />
      </div>
      <div className="min-w-0 flex-1">
        <div className="flex items-center gap-2">
          <span className="text-sm font-semibold truncate text-foreground">{provider.name}</span>
          {isActive && (
            <Badge className="bg-violet-100 text-violet-700 dark:bg-violet-900/30 dark:text-violet-400 border-transparent text-[9px] tracking-wider">
              ACTIVE
            </Badge>
          )}
        </div>
        <div className="text-[11px] uppercase tracking-wider text-muted-foreground">{provider.vendor}</div>
      </div>
      <span
        className={cn(
          "w-2 h-2 rounded-full shrink-0",
          isConfigured ? "bg-emerald-500" : "bg-muted-foreground/30"
        )}
        title={isConfigured ? "Configured" : "Not configured"}
      />
    </button>
  );
};

// ── Config field ────────────────────────────────────────────
interface ConfigFieldProps {
  field: ProviderField;
  value: string | undefined;
  onChange: (key: string, value: string) => void;
}

const ConfigField: React.FC<ConfigFieldProps> = ({ field, value, onChange }) => {
  const [reveal, setReveal] = useState(false);
  const isSecret = field.type === "password";
  const inputType = isSecret && !reveal ? "password" : "text";

  return (
    <div>
      <div className="flex items-baseline justify-between mb-2">
        <Label htmlFor={field.key}>{field.label}</Label>
        <span className="text-[10px] tracking-wider font-medium text-muted-foreground">
          {field.required ? "REQUIRED" : "OPTIONAL"}
        </span>
      </div>
      <div className="relative">
        <Input
          id={field.key}
          type={inputType}
          value={value ?? ""}
          onChange={(e) => onChange(field.key, e.target.value)}
          placeholder={field.placeholder}
          className={cn("font-mono", isSecret && "pr-11")}
          spellCheck={false}
          autoComplete="off"
        />
        {isSecret && (
          <button
            type="button"
            onClick={() => setReveal((r) => !r)}
            className="absolute right-3 top-1/2 -translate-y-1/2 p-1 rounded-md text-muted-foreground hover:text-foreground"
            aria-label={reveal ? "Hide value" : "Show value"}
          >
            {reveal ? <EyeOff size={16} /> : <Eye size={16} />}
          </button>
        )}
      </div>
      {field.hint && <p className="mt-1.5 text-xs text-muted-foreground">{field.hint}</p>}
    </div>
  );
};

// ── Main page ───────────────────────────────────────────────
const AiConfigurations: React.FC = () => {
  const [selectedId, setSelectedId] = useState<ProviderId>("claude");
  const [activeId, setActiveId] = useState<ProviderId>("claude");
  const [drafts, setDrafts] = useState<Record<string, DraftValues>>({});
  const [configured, setConfigured] = useState<Partial<Record<ProviderId, boolean>>>({ claude: true });
  const [saveState, setSaveState] = useState<SaveState>("idle");

  const provider = useMemo(() => PROVIDERS.find((p) => p.id === selectedId) ?? PROVIDERS[0], [selectedId]);
  const currentValues = drafts[selectedId] ?? {};

  const isValid = provider.fields
    .filter((f) => f.required)
    .every((f) => (currentValues[f.key] ?? "").trim().length > 0);

  const isDirty = Object.values(currentValues).some((v) => (v ?? "").trim().length > 0);

  const handleFieldChange = (key: string, value: string) => {
    setDrafts((prev) => ({
      ...prev,
      [selectedId]: { ...(prev[selectedId] ?? {}), [key]: value },
    }));
    if (saveState === "saved") setSaveState("idle");
  };

  const handleSelect = (id: ProviderId) => {
    setSelectedId(id);
    setSaveState("idle");
  };

  const handleSave = () => {
    if (!isValid) return;
    setSaveState("saving");
    // Frontend-only mock: backend persistence will be wired up later.
    setTimeout(() => {
      setConfigured((prev) => ({ ...prev, [selectedId]: true }));
      setActiveId(selectedId);
      setSaveState("saved");
    }, 500);
  };

  const handleReset = () => {
    setDrafts((prev) => ({ ...prev, [selectedId]: {} }));
    setSaveState("idle");
  };

  const isActiveProvider = activeId === selectedId;
  const ProviderIcon = provider.icon;

  return (
    <AdminLayout>
      <div className="p-6 md:p-8 max-w-6xl mx-auto space-y-6">
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <h1 className="text-2xl font-bold md:text-3xl">AI Model Configurations</h1>
            <p className="text-muted-foreground mt-1 max-w-2xl">
              One provider powers content generation and evaluation at a time. Pick a provider from the list, then
              save its credentials to make it active.
            </p>
          </div>
          <Badge variant="outline" className="font-mono tracking-wider shrink-0">
            V1.0 SCHEMA
          </Badge>
        </div>

        {/* Split pane */}
        <Card className="overflow-hidden">
          <CardContent className="p-0">
            <div className="grid grid-cols-1 md:grid-cols-[280px_1fr]">
              {/* Left rail */}
              <div className="p-4 border-b md:border-b-0 md:border-r border-border">
                <div className="px-3 pb-3 text-[11px] tracking-wider font-semibold text-muted-foreground">
                  PROVIDERS
                </div>
                <div className="space-y-1">
                  {PROVIDERS.map((p) => (
                    <ProviderRailItem
                      key={p.id}
                      provider={p}
                      selected={selectedId === p.id}
                      isActive={activeId === p.id}
                      isConfigured={!!configured[p.id]}
                      onSelect={handleSelect}
                    />
                  ))}
                </div>

                <div className="mt-6 pt-4 border-t border-border px-3 space-y-2">
                  <div className="flex items-center gap-2 text-[11px] text-muted-foreground">
                    <span className="w-2 h-2 rounded-full bg-emerald-500" />
                    Credentials saved
                  </div>
                  <div className="flex items-center gap-2 text-[11px] text-muted-foreground">
                    <span className="w-2 h-2 rounded-full bg-muted-foreground/30" />
                    Not configured
                  </div>
                </div>
              </div>

              {/* Right panel */}
              <div className="p-8">
                <div className="flex items-start gap-4 mb-8">
                  <div className="w-14 h-14 rounded-2xl grid place-items-center shrink-0 bg-violet-100 text-violet-600 dark:bg-violet-900/30 dark:text-violet-400">
                    <ProviderIcon size={26} strokeWidth={1.75} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2.5 flex-wrap mb-1">
                      <h2 className="text-xl font-bold leading-tight text-foreground">{provider.name}</h2>
                      <span className="text-[11px] uppercase tracking-wider text-muted-foreground">
                        {provider.vendor}
                      </span>
                      {isActiveProvider && (
                        <Badge className="bg-violet-100 text-violet-700 dark:bg-violet-900/30 dark:text-violet-400 border-transparent gap-1 text-[10px] tracking-wider">
                          <Zap size={10} strokeWidth={2.5} />
                          ACTIVE
                        </Badge>
                      )}
                    </div>
                    <p className="text-sm text-muted-foreground">{provider.tagline}</p>
                  </div>
                </div>

                <div className="space-y-5 mb-8">
                  {provider.fields.map((f) => (
                    <ConfigField key={f.key} field={f} value={currentValues[f.key]} onChange={handleFieldChange} />
                  ))}
                </div>

                <div className="flex items-center justify-between pt-6 border-t border-border">
                  <div className="text-xs text-muted-foreground">
                    {saveState === "saved"
                      ? `${provider.name} is now the active model.`
                      : isValid
                        ? isActiveProvider
                          ? "Save to update credentials for the active model."
                          : `Saving will switch the active model to ${provider.name}.`
                        : "Fill required fields to save."}
                  </div>
                  <div className="flex items-center gap-2">
                    {isDirty && saveState !== "saved" && (
                      <Button type="button" variant="ghost" size="sm" onClick={handleReset} className="gap-1.5">
                        <RotateCcw size={14} strokeWidth={2} />
                        Reset
                      </Button>
                    )}
                    <Button
                      type="button"
                      size="sm"
                      onClick={handleSave}
                      disabled={!isValid || saveState === "saving"}
                      className={cn(
                        "gap-2",
                        isValid && "bg-violet-600 hover:bg-violet-700 text-white"
                      )}
                    >
                      {saveState === "saved" ? (
                        <>
                          <Check size={14} strokeWidth={2.5} />
                          Saved
                        </>
                      ) : (
                        <>
                          <Save size={14} strokeWidth={2} />
                          {saveState === "saving" ? "Saving…" : "Save configuration"}
                        </>
                      )}
                    </Button>
                  </div>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </AdminLayout>
  );
};

export default AiConfigurations;
