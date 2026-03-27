# Doc-Updater Pipeline

```mermaid
flowchart LR
    subgraph Config
        YAML[tcgc.yaml]
        PROMPT[doc-update.md]
    end

    subgraph "Scheduler (traditional workflow)"
        DISCOVER[Discover configs]
        DISPATCH[Dispatch per config]
    end

    subgraph "Agentic Workflow (per config)"
        direction TB
        PRECOMPUTE["steps: precompute.ts
        Extract diffs + feedback + knowledge
        (deterministic, no untrusted text)"]
        AGENT["Agent (sandboxed, read-only)
        Update docs + build knowledge"]
        VALIDATE["post-steps: validate file scope
        + update-meta.ts"]
    end

    Config --> PRECOMPUTE
    DISCOVER --> DISPATCH
    DISPATCH --> PRECOMPUTE
    PRECOMPUTE -->|"context.json
    (code diffs only)"| AGENT
    PROMPT --> AGENT
    AGENT --> VALIDATE

    KB[(knowledge/tcgc.md)]
    PR["safe-output:
    create-pull-request"]

    KB --> PRECOMPUTE
    AGENT --> KB
    VALIDATE --> PR
    PR -->|"human review
    + merge"| PRECOMPUTE
```

## Security Model

- **No untrusted text in agent context**: Review comments and commit messages
  are excluded from `context.json`. Only code diffs are passed to the agent.
- **Agent runs read-only**: File changes are applied only via the
  `create-pull-request` safe output, which sanitizes the output.
- **File scope enforced by post-step**: The `validate file scope` post-step
  checks that the agent only modified files in `allowedPaths` from the config.
- **Network isolation**: The agent runs in a sandboxed container with
  restricted network access.
