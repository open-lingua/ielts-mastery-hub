#!/usr/bin/env node
// Fails with a non-zero exit code if the version strings tracked across
// package.json, src/core/Cargo.toml and src/core/tauri.conf.json ever drift
// apart, or if the generated src/core/tauri.windows.msi.conf.json WiX version
// no longer matches the canonical version. This is the CI safety net
// described in RELEASES.md's version automation section — it guards against
// manual edits reintroducing drift even when release-please is the source of
// truth.

import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import path from "node:path";
import { deriveWixVersion } from "./sync-msi-version.mjs";

const repoRoot = path.resolve(
  path.dirname(fileURLToPath(import.meta.url)),
  "..",
);

function readPackageJsonVersion(relativePath) {
  const filePath = path.join(repoRoot, relativePath);
  const contents = JSON.parse(readFileSync(filePath, "utf8"));
  if (typeof contents.version !== "string") {
    throw new Error(`No "version" string found in ${relativePath}`);
  }
  return contents.version;
}

function readCargoTomlVersion(relativePath) {
  const filePath = path.join(repoRoot, relativePath);
  const contents = readFileSync(filePath, "utf8");
  const match = contents.match(/^\s*version\s*=\s*"([^"]+)"/m);
  if (!match) {
    throw new Error(`No [package].version found in ${relativePath}`);
  }
  return match[1];
}

const sources = [
  { file: "package.json", version: readPackageJsonVersion("package.json") },
  {
    file: "src/core/Cargo.toml",
    version: readCargoTomlVersion("src/core/Cargo.toml"),
  },
  {
    file: "src/core/tauri.conf.json",
    version: readPackageJsonVersion("src/core/tauri.conf.json"),
  },
];

const versions = new Set(sources.map((s) => s.version));

if (versions.size > 1) {
  console.error("Version mismatch detected across version-bearing files:\n");
  for (const { file, version } of sources) {
    console.error(`  ${file.padEnd(28)} -> ${version}`);
  }
  console.error(
    "\nAll of the above must carry the exact same version string. " +
      "Run the release-please automation instead of editing these files by hand.",
  );
  process.exit(1);
}

const canonicalVersion = [...versions][0];

// The MSI overlay legitimately differs from the canonical version (WiX
// requires an all-numeric 4-part version), so it can't be compared with the
// exact-match Set above — instead assert it equals the derived WiX version.
const msiConfigFile = "src/core/tauri.windows.msi.conf.json";
let msiWixVersion;
try {
  const msiConfig = JSON.parse(
    readFileSync(path.join(repoRoot, msiConfigFile), "utf8"),
  );
  msiWixVersion = msiConfig?.bundle?.windows?.wix?.version;
  if (typeof msiWixVersion !== "string") {
    throw new Error(
      `No bundle.windows.wix.version string found in ${msiConfigFile}`,
    );
  }
} catch (error) {
  console.error(`Failed to read ${msiConfigFile}: ${error.message}`);
  console.error(
    "Run `node scripts/sync-msi-version.mjs` to generate it instead of editing it by hand.",
  );
  process.exit(1);
}

const expectedWixVersion = deriveWixVersion(canonicalVersion);

if (msiWixVersion !== expectedWixVersion) {
  console.error("MSI overlay WiX version is out of sync:\n");
  console.error(`  ${"package.json version".padEnd(28)} -> ${canonicalVersion}`);
  console.error(`  ${"expected WiX version".padEnd(28)} -> ${expectedWixVersion}`);
  console.error(`  ${msiConfigFile.padEnd(28)} -> ${msiWixVersion}`);
  console.error(
    "\nRun `node scripts/sync-msi-version.mjs` to regenerate it instead of editing it by hand.",
  );
  process.exit(1);
}

console.log(
  `OK: all tracked files agree on version ${canonicalVersion} ` +
    `(MSI overlay WiX version: ${msiWixVersion})`,
);
