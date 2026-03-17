# TCGC Documentation Knowledge Base

## Package Info

- **Package**: `@azure-tools/typespec-client-generator-core`
- **Version**: 0.66.2
- **TSP Main**: `./lib/main.tsp`

## Decorator → Doc Page Mapping

| Decorator                       | Namespace | Doc Page                   | Section                                 |
| ------------------------------- | --------- | -------------------------- | --------------------------------------- |
| `@client`                       | Core      | `03client.mdx`             | Default behavior / Customizations       |
| `@operationGroup`               | Core      | `03client.mdx`             | Operation Groups                        |
| `@clientName`                   | Core      | `09renaming.mdx`           | Renaming models/operations/parameters   |
| `@clientNamespace`              | Core      | `02package.mdx`            | Namespace customization                 |
| `@clientLocation`               | Core      | `03client.mdx`, `04method` | Move operations / parameters            |
| `@clientInitialization`         | Core      | `03client.mdx`             | Client init parameters                  |
| `@paramAlias`                   | Core      | `03client.mdx`             | Parameter aliasing                      |
| `@convenientAPI`                | Core      | `04method.mdx`             | Convenience vs protocol methods         |
| `@protocolAPI`                  | Core      | `04method.mdx`             | Convenience vs protocol methods         |
| `@access`                       | Core      | `04method.mdx`             | Make methods private/internal           |
| `@usage`                        | Core      | `04method.mdx`             | Decide model usage                      |
| `@override`                     | Core      | `04method.mdx`             | Prevent spreading                       |
| `@scope`                        | Core      | `04method.mdx`             | Limit operations to specific languages  |
| `@responseAsBool`               | Core      | `04method.mdx`             | HEAD operations returning boolean       |
| `@alternateType`                | Core      | `08types.mdx`              | External type references                |
| `@clientDoc`                    | Core      | `08types.mdx`              | Client Documentation                    |
| `@deserializeEmptyStringAsNull` | Core      | `08types.mdx`              | Serialization Decorators                |
| `@useSystemTextJsonConverter`   | Core      | (reference only)           | C#-specific JSON converter              |
| `@apiVersion`                   | Core      | `10versioning.mdx`         | Overriding Client Api Version Parameter |
| `@clientApiVersions`            | Core      | `10versioning.mdx`         | Extending API Versions                  |
| `@clientOption`                 | Core      | `12clientOptions.mdx`      | Client Options                          |
| `@flattenProperty`              | Legacy    | `08types.mdx`              | Flattening (legacy)                     |
| `@hierarchyBuilding`            | Legacy    | `11hierarchyBuilding.mdx`  | Multi-layer discriminator hierarchy     |
| `@markAsLro`                    | Legacy    | `06longRunningOperations`  | LRO Legacy Decorators                   |
| `@markAsPageable`               | Legacy    | `05pagingOperations.mdx`   | Paging Legacy Decorators                |
| `@disablePageable`              | Legacy    | `05pagingOperations.mdx`   | Paging Legacy Decorators                |
| `@nextLinkVerb`                 | Legacy    | `05pagingOperations.mdx`   | Paging Legacy Decorators                |
| `@clientDefaultValue`           | Legacy    | `08types.mdx`              | Client Default Values (Legacy)          |

## Decorator Signatures (from lib/decorators.tsp)

All decorators support an optional `scope?: valueof string` parameter for language-specific targeting.
Valid scopes: `"python"`, `"csharp"`, `"java"`, `"javascript"`, `"go"`, negation `"!csharp"`, multi `"python, java"`.

### Key Signatures

