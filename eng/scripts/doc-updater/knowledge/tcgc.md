# TCGC Documentation Knowledge Base

## Codebase Structure

- **Unit tests**: `packages/typespec-client-generator-core/test/` — 34,000+ lines across decorators, types, clients, methods, http, package
- **TSP declarations**: `packages/typespec-client-generator-core/lib/decorators.tsp` (main, ~1194 lines) and `lib/legacy.tsp` (legacy, ~235 lines)
- **User docs**: `website/src/content/docs/docs/howtos/Generate client libraries/` — 13 mdx files
- **Emitter dev docs**: `website/src/content/docs/docs/libraries/typespec-client-generator-core/guideline.md`
- **Design docs**: `packages/typespec-client-generator-core/design-docs/`
- **Reference docs**: Auto-generated at `website/src/content/docs/docs/libraries/typespec-client-generator-core/reference/` — run `pnpm regen-docs` from `packages/typespec-client-generator-core/` to regenerate
- **Spector specs**: `packages/azure-http-specs/specs/azure/client-generator-core/`

## Decorator Inventory (Complete)

### Main decorators (Azure.ClientGenerator.Core namespace)

1. `@clientName` — rename any type
2. `@convenientAPI` — control convenience method generation
3. `@protocolAPI` — control protocol method generation
4. `@client` — define client structure with ClientOptions (name, service, autoMergeService)
5. `@operationGroup` — deprecated, use `@client` instead
6. `@usage` — add usage flags (input, output, json, xml)
7. `@access` — set public/internal visibility
8. `@override` — customize method signatures
9. `@useSystemTextJsonConverter` — C# JSON converter (legacy)
10. `@clientInitialization` — customize client init params (parameters, initializedBy)
11. `@paramAlias` — alias parameter names for client init
12. `@clientNamespace` — change namespace of types
13. `@alternateType` — substitute types (including external types)
14. `@scope` — language-specific scoping for operations/properties
15. `@apiVersion` — mark parameter as API version
16. `@clientApiVersions` — extend API version enum
17. `@deserializeEmptyStringAsNull` — deserialize empty strings as null
18. `@responseAsBool` — HEAD operations return bool
19. `@clientLocation` — move operations/parameters between clients
20. `@clientDoc` — client-specific documentation (append/replace)
21. `@clientOption` — experimental language-specific options

### Legacy decorators (Azure.ClientGenerator.Core.Legacy namespace)

1. `@hierarchyBuilding` — multi-level discriminator inheritance
2. `@flattenProperty` — flatten nested model properties
3. `@markAsLro` — force operation as LRO
4. `@markAsPageable` — force operation as pageable
5. `@disablePageable` — disable paging on @list operations
6. `@nextLinkVerb` — specify HTTP verb for next page (GET/POST)
7. `@clientDefaultValue` — set default values for properties/parameters

## Key Patterns

- User howto docs use `<ClientTabs>` blocks with 6 language tabs (typespec, python, csharp, typescript, java, go)
- Earlier docs (08types.mdx) also use the older `<ClientTabItem>` format within `<ClientTabs>`
- The `@doc-example-generator` skill must be used for all `<ClientTabs>` blocks in user docs
- Legacy decorators should always be marked with `:::caution` admonitions
- guideline.md previously used `@moveTo` to refer to what is now `@clientLocation` — this was corrected

## Corrections Made

- **decorators.tsp line 555**: Had garbled text in @override doc comment. Fixed to accurately describe that the override makes bar required.
- **guideline.md**: References to `@moveTo` updated to `@clientLocation` (4 occurrences)
- **multiple-services.md**: Reference to `@moveTo` removed from decorator list

## Documentation Gaps Addressed

- Added `@clientApiVersions` section to 10versioning.mdx
- Added `@responseAsBool` section to 04method.mdx
- Added `@deserializeEmptyStringAsNull` section to 08types.mdx
- Added legacy paging decorators (`@markAsPageable`, `@disablePageable`, `@nextLinkVerb`) to 05pagingOperations.mdx
- Added `@markAsLro` section to 06longRunningOperations.mdx

## Remaining Documentation Gaps (for future runs)

- `@scope` decorator not documented in user howto docs (it works on operations and model properties including HTTP params)
- `@clientDoc` not documented in user howto docs (supports append/replace modes)
- `@clientInitialization` with `InitializedBy.customizeCode` not documented
- `@convenientAPI` / `@protocolAPI` could use more comprehensive examples
- Some C# examples in existing docs have TODO placeholders
- XML serialization options not documented in user docs

## Spector Coverage

- Created `response-as-bool` Spector spec with `exists` (204→true) and `doesNotExist` (404→false) scenarios
- Remaining gaps: @markAsPageable, @markAsLro, @disablePageable, @clientDoc, @protocolAPI, @clientApiVersions, @clientOption lack dedicated Spector specs (though many are code-gen-only concerns)

## Emitter Behavior Notes

- Go emitter does not support `@responseAsBool` (crashes with InternalError)
- Python exposes API versions as string kwargs, not enums
- Java generates ServiceVersion enums; `@clientApiVersions` may not extend them in all emitters
- C# fully supports `@clientApiVersions` with extended ServiceVersion enum
- TypeScript generates `KnownVersions` enum that includes extended versions
