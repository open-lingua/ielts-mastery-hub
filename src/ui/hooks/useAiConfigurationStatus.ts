import { useEffect, useState } from "react";
import { fetchAiConfigurations } from "@/services/aiConfigurationService";

export interface UseAiConfigurationStatusReturn {
  /** True while the initial fetch is in flight. */
  isLoading: boolean;
  /** The provider id currently active, or null if none is active. */
  activeProviderId: string | null;
  /** True once we know whether an active AI provider is configured. */
  hasActiveConfig: boolean;
}

/**
 * Reports whether the user currently has an active AI provider configured
 * (see `services/aiConfigurationService.ts`). Used to gate features — like
 * starting a Writing test — that depend on AI grading being available.
 *
 * While loading, `hasActiveConfig` is `false` to keep gated UI locked until
 * the check resolves, avoiding a flash of an unlocked state.
 */
export function useAiConfigurationStatus(): UseAiConfigurationStatusReturn {
  const [isLoading, setIsLoading] = useState(true);
  const [activeProviderId, setActiveProviderId] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;

    const load = async () => {
      try {
        const { activeProviderId: fetchedActiveProviderId } = await fetchAiConfigurations();
        if (!cancelled) {
          setActiveProviderId(fetchedActiveProviderId);
        }
      } catch {
        if (!cancelled) {
          setActiveProviderId(null);
        }
      } finally {
        if (!cancelled) {
          setIsLoading(false);
        }
      }
    };

    void load();

    return () => {
      cancelled = true;
    };
  }, []);

  return {
    isLoading,
    activeProviderId,
    hasActiveConfig: !isLoading && activeProviderId !== null,
  };
}
