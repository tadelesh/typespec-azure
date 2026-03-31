# TCGC Documentation Knowledge Base

## Decorator Inventory

TCGC defines 21 main decorators and 7 legacy decorators across three TSP files:

- `lib/decorators.tsp` — Main decorators: `@clientName`, `@convenientAPI`, `@protocolAPI`, `@client`, `@operationGroup` (deprecated), `@usage`, `@access`, `@override`, `@useSystemTextJsonConverter`, `@clientInitialization`, `@paramAlias`, `@clientNamespace`, `@alternateType`, `@scope`, `@apiVersion`, `@clientApiVersions`, `@deserializeEmptyStringAsNull`, `@responseAsBool`, `@clientLocation`, `@clientDoc`, `@clientOption`
- `lib/functions.tsp` — Functions: `replaceParameter`, `removeParameter`, `addParameter`, `reorderParameters`
- `lib/legacy.tsp` — Legacy decorators: `@hierarchyBuilding`, `@flattenProperty`, `@markAsLro`, `@markAsPageable`, `@disablePageable`, `@nextLinkVerb`, `@clientDefaultValue`

## Decorator-to-Documentation Mapping

| Decorator                       | Documentation File         |
| ------------------------------- | -------------------------- |
| `@clientName`                   | 09renaming.mdx             |
| `@convenientAPI`                | 04method.mdx               |
| `@protocolAPI`                  | 04method.mdx               |
| `@client`                       | 03client.mdx               |
| `@operationGroup`               | 03client.mdx (deprecated)  |
| `@usage`                        | 04method.mdx (brief)       |
| `@access`                       | 04method.mdx               |
| `@override`                     | 04method.mdx               |
| `@clientInitialization`         | 03client.mdx               |
| `@paramAlias`                   | 03client.mdx               |
| `@clientNamespace`              | 02package.mdx, 08types.mdx |
| `@alternateType`                | 08types.mdx                |
| `@scope`                        | 04method.mdx               |
| `@apiVersion`                   | 10versioning.mdx           |
| `@clientApiVersions`            | 10versioning.mdx           |
| `@deserializeEmptyStringAsNull` | 08types.mdx                |
| `@responseAsBool`               | 08types.mdx                |
| `@clientLocation`               | 03client.mdx               |
| `@clientDoc`                    | 08types.mdx                |
| `@clientOption`                 | 12clientOptions.mdx        |
| `@hierarchyBuilding`            | 11hierarchyBuilding.mdx    |
| `@flattenProperty`              | 08types.mdx                |
| `replaceParameter`              | 04method.mdx               |
| `removeParameter`               | 04method.mdx               |
| `addParameter`                  | 04method.mdx               |
| `reorderParameters`             | 04method.mdx               |

## Decorator-to-Spector Spec Mapping

| Decorator                       | Spector Spec Directory                                        |
| ------------------------------- | ------------------------------------------------------------- |
| `@client`                       | client/structure/                                             |
| `@clientName`                   | client/naming/                                                |
| `@clientNamespace`              | client/namespace/                                             |
| `@access`                       | azure/client-generator-core/access/                           |
| `@usage`                        | azure/client-generator-core/usage/                            |
| `@flattenProperty`              | azure/client-generator-core/flatten-property/                 |
| `@alternateType`                | azure/client-generator-core/alternate-type/                   |
| `@nextLinkVerb`                 | azure/client-generator-core/next-link-verb/                   |
| `@clientLocation`               | azure/client-generator-core/client-location/                  |
| `@clientDefaultValue`           | azure/client-generator-core/client-default-value/             |
| `@clientInitialization`         | azure/client-generator-core/client-initialization/            |
| `@override`                     | azure/client-generator-core/override/                         |
| `@hierarchyBuilding`            | azure/client-generator-core/hierarchy-building/               |
| `@deserializeEmptyStringAsNull` | azure/client-generator-core/deserialize-empty-string-as-null/ |
| `@apiVersion`                   | azure/client-generator-core/api-version/                      |
| `@scope`                        | azure/client-generator-core/scope/                            |
| `@responseAsBool`               | azure/client-generator-core/response-as-bool/                 |
| `@clientDoc`                    | azure/client-generator-core/client-doc/                       |
| `@convenientAPI`                | azure/client-generator-core/convenient-api/                   |

## Key API Signatures and Behaviors

### `@access` decorator

- Takes `EnumMember` (not string): use `Access.internal` or `Access.public`, not `"internal"` or `"public"`
- Propagates through model hierarchies, parent models, discriminated sub-models
- If an operation is `Access.internal`, models used only by that operation become internal too

### `@scope` decorator

- `@scope("python, java")` — Include only in Python and Java
- `@scope("!csharp, !go")` — Exclude from C# and Go
- `@scope("!(csharp, go)")` — Alternative exclusion syntax
- Applies to `Operation` and `ModelProperty` targets

### `@responseAsBool` decorator

- Can only be applied to `@head` operations; emits diagnostic error otherwise
- Returns `true` for 2xx, `false` for 404, errors for other status codes
- Go emitter does not currently support this decorator

### `@clientApiVersions` decorator

- Extends the API version enum beyond what `@versioned` defines
- C# correctly generates all extended versions
- Java may only include versions from `@versioned`, not the extended enum

### `@deserializeEmptyStringAsNull` decorator

- Only valid on properties of type `string` or scalar derived from `string`
- Emits diagnostic if applied to non-string types

### `@clientDoc` decorator

- `DocumentationMode.replace` — Replaces `@doc` completely
- `DocumentationMode.append` — Appends to `@doc` text

## Documentation Conventions

- All `<ClientTabs>` blocks must be generated by the @doc-example-generator skill
- Language tab order: typespec, python, csharp, typescript, java, go
- Use `// NOT_SUPPORTED` for unsupported features
- Spector specs use `@global.Azure.ClientGenerator.Core.` prefix for TCGC decorators due to `_Specs_` namespace conflicts
- `spec-summary.md` is auto-generated — never edit manually; use `pnpm regen-docs`

## Enums Reference

- `Usage`: `input` (2), `output` (4), `json` (256), `xml` (512) — combine with bitwise OR
- `Access`: `public` ("public"), `internal` ("internal")
- `InitializedBy`: `individually` (1), `parent` (2), `customizeCode` (4)
- `DocumentationMode`: `append` ("append"), `replace` ("replace")
