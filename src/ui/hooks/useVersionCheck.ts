import { useEffect, useState } from "react";
import semver from "semver";
import { checkForUpdate, openReleaseUrl } from "@/lib/tauri";

export interface VersionCheckResult {
  /** Current app version, read from package.json at build time. */
  currentVersion: string;
  /** Whether a newer release is available. Defaults to `false` until a successful check confirms
   * a strictly newer version — never `true` while loading or when the check failed. */
  hasUpdate: boolean;
  /** The latest available version, if any. `null` while loading, unavailable, or up to date. */
  latestVersion: string | null;
  /** Opens the GitHub release page in the default browser. Only meant to be wired to explicit
   * user interaction (e.g. a button's `onClick`) — never called automatically. */
  onUpdate: () => void;
}

/**
 * Reports the current app version and whether a newer release is available, by comparing
 * `__APP_VERSION__` against the latest GitHub release tag (fetched via the `check_for_update`
 * Tauri command). Comparison-only: nothing is downloaded or installed automatically — the caller
 * decides whether/when to invoke `onUpdate`, which just opens the release page in the browser.
 */
export function useVersionCheck(): VersionCheckResult {
  const currentVersion = __APP_VERSION__;

  const [hasUpdate, setHasUpdate] = useState(false);
  const [latestVersion, setLatestVersion] = useState<string | null>(null);
  const [releaseUrl, setReleaseUrl] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;

    (async () => {
      try {
        const result = await checkForUpdate();
        if (cancelled) return;

        const isNewer =
          semver.valid(result.latestVersion) &&
          semver.valid(currentVersion) &&
          semver.gt(result.latestVersion, currentVersion);

        if (isNewer) {
          setHasUpdate(true);
          setLatestVersion(result.latestVersion);
          setReleaseUrl(result.releaseUrl);
        } else {
          setHasUpdate(false);
          setLatestVersion(null);
          setReleaseUrl(null);
        }
      } catch (error) {
        // Network errors, backend AppError, rate limiting, etc. are all non-fatal here — silently
        // stay "up to date" rather than surfacing an error UI.
        if (!cancelled) {
          console.debug("useVersionCheck: update check failed", error);
          setHasUpdate(false);
          setLatestVersion(null);
          setReleaseUrl(null);
        }
      }
    })();

    return () => {
      cancelled = true;
    };
  }, []);

  const onUpdate = () => {
    if (!releaseUrl) return;
    openReleaseUrl(releaseUrl).catch((error) => {
      console.debug("useVersionCheck: failed to open release URL", error);
    });
  };

  return { currentVersion, hasUpdate, latestVersion, onUpdate };
}
