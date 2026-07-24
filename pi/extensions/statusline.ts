/**
 * Enhanced Status Line Extension
 *
 * Replaces the built-in footer with a richer token stats display:
 * - Session costs with breakdown
 * - Cache efficiency
 * - Reasoning tokens (when available)
 * - Color-coded context pressure
 * - Thinking level indicator
 */

import type { AssistantMessage } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

function fmt(n: number): string {
  if (n < 1000) return `${n}`;
  if (n < 10_000) return `${(n / 1000).toFixed(1)}k`;
  if (n < 1_000_000) return `${Math.round(n / 1000)}k`;
  return `${(n / 1_000_000).toFixed(1)}M`;
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand("statusline", {
    description: "Toggle enhanced status line with richer token info",
    handler: async (_args, ctx) => {
      const toggle = (ctx as any)._statuslineEnabled;
      (ctx as any)._statuslineEnabled = !toggle;

      if (!toggle) {
        enableCustomFooter(pi, ctx);
        ctx.ui.notify("✨ Enhanced status line enabled", "info");
      } else {
        ctx.ui.setFooter(undefined);
        ctx.ui.notify("Default status line restored", "info");
      }
    },
  });

  // Auto-enable on session start
  pi.on("session_start", async (_event, ctx) => {
    (ctx as any)._statuslineEnabled = true;
    enableCustomFooter(pi, ctx);
  });
}

