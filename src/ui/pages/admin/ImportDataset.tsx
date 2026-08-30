import { useRef, useCallback, useState } from "react";
import {
  AlertCircle,
  ArrowUpToLine,
  Check,
  CircleDot,
  Copy,
  FileJson,
  Loader2,
  Music4,
  ShieldCheck,
  X,
} from "lucide-react";
import type React from "react";
import { useNavigate } from "react-router-dom";
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
import { AdminLayout } from "@/components/AdminLayout";
import { Badge } from "@/components/ui/badge";
import { toast } from "@/hooks/use-toast";
import type { ImportAudioFile, ImportKind, ImportPreview } from "@/lib/tauri";
import { cn } from "@/lib/utils";
import { parseImportFile, runImport, validate, validateListeningAudioSlots } from "@/services/importService";

const SECTION_SLOTS = [1, 2, 3, 4] as const;
const TEST_TYPES: { id: ImportKind; label: string }[] = [
  { id: "reading", label: "Reading" },
  { id: "writing", label: "Writing" },
  { id: "listening", label: "Listening" },
];

function fmtBytes(b: number): string {
  if (b < 1024) return `${b} B`;
  if (b < 1024 * 1024) return `${(b / 1024).toFixed(1)} KB`;
  return `${(b / (1024 * 1024)).toFixed(1)} MB`;
}

interface DropZoneProps {
  label?: string;
  hint?: string;
  accept: string;
  file: File | null;
  onFile: (f: File | null) => void;
  compact?: boolean;
  icon?: React.ElementType;
}

function DropZone({ label, hint, accept, file, onFile, compact = false, icon: Icon = FileJson }: DropZoneProps) {
  const [dragging, setDragging] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);

  const onDrop = useCallback(
    (e: React.DragEvent) => {
      e.preventDefault();
      setDragging(false);
      const f = e.dataTransfer.files?.[0];
      if (f) onFile(f);
    },
    [onFile]
  );

  return (
    <div className="w-full">
      {(label || hint) && (
        <div className="mb-2 flex items-baseline justify-between">
          {label && <span className="text-[13px] font-medium text-foreground">{label}</span>}
          {hint && (
            <span className="font-mono text-[11px] uppercase tracking-wider text-muted-foreground">{hint}</span>
          )}
        </div>
      )}
      <label
        onDragOver={(e) => { e.preventDefault(); setDragging(true); }}
        onDragLeave={() => setDragging(false)}
        onDrop={onDrop}
        className={cn(
          "group relative flex cursor-pointer items-center gap-3 rounded-xl border transition-all duration-200",
          compact ? "px-3 py-3" : "px-4 py-5",
          file
            ? "border-violet-200 bg-violet-50/40 dark:border-violet-800 dark:bg-violet-900/20"
            : dragging
            ? "border-violet-500 bg-violet-50 ring-4 ring-violet-100 dark:bg-violet-900/30 dark:ring-violet-900/50"
            : "border-dashed border-border bg-muted/30 hover:border-violet-300 hover:bg-violet-50/30 dark:bg-muted/20 dark:hover:border-violet-700 dark:hover:bg-violet-900/10"
        )}
      >
        <input
          ref={inputRef}
          type="file"
          accept={accept}
          className="sr-only"
          onChange={(e) => {
            const f = e.target.files?.[0];
            if (f) onFile(f);
          }}
        />

        <div
          className={cn(
            "flex h-10 w-10 shrink-0 items-center justify-center rounded-lg transition-colors",
            file
              ? "bg-violet-600 text-white"
              : dragging
              ? "bg-violet-100 text-violet-700 dark:bg-violet-900 dark:text-violet-400"
              : "bg-card text-muted-foreground ring-1 ring-border group-hover:text-violet-500"
          )}
        >
          {file ? <Check size={18} strokeWidth={2.5} /> : <Icon size={18} />}
        </div>

        <div className="min-w-0 flex-1">
          {file ? (
            <>
              <div className="truncate text-[13px] font-medium text-foreground">{file.name}</div>
              <div className="mt-0.5 text-[11px] text-muted-foreground">{fmtBytes(file.size)} · Ready to upload</div>
            </>
          ) : (
            <>
              <div className="text-[13px] font-medium text-foreground">
                {dragging ? "Release to attach" : "Drop file or click to browse"}
              </div>
              <div className="mt-0.5 text-[11px] text-muted-foreground">
                {accept.replace(/,/g, " · ").replace(/\./g, "")}
              </div>
            </>
          )}
        </div>

        {file ? (
          <button
            type="button"
            onClick={(e) => { e.preventDefault(); onFile(null); }}
            className="rounded-md p-1.5 text-muted-foreground transition-colors hover:bg-card hover:text-foreground"
            aria-label="Remove file"
          >
            <X size={14} />
          </button>
        ) : (
          <span className="hidden shrink-0 rounded-md bg-card px-2.5 py-1 text-[11px] font-medium text-muted-foreground ring-1 ring-border group-hover:text-violet-700 dark:group-hover:text-violet-400 sm:inline">
            Browse
          </span>
        )}
      </label>
    </div>
  );
}

