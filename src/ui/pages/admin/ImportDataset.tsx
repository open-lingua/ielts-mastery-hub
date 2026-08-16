import { motion } from "framer-motion";
import { AlertCircle, Check, Copy, FileJson, Loader2, Upload } from "lucide-react";
import type React from "react";
import { useState } from "react";
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
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { toast } from "@/hooks/use-toast";
import type { ImportAudioFile, ImportKind, ImportPreview } from "@/lib/tauri";
import { parseImportFile, runImport, validate, validateListeningAudioSlots } from "@/services/importService";

const SECTION_SLOTS = [1, 2, 3, 4] as const;

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

  const handleKindChange = (value: string) => {
    setKind(value as ImportKind);
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

  return (
    <AdminLayout>
      <div className="p-6 md:p-8 max-w-3xl mx-auto space-y-6">
        <motion.div initial={{ opacity: 0, y: -8 }} animate={{ opacity: 1, y: 0 }}>
          <h1 className="text-2xl font-bold text-foreground flex items-center gap-2">
            <FileJson className="h-6 w-6 text-violet-600" />
            Import Dataset
          </h1>
          <p className="text-sm text-muted-foreground mt-1">
            Upload a JSON test file to bulk-import a Reading, Writing, or Listening test.
          </p>
        </motion.div>

        <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.05 }}>
          <Card>
            <CardHeader>
              <CardTitle className="text-base">1. Test Type</CardTitle>
            </CardHeader>
            <CardContent>
              <Select value={kind} onValueChange={handleKindChange}>
                <SelectTrigger className="w-full sm:w-64">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="reading">Reading</SelectItem>
                  <SelectItem value="writing">Writing</SelectItem>
                  <SelectItem value="listening">Listening</SelectItem>
                </SelectContent>
              </Select>
            </CardContent>
          </Card>
        </motion.div>

        <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.1 }}>
          <Card>
            <CardHeader>
              <CardTitle className="text-base">2. Files</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <Label>Test JSON</Label>
                <input
                  type="file"
                  accept=".json"
                  onChange={(e) => {
                    setJsonFile(e.target.files?.[0] || null);
                    resetOutcome();
                  }}
                  className="block w-full text-sm text-muted-foreground file:mr-4 file:rounded-md file:border-0 file:bg-violet-600 file:px-4 file:py-2 file:text-sm file:font-medium file:text-white hover:file:bg-violet-700"
                />
              </div>

              {kind === "listening" && (
                <div className="grid grid-cols-2 gap-3">
                  {SECTION_SLOTS.map((n) => (
                    <div key={n} className="space-y-2">
                      <Label>Section {n} audio</Label>
                      <input
                        type="file"
                        accept=".mp3,.wav,.m4a,.ogg"
                        onChange={(e) => {
                          setAudioFiles((prev) => ({ ...prev, [n]: e.target.files?.[0] || null }));
                          resetOutcome();
                        }}
                        className="block w-full text-xs text-muted-foreground file:mr-2 file:rounded-md file:border-0 file:bg-secondary file:px-3 file:py-1.5 file:text-xs file:font-medium"
                      />
                    </div>
                  ))}
                </div>
              )}
            </CardContent>
          </Card>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 8 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.15 }}
          className="flex gap-3"
        >
          <Button variant="outline" disabled={!jsonFile || isValidating} onClick={handleValidate} className="gap-2">
            {isValidating ? <Loader2 className="h-4 w-4 animate-spin" /> : <Check className="h-4 w-4" />}
            Validate
          </Button>
          <Button disabled={!preview || isImporting} onClick={handleImportClick} className="gap-2 bg-violet-600 hover:bg-violet-700">
            {isImporting ? <Loader2 className="h-4 w-4 animate-spin" /> : <Upload className="h-4 w-4" />}
            Import
          </Button>
        </motion.div>

        {preview && (
          <Card className="border-emerald-500/30 bg-emerald-500/5">
            <CardHeader>
              <CardTitle className="text-base flex items-center gap-2">
                <Check className="h-4 w-4 text-emerald-600" />
                {preview.title}
                <Badge variant="secondary" className="capitalize">
                  {preview.status}
                </Badge>
              </CardTitle>
            </CardHeader>
            <CardContent className="text-sm text-muted-foreground space-y-1">
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
                <p className="text-amber-600">A test with this title already exists (id {preview.duplicate_of}).</p>
              )}
            </CardContent>
          </Card>
        )}

        {error && (
          <Card className="border-destructive/30 bg-destructive/5">
            <CardHeader className="flex flex-row items-center justify-between">
              <CardTitle className="text-base flex items-center gap-2 text-destructive">
                <AlertCircle className="h-4 w-4" />
                Import failed
              </CardTitle>
              <Button variant="ghost" size="sm" onClick={handleCopyError} className="gap-2">
                <Copy className="h-3.5 w-3.5" />
                Copy error
              </Button>
            </CardHeader>
            <CardContent>
              <pre className="text-sm whitespace-pre-wrap text-destructive/90">{error}</pre>
            </CardContent>
          </Card>
        )}
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
