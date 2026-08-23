#!/usr/bin/env node
// Fails with a non-zero exit code if the version strings tracked across
// package.json, src/core/Cargo.toml and src/core/tauri.conf.json ever drift
// apart. This is the CI safety net described in RELEASES.md's version
// automation section — it guards against manual edits reintroducing drift
// even when release-please is the source of truth.

import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import path from "node:path";

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

console.log(`OK: all tracked files agree on version ${[...versions][0]}`);