function TestTypeSegmented({ value, onChange }: { value: ImportKind; onChange: (v: ImportKind) => void }) {
  const idx = TEST_TYPES.findIndex((t) => t.id === value);
  return (
    <div className="relative inline-flex w-full max-w-md rounded-xl bg-muted/80 p-1 ring-1 ring-border">
      <div
        className="absolute top-1 bottom-1 rounded-lg bg-card shadow-sm ring-1 ring-violet-100 dark:ring-violet-900/50 transition-all duration-300 ease-[cubic-bezier(0.32,0.72,0,1)]"
        style={{
          width: `calc((100% - 8px) / ${TEST_TYPES.length})`,
          transform: `translateX(calc(${idx} * 100%))`,
          left: 4,
        }}
      />
      {TEST_TYPES.map((t) => (
        <button
          key={t.id}
          type="button"
          onClick={() => onChange(t.id)}
          className={cn(
            "relative z-10 flex-1 rounded-lg px-4 py-2 text-[13px] font-medium transition-colors",
            value === t.id ? "text-violet-700 dark:text-violet-400" : "text-muted-foreground hover:text-foreground"
          )}
        >
          {t.label}
        </button>
      ))}
    </div>
  );
}

interface StepProps {
  n: string;
  title: string;
  eyebrow: string;
  complete: boolean;
  active: boolean;
  children: React.ReactNode;
}

function Step({ n, title, eyebrow, complete, active, children }: StepProps) {
  return (
    <div className="relative pl-16">
      <div
        className={cn(
          "absolute left-0 top-1 flex h-11 w-11 items-center justify-center rounded-full font-mono text-[13px] font-medium transition-all duration-300",
          complete
            ? "bg-violet-600 text-white shadow-[0_4px_14px_-4px_rgba(124,58,237,0.5)]"
            : active
            ? "bg-card text-violet-700 ring-2 ring-violet-500 dark:text-violet-400"
            : "bg-card text-muted-foreground ring-1 ring-border"
        )}
      >
        {complete ? <Check size={16} strokeWidth={3} /> : n}
      </div>
      <div className="rounded-2xl border border-border bg-card p-6 shadow-[0_1px_2px_rgba(15,15,20,0.03),0_8px_24px_-16px_rgba(15,15,20,0.08)]">
        <div className="mb-2 font-mono text-[10px] font-medium uppercase tracking-[0.14em] text-violet-500">
          {eyebrow}
        </div>
        <h3 className="mb-5 text-[17px] font-semibold text-foreground">{title}</h3>
        {children}
      </div>
    </div>
  );
}