- `@client(target, options?: {name?, service?}, scope?)` — Define root client
- `@operationGroup(target, scope?)` — Define sub-client
- `@clientName(target, rename: string, scope?)` — Override name
- `@access(target, value: Access.public|internal, scope?)` — Access level
- `@usage(target, value: Usage.input|output|json|xml, scope?)` — Usage flags
- `@scope(target: Operation|ModelProperty, scope?)` — Limit to emitters
- `@responseAsBool(target: Operation, scope?)` — HEAD → boolean
- `@clientDoc(target, documentation: string, mode: DocumentationMode.append|replace, scope?)` — Override docs
- `@clientApiVersions(target: Namespace, value: Enum, scope?)` — Extend versions
- `@deserializeEmptyStringAsNull(target: ModelProperty, scope?)` — Empty string → null
- `@alternateType(target, alternate: Type|ExternalType, scope?)` — Replace type
- `@clientInitialization(target, options: {parameters?, initializedBy?}, scope?)` — Init config
- `@markAsLro(target: Operation, scope?)` — Force LRO (Legacy)
- `@markAsPageable(target: Operation, scope?)` — Force paging (Legacy)
- `@disablePageable(target: Operation, scope?)` — Disable paging (Legacy)
- `@nextLinkVerb(target: Operation, verb: "GET"|"POST", scope?)` — Paging verb (Legacy)

## Doc Conventions

### User-facing howto docs (`Generate client libraries/`)

- Files prefixed with two-digit numbers: `00howtogen.mdx`, `01setup.mdx`, etc.
- Frontmatter: `title` and `llmstxt: true`
- Import: `import { ClientTabs, ClientTabItem } from "@components/client-tabs";`
- Code examples use `<ClientTabs>` with six language blocks in order: typespec, python, csharp, typescript, java, go
- Legacy decorators marked with `:::caution` admonitions
- TypeSpec examples can have `title` attribute: ` ```typespec title="main.tsp" `

#### Internal-only decorators (no language code examples)

Some decorators only affect internal emitter implementation (e.g., serialization, deserialization, HTTP request behavior) and do **not** change the public API surface or model shape. For these decorators, the `<ClientTabs>` block must contain **only the TypeSpec examples** (main.tsp and client.tsp). Do NOT include language-specific output tabs (python, csharp, typescript, java, go) because there is nothing observable in the generated API surface. Instead, add a sentence to the prose description noting that the decorator only affects internal behavior.

Decorators in this category:

- `@nextLinkVerb` — affects which HTTP verb is used internally for next-link pagination requests; no change to the public paging API
- `@deserializeEmptyStringAsNull` — affects internal deserialization behavior; no change to the public model surface

#### Language-specific support notes

- **TypeScript supports `@disablePageable`**: When `@disablePageable` is applied, TypeScript returns `Promise<ModelType>` instead of `PagedAsyncIterableIterator<ItemType>`. Do NOT mark TypeScript as `// NOT_SUPPORTED` for this decorator. All emitters support `@disablePageable` — they simply follow the TCGC type graph to determine if an operation is pageable.
- **Go does not export API version enums**: When documenting `@clientApiVersions` or API version features, the Go tab should say `// Go does not export the API version enum - no impact` rather than showing a generated function signature.

### Emitter developer docs (`guideline.md`)

- References TCGC type graph: `SdkClient`, `SdkOperationGroup`, `SdkPackage`, etc.
- Uses `@clientLocation` (not the old `@moveTo` which was renamed)

### Design docs (`design-docs/`)

- Two files: `client.md`, `multiple-services.md`
- Uses `@clientLocation` (not `@moveTo`)

## Spector Spec Coverage

### Covered (`specs/azure/client-generator-core/`)

access, alternate-type, api-version (3 scenarios), client-default-value,
client-doc, client-initialization (3 scenarios), client-location (4 scenarios),
deserialize-empty-string-as-null, disable-pageable, flatten-property,
hierarchy-building, mark-as-pageable, next-link-verb, override,
response-as-bool, usage

### Not Covered (acceptable gaps)

- `@useSystemTextJsonConverter` — C#-internal, no HTTP behavior to test
- `@markAsLro` — Complex polling mock needed; unit tests cover this
- `@clientOption` — Experimental, "coming soon" in docs
- `@scope` — Tested indirectly via `azure/core/page/client.tsp`

## Cross-References

- `guideline.md` references `@clientLocation` for client/method detection logic
- `design-docs/multiple-services.md` documents multi-service `@client` with service arrays
- Auto-generated reference docs at `libraries/typespec-client-generator-core/reference/decorators.md`
- Test files at `packages/typespec-client-generator-core/test/decorators/` (28 test files)
