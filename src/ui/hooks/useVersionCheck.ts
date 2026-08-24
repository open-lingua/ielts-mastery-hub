export interface VersionCheckResult {
  /** Current app version, read from package.json at build time. */
  currentVersion: string;
  /** Whether a newer LTS version is available. */
  hasUpdate: boolean;
  /** The latest available LTS version, if any. */
  latestVersion: string | null;
  /** Call to trigger the update flow. */
  onUpdate: () => void;
}

/**
 * Reports the current app version and whether a newer LTS build is available.
 *
 * TODO: replace the hardcoded `hasUpdate`/`latestVersion` values below with a
 * real check once the update API exists, e.g.:
 *
 * ```ts
 * const [hasUpdate, setHasUpdate] = useState(false);
 * const [latestVersion, setLatestVersion] = useState<string | null>(null);
 *
 * useEffect(() => {
 *   let cancelled = false;
 *   (async () => {
 *     const res = await fetch("https://my-api.com/lts-version");
 *     const data = await res.json();
 *     if (!cancelled) {
 *       setHasUpdate(data.hasUpdate);
 *       setLatestVersion(data.latestVersion);
 *     }
 *   })();
 *   return () => {
 *     cancelled = true;
 *   };
 * }, []);
 * ```
 */
export function useVersionCheck(): VersionCheckResult {
  const currentVersion = __APP_VERSION__;

  // Hardcoded placeholders until the real LTS-check API is wired up.
  const hasUpdate = true;
  const latestVersion = "1.1.0";

  const onUpdate = () => {
    console.log(`Update available: v${latestVersion}`);
  };

  return { currentVersion, hasUpdate, latestVersion, onUpdate };
}
