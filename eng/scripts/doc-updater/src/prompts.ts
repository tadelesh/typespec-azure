/**
 * Prompt loading and building for each pipeline phase.
 */

import { readFile } from "node:fs/promises";
import { resolve } from "node:path";
import type { DocUpdateConfig } from "./config.js";
import { getKnowledgeRelativePath, readKnowledge, type HumanFeedback } from "./knowledge.js";

/** Directory containing per-package prompt files, relative to this source file. */
const PROMPTS_DIR = resolve(import.meta.dirname ?? ".", "../prompts");

/** Maximum number of commits to include in a single incremental knowledge update session. */
export const COMMITS_PER_BATCH = 10;

/** Load a prompt file for a given config and phase. */
export async function loadPromptFile(configName: string, promptName: string): Promise<string> {
  const filePath = resolve(PROMPTS_DIR, configName, `${promptName}.md`);
  try {
    return await readFile(filePath, "utf-8");
  } catch {
    throw new Error(
      `Prompt file not found: prompts/${configName}/${promptName}.md. ` +
        `Create this file to define the ${promptName} phase for the "${configName}" config.`,
    );
  }
}

// ---------------------------------------------------------------------------
// Knowledge build prompt (system-driven)
// ---------------------------------------------------------------------------

/**
 * Build the system prompt for a knowledge build.
 *
 * When changedCommits are provided (incremental mode), the agent only
 * updates knowledge sections affected by those commits.
 * Otherwise it performs a full analysis from scratch.
 */
export function buildKnowledgePrompt(
  config: DocUpdateConfig,
  docUpdatePrompt: string,
  changedCommits?: string[],
): string {
  const paths = config.sourceCodePaths.map((p) => `- \`${p}\``).join("\n");
  const knowledgePath = getKnowledgeRelativePath(config.name);

  let prompt = `You are building a **knowledge base** for **${config.displayName}**.

${config.description}

## Source Code Locations

${paths}

## Context

A separate documentation update agent will use this knowledge base as its reference when updating documentation. That agent will read what you write here first to reduce the efforts of reading all source code.

Below are the instructions the doc-update agent will follow. Read them carefully to understand what information it will need:

<doc-update-instructions>
${docUpdatePrompt}
</doc-update-instructions>

## Instructions
`;

  if (changedCommits && changedCommits.length > 0) {
    const commits = changedCommits.map((h) => `- \`${h}\``).join("\n");
    prompt += `\nThis is an incremental update. The following commits (oldest first) need to be reviewed:\n\n${commits}\n\n`;
    prompt += `**Repository:** \`Azure/typespec-azure\`\n\n`;
    prompt += `Use GitHub MCP tools to inspect each commit. Update the knowledge base to reflect any changes that affect what the doc-update agent needs to know.\n\n`;
    prompt += `Skip commits that are irrelevant (pure refactors, CI, formatting, dependency bumps).\n\n`;
    prompt += `**Important:** Preserve sections not affected by these commits. Only update what the commits actually change.\n`;
  } else {
    prompt += `\nAnalyze the source code and existing documentation. Then write a knowledge base that contains everything the doc-update agent would need to carry out those instructions effectively.\n\n`;
    prompt += `You decide the structure and what to include. Think about what the doc-update agent will need to look up, cross-reference, or verify — and make sure that information is in the knowledge base.\n`;
  }

  prompt += `\n## Output\n\nWrite the knowledge base to: \`${knowledgePath}\`\n\n`;
  prompt += `After writing, run \`pnpm format:dir ${knowledgePath}\` to format the file.\n`;

  return prompt;
}

// ---------------------------------------------------------------------------
// Feedback prompt
// ---------------------------------------------------------------------------

/**
 * Build the system prompt for a feedback-driven knowledge update.
 *
 * When humans modify a doc-updater PR before merging, their changes
 * represent corrections or improvements the knowledge base should learn from.
 */
export function buildFeedbackPrompt(
  config: DocUpdateConfig,
  feedback: HumanFeedback,
  existingKnowledge: string,
  docUpdatePrompt: string,
): string {
  const knowledgePath = getKnowledgeRelativePath(config.name);

  let feedbackSection = `## Human Feedback from PR #${feedback.prNumber}\n\n`;

  if (feedback.commits.length > 0) {
    feedbackSection += `### Commits added by reviewers\n\n`;
    for (const c of feedback.commits) {
      feedbackSection += `- \`${c.sha}\` — ${c.message}\n`;
    }
    feedbackSection += `\nUse GitHub MCP tools to inspect these commits and understand what the reviewers changed and why.\n\n`;
  }

  if (feedback.reviewComments.length > 0) {
    feedbackSection += `### Review comments\n\n`;
    for (const comment of feedback.reviewComments) {
      feedbackSection += `> ${comment}\n\n`;
    }
  }

  return `You are updating the knowledge base for **${config.displayName}** based on human feedback.

${config.description}

A previous automated doc-update PR was reviewed and modified by humans before being merged. Their changes indicate corrections, preferences, or additional context that the knowledge base should capture so future updates don't repeat the same mistakes.

The doc-update agent that produced the PR followed these instructions. Use them to understand the agent's intent and judge what kind of correction each human change represents:

<doc-update-instructions>
${docUpdatePrompt}
</doc-update-instructions>

${feedbackSection}

## Instructions

Review the human changes and comments. Update the knowledge base to reflect what you learn:
- If humans corrected a factual error, fix the corresponding knowledge
- If humans added context or clarification, incorporate that information
- If humans changed formatting or conventions, update the conventions section
- If humans rejected a change, note what should NOT be done

## Output

Write the updated knowledge base to: \`${knowledgePath}\`

After writing, run \`pnpm format:dir ${knowledgePath}\` to format the file.

Preserve sections not affected by the feedback. Only update what the human corrections inform.

## Current Knowledge Base

${existingKnowledge}`;
}

// ---------------------------------------------------------------------------
// Doc-update prompt
// ---------------------------------------------------------------------------

/**
 * Build the prompt for the doc-update phase.
 *
 * Injects the knowledge base content and runtime context.
 * When changedCommits are provided (incremental mode), the agent focuses
 * only on documentation affected by those changes.
 */
export async function buildDocUpdatePrompt(
  config: DocUpdateConfig,
  changedCommits?: string[],
): Promise<string> {
  const knowledge = await readKnowledge(config.name);
  if (!knowledge) {
    throw new Error(
      `No knowledge base found for "${config.name}". ` +
        `Run with --full-rebuild first to build it.`,
    );
  }

  let prompt = await loadPromptFile(config.name, "doc-update");
  const date = new Date().toISOString().split("T")[0];

  prompt += `\n\n## Runtime Context\n\n`;
  prompt += `**Date:** ${date}\n`;

  if (changedCommits && changedCommits.length > 0) {
    const commits = changedCommits.map((h) => `- \`${h}\``).join("\n");
    prompt += `\n## Incremental Update Mode\n\n`;
    prompt += `This is an incremental run. Only the following commits have changed the source code since the last update:\n\n`;
    prompt += `${commits}\n\n`;
    prompt += `**Repository:** \`Azure/typespec-azure\`\n\n`;
    prompt += `Use GitHub MCP tools to inspect these commits and determine which documentation areas are affected. `;
    prompt += `Only update documentation that is impacted by these changes — do not re-review unaffected areas.\n`;
  }

  prompt += `\n## Package Knowledge Base\n\n`;
  prompt += knowledge;

  return prompt;
}
