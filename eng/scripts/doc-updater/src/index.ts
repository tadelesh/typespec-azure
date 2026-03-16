/**
 * Doc-updater orchestrator using GitHub Copilot SDK.
 *
 * Pipeline (always runs all steps in order):
 *   1. Feedback: Learn from human corrections on the last PR
 *   2. Knowledge Build: Analyze source code → build/update knowledge base
 *   3. Doc Update: Use knowledge base → update documentation
 *
 * Usage:
 *   tsx src/index.ts --config <name> [--full-rebuild] [--dry-run] [--model <model>]
 */

import { CopilotClient } from "@github/copilot-sdk";
import { resolve } from "node:path";
import { parseArgs } from "./cli.js";
import { loadConfig } from "./config.js";
import {
  chunkArray,
  getCurrentCommit,
  getHumanFeedback,
  listCommitsSince,
  readKnowledge,
  readMeta,
  writeMeta,
} from "./knowledge.js";
import {
  buildDocUpdatePrompt,
  buildFeedbackPrompt,
  buildKnowledgePrompt,
  COMMITS_PER_BATCH,
  loadPromptFile,
} from "./prompts.js";
import { buildGitHubMcpConfig, log, runAgentSession } from "./session.js";

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

async function main(): Promise<void> {
  const args = parseArgs();
  const config = await loadConfig(args.config);

  // Resolve repo root (4 levels up from eng/scripts/doc-updater/src/)
  const repoRoot = resolve(import.meta.dirname ?? ".", "../../../..");

  // --- Dry run: print prompts and exit ---
  if (args.dryRun) {
    console.log("=== DRY RUN ===\n");
    console.log(`Config:        ${config.name} (${config.displayName})`);
    console.log(`Model:         ${args.model}`);
    console.log(`Full Rebuild:  ${args.fullRebuild}`);
    console.log();

    let dryRunCommits: string[] | undefined;

    // Feedback
    try {
      const meta = args.fullRebuild ? null : await readMeta(config.name);
      if (meta?.lastPrNumber) {
        const feedback = getHumanFeedback(meta.lastPrNumber);
        if (feedback) {
          const existingKnowledge = (await readKnowledge(config.name)) ?? "(none)";
          const docUpdatePrompt = await loadPromptFile(config.name, "doc-update");
          const prompt = buildFeedbackPrompt(config, feedback, existingKnowledge, docUpdatePrompt);
          console.log("--- Feedback Prompt ---");
          console.log(prompt);
          console.log();
        } else {
          console.log("--- Feedback ---");
          console.log(`(no human feedback detected on PR #${meta.lastPrNumber})`);
          console.log();
        }
      }
    } catch (e) {
      console.log(`Feedback check error: ${e}`);
      console.log();
    }

    // Knowledge Build
    try {
      const meta = args.fullRebuild ? null : await readMeta(config.name);
      if (!meta || args.fullRebuild) {
        const docUpdatePrompt = await loadPromptFile(config.name, "doc-update");
        const prompt = buildKnowledgePrompt(config, docUpdatePrompt);
        console.log("--- Knowledge Build Prompt (Full) ---");
        console.log(prompt);
        console.log();
      } else {
        const commits = listCommitsSince(config.sourceCodePaths, meta.lastCommit);
        dryRunCommits = commits;
        if (commits.length === 0) {
          console.log("--- Knowledge Build ---");
          console.log("(skipped — no source changes detected)");
          console.log();
        } else {
          const batches = chunkArray(commits, COMMITS_PER_BATCH);
          console.log(
            `--- Knowledge Build (Incremental: ${commits.length} commits in ${batches.length} batch(es)) ---`,
          );
          const docUpdatePrompt = await loadPromptFile(config.name, "doc-update");
          const prompt = buildKnowledgePrompt(config, docUpdatePrompt, batches[0]);
          console.log(prompt);
          if (batches.length > 1) {
            console.log(`\n... (${batches.length - 1} more batch(es) would follow)`);
          }
          console.log();
        }
      }
    } catch (e) {
      console.log(`Knowledge prompt error: ${e}`);
      console.log();
    }

    // Doc Update
    try {
      const prompt = await buildDocUpdatePrompt(config, dryRunCommits);
      console.log("--- Doc Update Prompt ---");
      console.log(prompt);
    } catch (e) {
      console.log(`Doc update prompt error: ${e}`);
    }
    return;
  }

  // --- Run the pipeline ---

  // Ensure the Copilot CLI agent starts in the repo root so it can
  // access all packages, docs, and run commands correctly.
  process.chdir(repoRoot);

  const client = new CopilotClient();

  try {
    // Early exit: if incremental mode and no source changes, skip everything
    if (!args.fullRebuild) {
      const meta = await readMeta(config.name);
      if (meta) {
        const commits = listCommitsSince(config.sourceCodePaths, meta.lastCommit);
        if (commits.length === 0) {
          await writeMeta(config.name, {
            ...meta,
            lastCommit: getCurrentCommit(),
            lastUpdated: new Date().toISOString(),
          });
          log("No source changes detected — nothing to do.");
          await client.stop();
          return;
        }
      }
    }

    // Step 1: Feedback Loop — learn from human corrections on the last PR
    const meta = await readMeta(config.name);
    if (meta?.lastPrNumber && !args.fullRebuild) {
      log(`Checking for human feedback on PR #${meta.lastPrNumber}...`);
      const feedback = getHumanFeedback(meta.lastPrNumber);

      if (feedback) {
        const feedbackSummary = [
          feedback.commits.length > 0 ? `${feedback.commits.length} human commit(s)` : "",
          feedback.reviewComments.length > 0
            ? `${feedback.reviewComments.length} review comment(s)`
            : "",
        ]
          .filter(Boolean)
          .join(", ");
        log(`Human feedback detected: ${feedbackSummary}. Running feedback session...`);

        const existingKnowledge = await readKnowledge(config.name);
        if (existingKnowledge) {
          const docUpdatePrompt = await loadPromptFile(config.name, "doc-update");
          const prompt = buildFeedbackPrompt(config, feedback, existingKnowledge, docUpdatePrompt);
          await runAgentSession(client, prompt, {
            model: args.model,
            repoRoot,
            phaseName: "Feedback",
            mcpServers: buildGitHubMcpConfig(),
          });
          log("Feedback session complete.");
        }
      } else {
        log(`No human feedback detected on PR #${meta.lastPrNumber}.`);
      }

      // Clear lastPrNumber so we don't re-check this PR on the next run
      await writeMeta(config.name, { ...meta, lastPrNumber: undefined });
    }

    // Step 2: Knowledge Build
    log(
      `Starting knowledge build for ${config.displayName} ` + `(full-rebuild: ${args.fullRebuild})`,
    );

    const knowledgeMeta = args.fullRebuild ? null : await readMeta(config.name);
    const needsFullBuild = !knowledgeMeta || args.fullRebuild;
    let changedCommits: string[] | undefined;

    log(
      `Meta: ${knowledgeMeta ? `lastCommit=${knowledgeMeta.lastCommit}, lastUpdated=${knowledgeMeta.lastUpdated}` : "(none)"}. ` +
        `needsFullBuild=${needsFullBuild}`,
    );

    if (needsFullBuild) {
      const docUpdatePrompt = await loadPromptFile(config.name, "doc-update");
      const prompt = buildKnowledgePrompt(config, docUpdatePrompt);

      await runAgentSession(client, prompt, {
        model: args.model,
        repoRoot,
        phaseName: "Knowledge Build",
        mcpServers: buildGitHubMcpConfig(),
      });

      await writeMeta(config.name, {
        lastCommit: getCurrentCommit(),
        lastUpdated: new Date().toISOString(),
        analyzedPaths: config.sourceCodePaths,
      });

      log("Knowledge build (full) complete.");
    } else {
      const commits = listCommitsSince(config.sourceCodePaths, knowledgeMeta.lastCommit);
      changedCommits = commits;

      const batches = chunkArray(commits, COMMITS_PER_BATCH);
      log(
        `Found ${commits.length} commit(s) since last build. ` +
          `Processing in ${batches.length} batch(es).`,
      );

      const docUpdatePrompt = await loadPromptFile(config.name, "doc-update");

      for (let i = 0; i < batches.length; i++) {
        const batch = batches[i];
        log(`Processing batch ${i + 1}/${batches.length} (${batch.length} commits)...`);

        const prompt = buildKnowledgePrompt(config, docUpdatePrompt, batch);
        await runAgentSession(client, prompt, {
          model: args.model,
          repoRoot,
          phaseName: `Knowledge Update [${i + 1}/${batches.length}]`,
          mcpServers: buildGitHubMcpConfig(),
        });

        const lastCommitInBatch = batch[batch.length - 1];
        await writeMeta(config.name, {
          lastCommit: lastCommitInBatch,
          lastUpdated: new Date().toISOString(),
          analyzedPaths: config.sourceCodePaths,
        });

        log(`Batch ${i + 1}/${batches.length} complete.`);
      }

      log("Knowledge build (incremental) complete.");
    }

    // Step 3: Doc Update
    log(`Starting doc update for ${config.displayName} (model: ${args.model})`);

    const docPrompt = await buildDocUpdatePrompt(config, changedCommits);

    await runAgentSession(client, docPrompt, {
      model: args.model,
      repoRoot,
      phaseName: "Doc Update",
      // Incremental mode needs MCP to inspect commits
      ...(changedCommits ? { mcpServers: buildGitHubMcpConfig() } : {}),
    });

    log("Doc update phase complete.");
  } finally {
    await client.stop();
  }

  log("Done.");
}

main().catch((err) => {
  console.error("Fatal error:", err);
  process.exit(1);
});
