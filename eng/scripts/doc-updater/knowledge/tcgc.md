# TCGC Documentation Knowledge Base

## Decorator Doc Comments

- The TSP doc comments in `decorators.tsp` and `legacy.tsp` are the source of truth for generated reference docs at `website/src/content/docs/docs/libraries/typespec-client-generator-core/reference/`.
- After editing doc comments, always run `pnpm regen-docs` from `packages/typespec-client-generator-core/` to regenerate. This also regenerates `generated-defs/` TypeScript files and `README.md`.
- The `global.` prefix is required in Spector spec `.tsp` files when referencing `Azure.ClientGenerator.Core` decorators (e.g., `@global.Azure.ClientGenerator.Core.responseAsBool`). Without `global.`, the tsp-spector validator may not resolve the decorator.

## Howto Documentation Structure

- Each howto file in `website/src/content/docs/docs/howtos/Generate client libraries/` owns a specific topic. Always read a file first to understand its scope before editing.
- File mapping:
  - `03client.mdx` — client structure, sub-clients, `@client`, `@clientInitialization`, `@paramAlias`, multi-service
  - `04method.mdx` — methods, `@convenientAPI`, `@protocolAPI`, `@access`, `@usage`, `@override`, `@scope`, `@responseAsBool`, `@clientLocation`, transformation functions
  - `05pagingOperations.mdx` — paging, `@nextLink`, `@continuationToken`, `@markAsPageable`, `@disablePageable`, `@nextLinkVerb`
  - `06longRunningOperations.mdx` — LRO, `@markAsLro`
  - `08types.mdx` — types, models, unions, enums, `@alternateType`, `@clientDefaultValue`, `@deserializeEmptyStringAsNull`, `@clientDoc`, `@clientNamespace`
  - `09renaming.mdx` — `@clientName`
  - `10versioning.mdx` — versioning, `@apiVersion`, `@clientApiVersions`
  - `11hierarchyBuilding.mdx` — `@hierarchyBuilding`
  - `12clientOptions.mdx` — `@clientOption`

## Guideline.md Structure

- Located at `website/src/content/docs/docs/libraries/typespec-client-generator-core/guideline.md`
- Audience: emitter developers building language-specific SDK generators
- Key sections: Package, Client (with InitializedByFlags), Method, Operation, Type system, Example types, Calculation logic
- References `@moveTo` in older text — this was renamed to `@clientLocation` and text should use the current name

## Spector Spec Patterns

- Spector specs live in `packages/azure-http-specs/specs/azure/client-generator-core/`
- Each feature gets its own subdirectory with `main.tsp` and `mockapi.ts`
- Use `@scenario` and `@scenarioDoc` from `@typespec/spector`
- Use `@scenarioService("/azure/client-generator-core/<feature>")` for the service route
- The namespace must follow `_Specs_.Azure.ClientGenerator.Core.<FeatureName>`
- Add `@@clientNamespace(..., "java")` for Java namespace mapping
- After creating specs, run: `pnpm build && pnpm validate-mock-apis && pnpm cspell && pnpm regen-docs` from `packages/azure-http-specs`

## Build Commands

- `pnpm` is available via `corepack pnpm` or a wrapper at `~/.local/bin/pnpm`
- Build TCGC: `pnpm -r --filter "@azure-tools/typespec-client-generator-core..." build`
- Build specs: `pnpm -r --filter "@azure-tools/azure-http-specs..." build`
- Regen TCGC reference docs: `cd packages/typespec-client-generator-core && pnpm regen-docs`
- Regen spec summary: `cd packages/azure-http-specs && pnpm regen-docs`

## Key Interfaces

- `UsageFlags` enum in `src/interfaces.ts` — bitmap with flags: None, Input, Output, ApiVersionEnum, JsonMergePatch, MultipartFormData, Spread, Json, Xml, Exception, LroInitial, LroPolling, LroFinalEnvelope, External
- `InitializedByFlags` enum — Default (0), Individually (1), Parent (2), CustomizeCode (4); bit flags that can be combined
- `@operationGroup` is deprecated in favor of `@client` for sub-clients
