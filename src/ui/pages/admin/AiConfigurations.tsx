import {
  AlertCircle,
  Bot,
  Check,
  Eye,
  EyeOff,
  Globe,
  HardDrive,
  Loader2,
  MessageSquareText,
  RotateCcw,
  Save,
  Sparkles,
  Trash2,
  Zap,
} from "lucide-react";
import type React from "react";
import { useEffect, useMemo, useState } from "react";
import { AdminLayout } from "@/components/AdminLayout";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Skeleton } from "@/components/ui/skeleton";
import { toast } from "@/hooks/use-toast";
import { cn } from "@/lib/utils";
import {
  activateAiConfiguration,
  fetchAiConfigurations,
  removeAiConfiguration,
  saveAiConfiguration,
} from "@/services/aiConfigurationService";

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
        hint: "Works with Ollama, llama.cpp, LM Studio. Must be the OpenAI-compatible base URL (e.g. Ollama's `/v1`), not a native endpoint like `/api/chat`.",
      },
      {
        key: "model",
        label: "Model Name",
        type: "text",
        placeholder: "llama3.1",
        required: true,
        hint: "Must exactly match a model already pulled/loaded in your local runtime.",
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
      {
        key: "model",
        label: "Model Name",
        type: "text",
        placeholder: "gpt-4o-mini",
        required: false,
        hint: "Defaults to gpt-4o-mini if left blank.",
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
  const [activeId, setActiveId] = useState<ProviderId | null>(null);
  const [drafts, setDrafts] = useState<Record<string, DraftValues>>({});
  const [configured, setConfigured] = useState<Partial<Record<ProviderId, boolean>>>({});
  const [saveState, setSaveState] = useState<SaveState>("idle");
  const [isLoading, setIsLoading] = useState(true);
  const [loadError, setLoadError] = useState<string | null>(null);
  const [saveError, setSaveError] = useState<string | null>(null);
  const [activateState, setActivateState] = useState<"idle" | "activating">("idle");
  const [activateError, setActivateError] = useState<string | null>(null);
  const [deleteTarget, setDeleteTarget] = useState<ProviderId | null>(null);
  const [deleting, setDeleting] = useState(false);

  useEffect(() => {
    let cancelled = false;

    const load = async () => {
      setIsLoading(true);
      setLoadError(null);
      try {
        const { configuredMap, activeProviderId } = await fetchAiConfigurations();
        if (cancelled) return;
        setConfigured(configuredMap as Partial<Record<ProviderId, boolean>>);
        setActiveId((activeProviderId as ProviderId | null) ?? null);
      } catch (err) {
        if (cancelled) return;
        setLoadError(err instanceof Error ? err.message : String(err));
      } finally {
        if (!cancelled) setIsLoading(false);
      }
    };

    load();
    return () => {
      cancelled = true;
    };
  }, []);

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
    if (saveError) setSaveError(null);
  };

  const handleSelect = (id: ProviderId) => {
    setSelectedId(id);
    setSaveState("idle");
    setSaveError(null);
    setActivateError(null);
  };

  const handleSave = async () => {
    if (!isValid) return;
    setSaveState("saving");
    setSaveError(null);
    try {
      const result = await saveAiConfiguration(selectedId, currentValues);
      setConfigured((prev) => ({ ...prev, [selectedId]: result.configured }));
      if (result.isActive) setActiveId(selectedId);
      setSaveState("saved");
    } catch (err) {
      setSaveError(err instanceof Error ? err.message : String(err));
      setSaveState("idle");
    }
  };

  const handleReset = () => {
    setDrafts((prev) => ({ ...prev, [selectedId]: {} }));
    setSaveState("idle");
    setSaveError(null);
  };

  const handleActivate = async () => {
    setActivateState("activating");
    setActivateError(null);
    try {
      const result = await activateAiConfiguration(selectedId);
      if (result.isActive) setActiveId(selectedId);
    } catch (err) {
      setActivateError(err instanceof Error ? err.message : String(err));
    } finally {
      setActivateState("idle");
    }
  };

  const handleDeleteConfirm = async () => {
    if (!deleteTarget) return;
    const providerId = deleteTarget;
    setDeleting(true);
    try {
      await removeAiConfiguration(providerId);
      setConfigured((prev) => ({ ...prev, [providerId]: false }));
      setActiveId((prev) => (prev === providerId ? null : prev));
      setDrafts((prev) => ({ ...prev, [providerId]: {} }));
      toast({ title: `${PROVIDERS.find((p) => p.id === providerId)?.name ?? providerId} configuration deleted` });
    } catch (err) {
      toast({
        title: "Failed to delete configuration",
        description: err instanceof Error ? err.message : String(err),
        variant: "destructive",
      });
    } finally {
      setDeleting(false);
      setDeleteTarget(null);
    }
  };

  const isActiveProvider = activeId === selectedId;
  const ProviderIcon = provider.icon;
  const deleteTargetProvider = PROVIDERS.find((p) => p.id === deleteTarget);

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

        {loadError && (
          <div className="rounded-xl border border-destructive/30 bg-destructive/5 p-4 flex items-center gap-2 text-sm text-destructive">
            <AlertCircle size={16} className="shrink-0" />
            Failed to load AI configurations: {loadError}
          </div>
        )}

        {isLoading ? (
          <Card className="overflow-hidden">
            <CardContent className="p-8 space-y-4">
              <Skeleton className="h-6 w-48" />
              <Skeleton className="h-4 w-72" />
              <Skeleton className="h-32 w-full" />
            </CardContent>
          </Card>
        ) : (
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
                  {!!configured[selectedId] && (
                    <div className="flex items-center gap-1.5 shrink-0">
                      {!isActiveProvider && (
                        <Button
                          type="button"
                          variant="outline"
                          size="sm"
                          onClick={handleActivate}
                          disabled={activateState === "activating"}
                          className="gap-1.5"
                        >
                          {activateState === "activating" ? (
                            <Loader2 size={14} strokeWidth={2} className="animate-spin" />
                          ) : (
                            <Zap size={14} strokeWidth={2} />
                          )}
                          Set as active
                        </Button>
                      )}
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        onClick={() => setDeleteTarget(selectedId)}
                        className="gap-1.5 text-destructive hover:text-destructive"
                        aria-label={`Delete ${provider.name} configuration`}
                      >
                        <Trash2 size={14} strokeWidth={2} />
                        Delete
                      </Button>
                    </div>
                  )}
                </div>

                {activateError && (
                  <div className="mb-6 rounded-xl border border-destructive/30 bg-destructive/5 p-3 flex items-center gap-2 text-xs text-destructive">
                    <AlertCircle size={14} className="shrink-0" />
                    Failed to activate configuration: {activateError}
                  </div>
                )}

                <div className="space-y-5 mb-8">
                  {provider.fields.map((f) => (
                    <ConfigField key={f.key} field={f} value={currentValues[f.key]} onChange={handleFieldChange} />
                  ))}
                </div>

                {saveError && (
                  <div className="mb-6 rounded-xl border border-destructive/30 bg-destructive/5 p-3 flex items-center gap-2 text-xs text-destructive">
                    <AlertCircle size={14} className="shrink-0" />
                    Failed to save configuration: {saveError}
                  </div>
                )}

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
        )}
      </div>

      <AlertDialog open={!!deleteTarget} onOpenChange={(open) => !open && !deleting && setDeleteTarget(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete "{deleteTargetProvider?.name}" configuration?</AlertDialogTitle>
            <AlertDialogDescription>
              This will permanently remove the stored credentials for {deleteTargetProvider?.name} and deactivate it
              if it's currently the active provider. This action cannot be undone.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={deleting}>Cancel</AlertDialogCancel>
            <AlertDialogAction
              onClick={handleDeleteConfirm}
              disabled={deleting}
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
            >
              {deleting ? (
                <>
                  <Loader2 className="h-4 w-4 animate-spin mr-2" /> Deleting...
                </>
              ) : (
                "Delete"
              )}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </AdminLayout>
  );
};

export default AiConfigurations;
