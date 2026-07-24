import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

type EffortLevel = "off" | "minimal" | "low" | "medium" | "high" | "xhigh" | "max";

const LEVEL_META: Record<EffortLevel, { label: string; description: string }> = {
  off:     { label: "off",      description: "No extended thinking — fastest responses" },
  minimal: { label: "minimal",  description: "Minimal reasoning — lightweight chain-of-thought" },
  low:     { label: "low",      description: "Low effort — balanced speed and reasoning" },
  medium:  { label: "medium",   description: "Medium effort — deeper reasoning" },
  high:    { label: "high",     description: "High effort — thorough analysis" },
  xhigh:   { label: "xhigh",    description: "Extra high — very thorough reasoning" },
  max:     { label: "max",      description: "Maximum effort — full extended thinking" },
};

const LEVEL_ORDER: EffortLevel[] = ["off", "minimal", "low", "medium", "high", "xhigh", "max"];

export default function (pi: ExtensionAPI) {
  pi.registerCommand("effort", {
    description: "Show and select available thinking levels for the current model",
    handler: async (_args, ctx) => {
      const model = ctx.model;
      if (!model) {
        ctx.ui.notify("No model selected", "error");
        return;
      }

      const currentLevel = pi.getThinkingLevel() as EffortLevel;
      const supportsReasoning = model.reasoning === true;
      const levelMap = model.thinkingLevelMap as
        | Partial<Record<string, string | null>>
        | undefined;

      // Determine which levels are available
      const availableLevels: EffortLevel[] = [];

      if (!supportsReasoning) {
        // Non-reasoning model: only "off" is available
        availableLevels.push("off");
      } else if (levelMap) {
        // Model has explicit level map: null or missing = unsupported
        for (const level of LEVEL_ORDER) {
          const mapped = levelMap[level];
          if (mapped !== null && mapped !== undefined) {
            availableLevels.push(level);
          }
        }
      } else {
        // Reasoning model without level map: all levels available
        availableLevels.push(...LEVEL_ORDER);
      }

      // Build and show the UI
      const modelName = `${model.provider}/${model.id}`;
      const items = availableLevels.map((level) => {
        const info = LEVEL_META[level];
        const isCurrent = level === currentLevel ? " ● CURRENT" : "";
        return `${level}${isCurrent} — ${info.description}`;
      });

      const selected = await ctx.ui.select(
        `🎯 Effort levels for ${modelName}\nCurrent: ${currentLevel}`,
        items,
      );

      if (selected) {
        const chosenLevel = selected.split(" ")[0] as EffortLevel;
        if (chosenLevel !== currentLevel) {
          pi.setThinkingLevel(chosenLevel as any);
          ctx.ui.notify(`🎯 Effort set to: ${chosenLevel}`, "info");
        } else {
          ctx.ui.notify(`Already at ${chosenLevel} effort`, "info");
        }
      }
    },
  });
}
