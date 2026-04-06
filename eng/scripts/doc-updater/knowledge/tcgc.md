# TCGC Documentation Knowledge Base

## Build and Tool Setup

- `pnpm` is not directly available in the CI environment; use `corepack pnpm` or create a wrapper script at `/tmp/gh-aw/agent/bin/pnpm` that calls `corepack pnpm "$@"`.
- To build TCGC: `pnpm -r --filter "@azure-tools/typespec-client-generator-core..." build`
- To regenerate reference docs: `cd packages/typespec-client-generator-core && pnpm regen-docs`
- To build Spector specs: `cd packages/azure-http-specs && pnpm build`
- The azure-http-specs package name is `@azure-tools/azure-http-specs` (not `@typespec/azure-http-specs`).

## Spector Spec Patterns

- Spector specs must use `using global.Azure.ClientGenerator.Core;` (with `global.` prefix) when in the `_Specs_` namespace hierarchy to avoid namespace conflicts.
- The C# emitter requires an empty `metadata.json` file at `tsp-output/@azure-typespec/http-client-csharp/metadata.json` before compilation.
- Scenario names are derived from the namespace path (e.g., `Azure_ClientGenerator_Core_Scope_AllLanguages`).
- Mock APIs use `passOnSuccess` from `@typespec/spec-api` and define request/response pairs.

## Doc-Example-Generator Skill

- Share `node_modules` across example directories using symlinks to avoid repeated installs.
- Go emitter fails for `@responseAsBool` HEAD operations — use `// NOT_SUPPORTED` in Go tab.
- Java emitter may not fully reflect `@clientApiVersions` — it shows only service versions, not the extended client versions.
- TypeScript emitter requires `azure-sdk-for-js: false` and `is-typespec-test: true` options.

## Decorator Documentation Locations

- `@scope` → documented in `04method.mdx` under "Scoping operations to specific languages"
- `@responseAsBool` → documented in `04method.mdx` under "Modeling HEAD operations as boolean"
- `@deserializeEmptyStringAsNull` → documented in `08types.mdx` under "Deserializing Empty Strings as Null"
- `@clientApiVersions` → documented in `10versioning.mdx` under "Adding Client-Specific API Versions"
- `@markAsLro` → documented in `06longRunningOperations.mdx` under "Force LRO behavior (Legacy)"
- `@markAsPageable` / `@disablePageable` → documented in `05pagingOperations.mdx` under "Force paging behavior (Legacy)"
- `@clientDoc` → already documented in `08types.mdx` under "Client Documentation"
- `@clientOption` → documented in `12clientOptions.mdx`

## TSP Doc Comment Issues Found and Fixed

- `@client` decorator had an empty `@example` tag at line 181 — removed it.
- `@override` decorator had a garbled comment combining two examples on line 555 — fixed the comment text.

## ClientTabs Format

- Howto docs use `<ClientTabs>` with inline code blocks (not `<ClientTabItem>` wrapper).
- Language order: typespec, python, csharp, typescript, java, go.
- Some older docs use `<ClientTabItem lang="...">` wrapper — both patterns exist but inline is simpler.

## Spector Coverage Status

### Covered by existing specs

`@client`, `@clientName`, `@clientNamespace`, `@clientLocation`, `@clientInitialization`, `@apiVersion`, `@access`, `@usage`, `@override`, `@alternateType`, `@clientDefaultValue`, `@flattenProperty`, `@hierarchyBuilding`, `@nextLinkVerb`, `@deserializeEmptyStringAsNull`, `@paramAlias`, `@convenientAPI`

### Added in this update

`@responseAsBool`, `@scope`, `@clientDoc`

### Not in Spector (codegen-only features)

`@protocolAPI` (mirror of @convenientAPI), `@clientApiVersions` (enum-only), `@markAsLro`, `@markAsPageable`, `@disablePageable` (legacy), `@clientOption` (emitter pass-through), `@useSystemTextJsonConverter` (C#-specific)