const ImportDataset: React.FC = () => {
  const navigate = useNavigate();
  const [kind, setKind] = useState<ImportKind>("reading");
  const [jsonFile, setJsonFile] = useState<File | null>(null);
  const [audioFiles, setAudioFiles] = useState<Record<number, File | null>>({ 1: null, 2: null, 3: null, 4: null });
  const [isValidating, setIsValidating] = useState(false);
  const [isImporting, setIsImporting] = useState(false);
  const [preview, setPreview] = useState<ImportPreview | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [confirmDuplicate, setConfirmDuplicate] = useState(false);
  const [parsedJson, setParsedJson] = useState<unknown>(null);

  const resolvedAudioFiles = (): ImportAudioFile[] =>
    SECTION_SLOTS.filter((n) => audioFiles[n]).map((n) => ({ sectionNumber: n, file: audioFiles[n] as File }));

  const resetOutcome = () => {
    setPreview(null);
    setError(null);
  };

  const handleKindChange = (value: ImportKind) => {
    setKind(value);
    setJsonFile(null);
    setAudioFiles({ 1: null, 2: null, 3: null, 4: null });
    resetOutcome();
  };

  const handleValidate = async () => {
    if (!jsonFile) return;
    resetOutcome();

    if (kind === "listening") {
      const slotError = validateListeningAudioSlots(resolvedAudioFiles());
      if (slotError) {
        setError(slotError);
        return;
      }
    }

    setIsValidating(true);
    try {
      const { json } = await parseImportFile(jsonFile);
      setParsedJson(json);
      const result = await validate(kind, json, kind === "listening" ? resolvedAudioFiles() : []);
      setPreview(result);
    } catch (e) {
      console.error("[ImportDataset] handleValidate: failed", { kind }, e);
      setError(e instanceof Error ? e.message : String(e));
    } finally {
      setIsValidating(false);
    }
  };

  const doImport = async () => {
    setIsImporting(true);
    setError(null);
    try {
      const testId = await runImport(kind, parsedJson, kind === "listening" ? resolvedAudioFiles() : []);
      toast({
        title: "Import successful",
        description: `"${preview?.title}" imported (id ${testId}).`,
      });
      navigate("/admin/content");
    } catch (e) {
      console.error("[ImportDataset] doImport: failed", { kind }, e);
      setError(e instanceof Error ? e.message : String(e));
    } finally {
      setIsImporting(false);
    }
  };

  const handleImportClick = () => {
    if (preview?.duplicate_of) {
      setConfirmDuplicate(true);
      return;
    }
    doImport();
  };

  const handleCopyError = () => {
    if (error) navigator.clipboard.writeText(error);
  };

  const needsAudio = kind === "listening";
  const allAudioFilled = SECTION_SLOTS.every((n) => !!audioFiles[n]);
  const filesReady = !!jsonFile && (!needsAudio || allAudioFilled);
  const step2Complete = filesReady;
  const step3Complete = !!preview;
  const canValidate = !!jsonFile && !isValidating;
  const canImport = !!preview && !isImporting;

  return (
    <AdminLayout>
      <div
        className="min-h-full"
        style={{
          backgroundImage:
            "radial-gradient(circle at 1px 1px, rgba(15,15,20,0.035) 1px, transparent 0)",
          backgroundSize: "22px 22px",
        }}
      >
        <div className="mx-auto max-w-3xl px-10 py-12">
          <div className="mb-10 flex items-start justify-between">
            <div>
              <div className="mb-2 flex items-center gap-2 font-mono text-[10px] font-medium uppercase tracking-[0.16em] text-violet-500">
                <CircleDot size={10} />
                Content Operations
              </div>
              <h1 className="text-[28px] font-semibold tracking-tight text-foreground">Import dataset</h1>
              <p className="mt-1.5 text-[13px] text-muted-foreground">
                Upload a JSON test file to bulk-import a Reading, Writing, or Listening test.
              </p>
            </div>
            <div className="rounded-lg border border-border bg-card px-3 py-2 font-mono text-[10px] uppercase tracking-wider text-muted-foreground">
              v1.0 schema
            </div>
          </div>

          <div className="relative space-y-6">
            <div className="absolute left-[22px] top-6 bottom-6 w-px bg-border" aria-hidden />
            <div
              className="absolute left-[22px] top-6 w-px bg-gradient-to-b from-violet-500 via-violet-500 to-violet-300 transition-[height] duration-500 ease-out"
              style={{
                height: `calc(${step3Complete ? 100 : step2Complete ? 66 : 33}% - 48px)`,
              }}
              aria-hidden
            />

            <Step n="01" eyebrow="Step one" title="Choose test type" complete active>
              <TestTypeSegmented value={kind} onChange={handleKindChange} />
              <p className="mt-3 text-[12px] text-muted-foreground">
                {needsAudio
                  ? "Listening tests require four section audio files alongside the JSON."
                  : "This test type only requires a JSON test file."}
              </p>
            </Step>

            <Step n="02" eyebrow="Step two" title="Attach files" complete={step2Complete} active>
              <DropZone
                label="Test JSON"
                accept=".json"
                hint="Required"
                file={jsonFile}
                onFile={(f) => { setJsonFile(f); resetOutcome(); }}
                icon={FileJson}
              />

              <div
                className="grid overflow-hidden transition-[grid-template-rows,margin] duration-500 ease-[cubic-bezier(0.32,0.72,0,1)]"
                style={{ gridTemplateRows: needsAudio ? "1fr" : "0fr", marginTop: needsAudio ? 20 : 0 }}
              >
                <div className="min-h-0">
                  <div className="mb-3 flex items-center gap-2">
                    <div className="h-px flex-1 bg-border" />
                    <span className="font-mono text-[10px] uppercase tracking-[0.14em] text-muted-foreground">
                      Section audio · 4 files
                    </span>
                    <div className="h-px flex-1 bg-border" />
                  </div>
                  <div className="grid grid-cols-2 gap-3">
                    {SECTION_SLOTS.map((n, i) => (
                      <div
                        key={n}
                        className="transition-all duration-500"
                        style={{
                          opacity: needsAudio ? 1 : 0,
                          transform: needsAudio ? "translateY(0)" : "translateY(8px)",
                          transitionDelay: needsAudio ? `${100 + i * 60}ms` : "0ms",
                        }}
                      >
                        <DropZone
                          label={`Section ${n}`}
                          accept=".mp3,.wav,.m4a,.ogg"
                          hint="Audio"
                          file={audioFiles[n]}
                          onFile={(f) => {
                            setAudioFiles((prev) => ({ ...prev, [n]: f }));
                            resetOutcome();
                          }}
                          compact
                          icon={Music4}
                        />
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </Step>

            <Step
              n="03"
              eyebrow="Step three"
              title="Validate & import"
              complete={step3Complete && !isImporting}
              active={step2Complete}
            >
              <div className="flex flex-wrap items-center gap-3">
                <button
                  type="button"
                  disabled={!canValidate}
                  onClick={handleValidate}
                  className={cn(
                    "inline-flex items-center gap-2 rounded-lg px-4 py-2.5 text-[13px] font-medium transition-all",
                    canValidate
                      ? "bg-card text-foreground ring-1 ring-border hover:bg-accent/50 hover:ring-border active:scale-[0.98]"
                      : preview
                      ? "bg-emerald-50 text-emerald-700 ring-1 ring-emerald-200 dark:bg-emerald-900/20 dark:text-emerald-400 dark:ring-emerald-800"
                      : "cursor-not-allowed bg-muted text-muted-foreground ring-1 ring-border"
                  )}
                >
                  {isValidating ? (
                    <Loader2 size={15} className="animate-spin" />
                  ) : preview ? (
                    <ShieldCheck size={15} />
                  ) : (
                    <Check size={15} />
                  )}
                  {isValidating ? "Validating…" : preview ? "Validated" : "Validate"}
                </button>

                <button
                  type="button"
                  disabled={!canImport}
                  onClick={handleImportClick}
                  className={cn(
                    "inline-flex items-center gap-2 rounded-lg px-4 py-2.5 text-[13px] font-medium transition-all",
                    canImport
                      ? "bg-violet-600 text-white shadow-[0_4px_14px_-4px_rgba(124,58,237,0.6)] hover:bg-violet-700 active:scale-[0.98]"
                      : "cursor-not-allowed bg-violet-200/60 text-white/80 dark:bg-violet-900/30 dark:text-violet-300/50"
                  )}
                >
                  {isImporting ? (
                    <>
                      <span className="h-3.5 w-3.5 animate-spin rounded-full border-2 border-white/40 border-t-white" />
                      Importing…
                    </>
                  ) : (
                    <>
                      <ArrowUpToLine size={15} /> Import
                    </>
                  )}
                </button>

                <div className="ml-auto text-[12px] text-muted-foreground">
                  {!filesReady && "Attach required files to continue"}
                  {filesReady && !preview && !isValidating && "Ready to validate"}
                  {preview && !isImporting && "Passed schema checks — ready to import"}
                  {isImporting && "Uploading to content library…"}
                </div>
              </div>

              {preview && (
                <div className="mt-4 rounded-xl border border-emerald-500/30 bg-emerald-500/5 p-4 dark:border-emerald-800/40 dark:bg-emerald-900/10">
                  <div className="mb-2 flex items-center gap-2 text-[13px] font-semibold text-foreground">
                    <Check size={14} className="text-emerald-600 dark:text-emerald-400" />
                    {preview.title}
                    <Badge variant="secondary" className="capitalize text-[11px]">
                      {preview.status}
                    </Badge>
                  </div>
                  <div className="space-y-0.5 text-[12px] text-muted-foreground">
                    <p>
                      {preview.kind === "writing" ? "Tasks" : preview.kind === "listening" ? "Sections" : "Passages"}:{" "}
                      {preview.passage_or_section_or_task_count}
                    </p>
                    {preview.kind !== "writing" && (
                      <>
                        <p>Question groups: {preview.group_count}</p>
                        <p>Questions: {preview.question_count}</p>
                      </>
                    )}
                    {preview.duplicate_of && (
                      <p className="text-amber-600 dark:text-amber-400">
                        A test with this title already exists (id {preview.duplicate_of}).
                      </p>
                    )}
                  </div>
                </div>
              )}

              {error && (
                <div className="mt-4 rounded-xl border border-destructive/30 bg-destructive/5 p-4">
                  <div className="mb-2 flex items-center justify-between">
                    <div className="flex items-center gap-2 text-[13px] font-semibold text-destructive">
                      <AlertCircle size={14} />
                      Import failed
                    </div>
                    <button
                      type="button"
                      onClick={handleCopyError}
                      className="flex items-center gap-1.5 rounded-md px-2 py-1 text-[11px] text-muted-foreground hover:bg-card hover:text-foreground transition-colors"
                    >
                      <Copy size={12} /> Copy error
                    </button>
                  </div>
                  <pre className="text-[12px] whitespace-pre-wrap text-destructive/90">{error}</pre>
                </div>
              )}
            </Step>
          </div>

          <div className="mt-10 flex items-center justify-between border-t border-border pt-4 font-mono text-[10px] uppercase tracking-wider text-muted-foreground">
            <span>IELTS Mastery Hub · Admin</span>
            <span>Draft saved locally</span>
          </div>
        </div>
      </div>

      <AlertDialog open={confirmDuplicate} onOpenChange={setConfirmDuplicate}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>A test with this title already exists</AlertDialogTitle>
            <AlertDialogDescription>
              A test titled "{preview?.title}" already exists (id {preview?.duplicate_of}). Import as a new copy?
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction
              onClick={() => {
                setConfirmDuplicate(false);
                doImport();
              }}
            >
              Import as new copy
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </AdminLayout>
  );
};

export default ImportDataset;
