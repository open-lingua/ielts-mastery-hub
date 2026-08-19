# Product Plan: Test Export Feature

## 1. Feature Description

**What it is:** A new "Export" action added to the 3-dot menu on each content item in the Content Library, positioned between **Edit** and **Delete**.

**What it does:** Lets an admin download a single test (Reading, Writing, or Listening) as a `.zip` file. The zip contains the test's `.json` definition plus any associated media (images, audio) used by that test.

**Problem it solves:** Today, content created in IELTS Mastery Hub only exists inside the app. There's no way to:
- Back up individual tests outside the platform
- Share a specific test with another admin or instructor without giving them full system access
- Move a test from one environment (e.g., staging) to another (e.g., production)
- Recover a test if it's accidentally modified or deleted

Since the export format matches what Import Dataset already accepts, this creates a **round-trip workflow**: anything exported can be re-imported as-is, with no manual editing required.

---

## 2. Main Use Cases

| Use Case | Who | When | Why |
|---|---|---|---|
| **Backup before editing** | Admin/content author | Before making risky changes to a published test | Safety net in case edits go wrong |
| **Sharing between admins** | Content team | Collaborating on test creation across teams or organizations | Hand off a ready-made test without re-typing content |
| **Environment migration** | Admin/technical staff | Moving content from a test/staging portal to the live production portal | Avoid manual recreation of tests |
| **Archiving** | Admin | Retiring a test from active use but wanting to keep a record | Keep historical content outside the live library |
| **Troubleshooting/support** | Admin, with support from vendor/dev team | A test behaves unexpectedly | Provide the exact test data for investigation |

---

## 3. User Journey

1. Admin navigates to **Content Library**.
2. Admin locates the test they want to export and clicks the **3-dot menu (`...`)** on that row.
3. A dropdown appears with three options: **Edit**, **Export**, **Delete**.
4. Admin clicks **Export**.
5. The system:
   - Gathers the test's JSON definition.
   - Collects any linked media files (images/audio) referenced by that test.
   - Packages everything into a single `.zip` file.
6. The browser/OS triggers a standard **file download** (or a native save dialog, depending on desktop app conventions), named descriptively (e.g., `ielts-writing-carbon-capture-process_export.zip`).
7. Admin receives a confirmation (e.g., a toast/notification: "Export complete" or "X.zip downloaded").
8. The `.zip` is now available locally, ready to be re-imported via **Import Dataset** at any time, in any environment.

**No extra steps required** — it should feel as simple and immediate as Edit or Delete.

---

## 4. Edge Cases & Considerations

- **No multimedia attached:** Export still works — the `.zip` simply contains only the `.json` file. No errors, no empty folders left implied as "missing."
- **Missing/broken media reference:** If the JSON references a media file that no longer exists in storage, the export should still complete, but the admin should be warned (e.g., "Exported with 1 missing resource: audio-track-2.mp3") rather than silently failing or blocking the whole export.
- **Large files (e.g., long audio tracks):** Exporting should show a progress indicator if the zip creation takes more than a second or two, so the admin knows it's working and not frozen.
- **Draft vs. Published tests:** Both should be exportable — there's no reason to restrict this by status. The exported JSON should include whatever status metadata it currently has, so re-importing preserves it (or the import flow's existing rules for status apply).
- **Naming collisions:** If the admin exports the same test twice, the file name should avoid overwriting silently — either append a timestamp/number or let the OS handle "file (1).zip" naming.
- **Permissions:** Only users with access to the Content Library (i.e., existing admin permissions) can export — no new permission tier needed initially, but this should be confirmed with the security/roles model.
- **Very long titles:** Test titles can be long; the generated filename should be safely truncated/sanitized (no special characters that break file systems).

---

## 5. Acceptance Criteria

- [ ] A working **Export** option appears in the 3-dot menu, positioned between Edit and Delete, for every content type (Reading, Writing, Listening).
- [ ] Clicking Export produces a downloadable `.zip` file without requiring additional user input.
- [ ] The `.zip` always contains a valid `.json` file matching the Import Dataset schema.
- [ ] If the test has media resources, they are included in the `.zip` and correctly referenced/linked within the JSON.
- [ ] If the test has no media resources, the `.zip` contains only the JSON with no errors.
- [ ] A `.zip` exported from the app can be re-imported via Import Dataset **without any manual edits**, and results in an identical test being created/restored.
- [ ] Draft and Published tests can both be exported successfully.
- [ ] The admin receives clear feedback on success (confirmation) and on partial issues (e.g., missing media file warnings).
- [ ] Exporting a large test (many questions/large audio) does not crash or freeze the app; a loading/progress state is shown.
- [ ] Filenames are safe, descriptive, and don't overwrite existing files unexpectedly.

---

## 6. Potential Future Extensions

- **Bulk export:** Select multiple tests (checkboxes in Content Library) and export them all as one combined `.zip` or as separate zips in one action.
- **Export by category/filter:** Export all tests matching a filter — e.g., "export all Writing tests" or "export everything in Draft status."
- **Export entire library:** A full backup/export of the whole Content Library in one click, for disaster recovery or full environment migration.
- **Scheduled/automatic backups:** Periodic automatic export of the library to a specified location, without manual action.
- **Cloud sharing integration:** Instead of just downloading locally, offer direct sharing via a link or integration with cloud storage (Drive, Dropbox) for easier collaboration between admins.
- **Import/export history log:** Track who exported what and when, useful for auditing content movement across environments.
- **Versioned exports:** Include version metadata so re-imports can detect if a test being imported is an older or newer version of an existing one, prompting the admin to choose "overwrite," "keep both," or "cancel."
