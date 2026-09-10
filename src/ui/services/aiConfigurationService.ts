import {
  activateAiConfiguration as activateAiConfigurationCommand,
  deleteAiConfiguration as deleteAiConfigurationCommand,
  listAiConfigurations,
  saveAiConfiguration as saveAiConfigurationCommand,
} from "@/lib/tauri";

export interface AiConfigurationState {
  configuredMap: Record<string, boolean>;
  activeProviderId: string | null;
}

/**
 * Fetches all AI provider configuration summaries and derives the shape the
 * `AiConfigurations` page renders from: which providers are configured, and
 * which one (if any) is currently active. Never includes credential values —
 * the backend never returns them.
 */
export async function fetchAiConfigurations(): Promise<AiConfigurationState> {
  const summaries = await listAiConfigurations();

  const configuredMap: Record<string, boolean> = {};
  let activeProviderId: string | null = null;

  for (const summary of summaries) {
    configuredMap[summary.providerId] = summary.configured;
    if (summary.isActive) {
      activeProviderId = summary.providerId;
    }
  }

  return { configuredMap, activeProviderId };
}

export async function saveAiConfiguration(
  providerId: string,
  credentials: Record<string, string>
): Promise<{ configured: boolean; isActive: boolean }> {
  const summary = await saveAiConfigurationCommand(providerId, credentials);
  return { configured: summary.configured, isActive: summary.isActive };
}

/**
 * Reactivates an already-configured provider without touching its stored
 * credentials, deactivating whichever provider was previously active.
 */
export async function activateAiConfiguration(providerId: string): Promise<{ isActive: boolean }> {
  const summary = await activateAiConfigurationCommand(providerId);
  return { isActive: summary.isActive };
}

/**
 * Permanently removes a provider's stored credentials and deactivates it. Named
 * `removeAiConfiguration` (rather than `deleteAiConfiguration`) to avoid shadowing the
 * `lib/tauri.ts` wrapper it delegates to.
 */
export async function removeAiConfiguration(providerId: string): Promise<void> {
  await deleteAiConfigurationCommand(providerId);
}
