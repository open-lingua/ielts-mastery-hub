#!/usr/bin/env node
// Generates src/core/tauri.windows.msi.conf.json from package.json's canonical
// version. Tauri's `msi` bundle target (WiX) requires an all-numeric 4-part
// version (each field <= 65535), so a semver pre-release like `1.0.1-rc.2`
// must be mapped to a WiX-safe `1.0.1.2`. This file is generated — never
// hand-edit src/core/tauri.windows.msi.conf.json; run this script (or let the
// release-please automation run it) instead. See RELEASES.md's version
// automation section.

import { readFileSync, writeFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import path from "node:path";

const repoRoot = path.resolve(
  path.dirname(fileURLToPath(import.meta.url)),
  "..",
);

const MSI_CONFIG_PATH = "src/core/tauri.windows.msi.conf.json";
const MAX_FIELD = 65535;

/**
 * Derives a WiX-safe 4-part numeric version from a semver string.
 *
 * - `X.Y.Z` (no pre-release) -> `X.Y.Z.0`
 * - `X.Y.Z-rc.N` -> `X.Y.Z.N`
 * - Any other pre-release form (non-`rc`, non-numeric identifier) throws.
 * - Any of the 4 resulting fields being non-integer or > 65535 throws.
 *
 * @param {string} semver
 * @returns {string}
 */
export function deriveWixVersion(semver) {
  const match = /^(\d+)\.(\d+)\.(\d+)(?:-(.+))?$/.exec(semver);
  if (!match) {
    throw new Error(
      `Cannot derive a WiX version: "${semver}" is not a valid semver string.`,
    );
  }

  const [, major, minor, patch, prerelease] = match;
  let build = "0";

  if (prerelease !== undefined) {
    const prereleaseMatch = /^rc\.(\d+)$/.exec(prerelease);
    if (!prereleaseMatch) {
      throw new Error(
        `Cannot derive a WiX version from "${semver}": the pre-release identifier ` +
          `"${prerelease}" must be of the form "rc.<number>" (WiX/MSI versions must be ` +
          "all-numeric).",
      );
    }
    build = prereleaseMatch[1];
  }

  const fields = [major, minor, patch, build];
  for (const field of fields) {
    const value = Number(field);
    if (!Number.isInteger(value) || value < 0 || value > MAX_FIELD) {
      throw new Error(
        `Cannot derive a WiX version from "${semver}": field "${field}" must be an ` +
          `integer between 0 and ${MAX_FIELD} (WiX/MSI version field limit).`,
      );
    }
  }

  return fields.join(".");
}

/**
 * Reads the canonical version from package.json.
 * @returns {string}
 */
export function readCanonicalVersion() {
  const filePath = path.join(repoRoot, "package.json");
  const contents = JSON.parse(readFileSync(filePath, "utf8"));
  if (typeof contents.version !== "string") {
    throw new Error('No "version" string found in package.json');
  }
  return contents.version;
}

/**
 * Builds the full overlay config object for the given WiX version.
 * @param {string} wixVersion
 */
export function buildMsiConfig(wixVersion) {
  return {
    bundle: {
      windows: {
        wix: {
          version: wixVersion,
        },
      },
    },
  };
}

function serializeConfig(config) {
  return `${JSON.stringify(config, null, 2)}\n`;
}

function main() {
  const checkOnly = process.argv.includes("--check");
  const canonicalVersion = readCanonicalVersion();
  const wixVersion = deriveWixVersion(canonicalVersion);
  const expectedContents = serializeConfig(buildMsiConfig(wixVersion));
  const filePath = path.join(repoRoot, MSI_CONFIG_PATH);

  if (checkOnly) {
    let actualContents;
    try {
      actualContents = readFileSync(filePath, "utf8");
    } catch {
      console.error(`${MSI_CONFIG_PATH} does not exist.`);
      console.error(`Run \`node scripts/sync-msi-version.mjs\` to generate it.`);
      process.exit(1);
    }

    if (actualContents !== expectedContents) {
      console.error(
        `${MSI_CONFIG_PATH} is out of sync with package.json's version (${canonicalVersion}).\n`,
      );
      console.error(`--- expected (derived from ${canonicalVersion}) ---`);
      console.error(expectedContents);
      console.error(`--- actual (${MSI_CONFIG_PATH}) ---`);
      console.error(actualContents);
      console.error(
        "Run `node scripts/sync-msi-version.mjs` to regenerate it. Do not hand-edit this file.",
      );
      process.exit(1);
    }

    console.log(
      `OK: ${MSI_CONFIG_PATH} matches derived WiX version ${wixVersion} for ${canonicalVersion}`,
    );
    return;
  }

  writeFileSync(filePath, expectedContents);
  console.log(
    `Wrote ${MSI_CONFIG_PATH} with WiX version ${wixVersion} (derived from ${canonicalVersion})`,
  );
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  main();
}