function enableCustomFooter(pi: ExtensionAPI, ctx: any) {
  ctx.ui.setFooter((tui, theme, footerData) => {
    const unsubBranch = footerData.onBranchChange(() => tui.requestRender());

    return {
      dispose: () => {
        unsubBranch();
      },
      invalidate() {},
      render(width: number): string[] {
        const session = (ctx as any).sessionManager;
        if (!session) return [];

        let totalInput = 0;
        let totalOutput = 0;
        let totalCacheRead = 0;
        let totalCacheWrite = 0;
        let totalCost = 0;
        let totalReasoning = 0;
        let latestCacheHitRate: number | undefined;
        let hasReasoning = false;

        for (const entry of session.getEntries()) {
          if (entry.type === "message" && (entry as any).message?.role === "assistant") {
            const m = (entry as any).message as AssistantMessage;
            const u = m.usage;
            totalInput += u.input;
            totalOutput += u.output;
            totalCacheRead += u.cacheRead;
            totalCacheWrite += u.cacheWrite;
            totalCost += u.cost.total;
            if (u.reasoning !== undefined) {
              totalReasoning += u.reasoning;
              hasReasoning = true;
            }
            const promptTokens = u.input + u.cacheRead + u.cacheWrite;
            if (promptTokens > 0) {
              latestCacheHitRate = (u.cacheRead / promptTokens) * 100;
            }
          }
        }

        const model = (ctx as any).model;
        const thinkingLevel = (pi as any).getThinkingLevel?.() ?? "off";
        const supportsReasoning = model?.reasoning === true;

        // Context usage
        let contextPercent = 0;
        let contextWindow = model?.contextWindow ?? 0;
        let contextStr = "?";
        try {
          const usage = ctx.getContextUsage?.();
          if (usage) {
            contextPercent = usage.percent ?? 0;
            contextWindow = usage.contextWindow ?? contextWindow;
            contextStr = usage.percent !== null ? `${usage.percent.toFixed(1)}%` : "?";
          }
        } catch {}

        // === Line 1: Working directory ===
        const cwd = session.getCwd?.() ?? "";
        const home = process.env.HOME || process.env.USERPROFILE || "";
        let pwdDisplay = cwd;
        if (home && cwd.startsWith(home)) {
          pwdDisplay = `~${cwd.slice(home.length)}`;
        }
        const branch = footerData.getGitBranch();
        const sessionName = session.getSessionName?.();
        const parts: string[] = [pwdDisplay];
        if (branch) parts.push(`(${branch})`);
        if (sessionName) parts.push(`• ${sessionName}`);
        const pwdLine = theme.fg("muted", parts.join(" "));

        // === Line 2: Token stats ===
        const stats: string[] = [];

        // Main token flow
        if (totalInput || totalOutput) {
          stats.push(theme.fg("accent", `↑${fmt(totalInput)}`));
          stats.push(theme.fg("text", `↓${fmt(totalOutput)}`));
        }

        // Cache stats with hit rate
        if (totalCacheRead || totalCacheWrite) {
          stats.push(theme.fg("dim", `R${fmt(totalCacheRead)}`));
          stats.push(theme.fg("dim", `W${fmt(totalCacheWrite)}`));
          if (latestCacheHitRate !== undefined) {
            const chColor =
              latestCacheHitRate > 50 ? "success" : latestCacheHitRate > 20 ? "warning" : "dim";
            stats.push(theme.fg(chColor as any, `CH${latestCacheHitRate.toFixed(0)}%`));
          }
        }

        // Reasoning tokens (separate from output)
        if (hasReasoning && totalReasoning > 0) {
          stats.push(theme.fg("warning", `⟐${fmt(totalReasoning)}`));
        }

        // Thinking level indicator
        if (supportsReasoning && thinkingLevel !== "off") {
          const tlColor =
            thinkingLevel === "high" || thinkingLevel === "xhigh" || thinkingLevel === "max"
              ? "thinkingHigh"
              : "thinkingLow";
          stats.push(theme.fg(tlColor as any, `🧠${thinkingLevel}`));
        }

        // Cost
        if (totalCost > 0) {
          stats.push(theme.fg("dim", `$${totalCost.toFixed(4)}`));
        }

        // Context usage with color coding
        const autoIndicator = (ctx as any).autoCompactionEnabled !== false ? "auto" : "";
        const ctxSuffix = contextWindow > 0 ? `/ ${fmt(contextWindow)}` : "";
        const ctxDisplay = `${contextStr}${ctxSuffix}${autoIndicator ? ` (${autoIndicator})` : ""}`;
        const ctxColor =
          contextPercent > 90 ? "error" : contextPercent > 70 ? "warning" : "dim";
        stats.push(theme.fg(ctxColor as any, ctxDisplay));

        // Build the line
        const statsLine = stats.join(" ");

        // Right side: model name
        const modelName = model ? `${model.provider}/${model.id}` : "no-model";
        let rightSideWidth = visibleWidth(modelName);
        const minGap = 2;
        const statsWidth = visibleWidth(statsLine);

        let line: string;
        if (statsWidth + minGap + rightSideWidth <= width) {
          const gap = " ".repeat(width - statsWidth - rightSideWidth);
          line = statsLine + gap + theme.fg("accent", modelName);
        } else if (statsWidth + minGap <= width) {
          // Only show model name if there's room
          const avail = width - statsWidth - minGap;
          if (avail > 0) {
            const truncated = truncateToWidth(modelName, avail, "");
            const gap = " ".repeat(Math.max(0, width - statsWidth - visibleWidth(truncated)));
            line = statsLine + gap + theme.fg("accent", truncated);
          } else {
            line = statsLine;
          }
        } else {
          line = truncateToWidth(statsLine, width, theme.fg("dim", "…"));
        }

        const pwdTruncated = truncateToWidth(pwdLine, width, theme.fg("muted", "…"));

        // Extension statuses (line 3, optional)
        const extStatuses = footerData.getExtensionStatuses();
        const lines = [pwdTruncated, line];

        if (extStatuses.size > 0) {
          const sorted = Array.from(extStatuses.entries())
            .sort(([a], [b]) => a.localeCompare(b))
            .map(([, text]) => text.replace(/[\r\n\t]/g, " ").replace(/ +/g, " ").trim());
          const statusLine = sorted.join(" ");
          lines.push(truncateToWidth(statusLine, width, theme.fg("dim", "…")));
        }

        return lines;
      },
    };
  });
}
