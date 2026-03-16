# TCGC Knowledge Base

## Package Info

- **Package**: `@azure-tools/typespec-client-generator-core`
- **Namespace**: `Azure.ClientGenerator.Core`
- **Legacy Namespace**: `Azure.ClientGenerator.Core.Legacy`
- **TSP lib files**: `lib/decorators.tsp`, `lib/legacy.tsp`, `lib/main.tsp`, `lib/augmentCore.tsp`

## Decorators (Main Namespace)

| Decorator                       | Target                                          | Parameters                                                    | Documented In       |
| ------------------------------- | ----------------------------------------------- | ------------------------------------------------------------- | ------------------- |
| `@clientName`                   | `unknown`                                       | `rename: string, scope?: string`                              | 09renaming.mdx      |
| `@convenientAPI`                | `Operation \| Namespace \| Interface`           | `flag?: boolean, scope?: string`                              | 04method.mdx        |
| `@protocolAPI`                  | `Operation \| Namespace \| Interface`           | `flag?: boolean, scope?: string`                              | 04method.mdx        |
| `@client`                       | `Namespace \| Interface`                        | `options?: ClientOptions, scope?: string`                     | 03client.mdx        |
| `@operationGroup`               | `Namespace \| Interface`                        | `scope?: string`                                              | 03client.mdx        |
| `@usage`                        | `Model \| Enum \| Union \| Namespace`           | `value: EnumMember \| Union, scope?: string`                  | 04method.mdx        |
| `@access`                       | `ModelProperty \| Model \| Op \| Enum \| Union` | `value: EnumMember, scope?: string`                           | 04method.mdx        |
| `@override`                     | `Operation`                                     | `override: Operation, scope?: string`                         | 04method.mdx        |
| `@useSystemTextJsonConverter`   | `Model`                                         | `scope?: string`                                              | (C# specific)       |
| `@clientInitialization`         | `Namespace \| Interface`                        | `options: ClientInitializationOptions, scope?: string`        | 03client.mdx        |
| `@paramAlias`                   | `ModelProperty`                                 | `paramAlias: string, scope?: string`                          | 03client.mdx        |
| `@clientNamespace`              | `Namespace \| Interface \| Model \| Enum`       | `rename: string, scope?: string`                              | 08types.mdx         |
| `@alternateType`                | `ModelProperty \| Scalar \| Model \| Enum`      | `alternate: unknown \| ExternalType, scope?: string`          | 08types.mdx         |
| `@scope`                        | `Operation \| ModelProperty`                    | `scope?: string`                                              | 04method.mdx        |
| `@apiVersion`                   | `ModelProperty`                                 | `value?: boolean, scope?: string`                             | 10versioning.mdx    |
| `@clientApiVersions`            | `Namespace`                                     | `value: Enum, scope?: string`                                 | 10versioning.mdx    |
| `@deserializeEmptyStringAsNull` | `ModelProperty`                                 | `scope?: string`                                              | 08types.mdx         |
| `@responseAsBool`               | `Operation`                                     | `scope?: string`                                              | 04method.mdx        |
| `@clientLocation`               | `Operation \| ModelProperty`                    | `target: Interface \| Namespace \| Op \| string, scope?: str` | 03client, 04method  |
| `@clientDoc`                    | `unknown`                                       | `documentation: string, mode: EnumMember, scope?: string`     | 08types.mdx         |
| `@clientOption`                 | `unknown`                                       | `name: string, value: unknown, scope?: string`                | 12clientOptions.mdx |

## Decorators (Legacy Namespace)

| Decorator             | Target          | Parameters                                   | Documented In       |
| --------------------- | --------------- | -------------------------------------------- | ------------------- |
| `@hierarchyBuilding`  | `Model`         | `value: Model, scope?: string`               | 11hierarchyBuilding |
| `@flattenProperty`    | `ModelProperty` | `scope?: string`                             | 08types.mdx         |
| `@markAsLro`          | `Operation`     | `scope?: string`                             | 06longRunning.mdx   |
| `@markAsPageable`     | `Operation`     | `scope?: string`                             | 05pagingOps.mdx     |
| `@disablePageable`    | `Operation`     | `scope?: string`                             | 05pagingOps.mdx     |
| `@nextLinkVerb`       | `Operation`     | `verb: "GET" \| "POST", scope?: string`      | 05pagingOps.mdx     |
| `@clientDefaultValue` | `ModelProperty` | `value: string \| boolean \| numeric, scope` | 08types.mdx         |

## Key Enums

- `Usage`: `input(2)`, `output(4)`, `json(256)`, `xml(512)`
- `Access`: `public("public")`, `internal("internal")`
- `InitializedBy`: `individually(1)`, `parent(2)`, `customizeCode(4)`
- `DocumentationMode`: `append("append")`, `replace("replace")`

## Key Models

- `ClientOptions`: `{ service?: Namespace | Namespace[]; name?: string; }`
- `ClientInitializationOptions`: `{ parameters?: Model; initializedBy?: EnumMember | Union; }`
- `ExternalType`: `{ identity: string; package?: string; minVersion?: string; }`

## Documentation Locations

- **User howto docs**: `website/src/content/docs/docs/howtos/Generate client libraries/`
- **Emitter dev docs**: `website/src/content/docs/docs/libraries/typespec-client-generator-core/guideline.md`
- **Design docs**: `packages/typespec-client-generator-core/design-docs/`
- **Spector specs**: `packages/azure-http-specs/specs/azure/client-generator-core/`

## Spector Test Coverage

| Feature                   | Spector Path                        |
| ------------------------- | ----------------------------------- |
| Access control            | `access/`                           |
| Alternate type            | `alternate-type/`                   |
| API version               | `api-version/`                      |
| Client default value      | `client-default-value/`             |
| Client initialization     | `client-initialization/`            |
| Client location           | `client-location/`                  |
| Deserialize empty as null | `deserialize-empty-string-as-null/` |
| Flatten property          | `flatten-property/`                 |
| Hierarchy building        | `hierarchy-building/`               |
| Next link verb            | `next-link-verb/`                   |
| Override                  | `override/`                         |
| Usage                     | `usage/`                            |
| Scope                     | `scope/` (added 2026-03)            |
| Response as bool          | `response-as-bool/` (added 2026-03) |

## Doc Conventions

- All `<ClientTabs>` examples must include six language blocks: typespec, python, csharp, typescript, java, go
- Legacy decorators require `:::caution` admonition
- Decorator refs in Spector specs use `@global.Azure.ClientGenerator.Core.` prefix
- Scenario naming: `Namespace.Interface.OperationName` with dots
- Mock API scenario keys use underscores: `Azure_ClientGenerator_Core_Feature_Scenario`

## Known Issues Found (2026-03-16)

1. `@alternateType` docs used `fullyQualifiedName` instead of `identity` — FIXED
2. Missing docs for `@scope`, `@responseAsBool`, `@apiVersion(false)`, `@clientApiVersions`, `@deserializeEmptyStringAsNull` — FIXED
3. Missing legacy docs for `@markAsLro`, `@markAsPageable`, `@disablePageable`, `@nextLinkVerb` — FIXED
4. Missing Spector specs for `@scope` and `@responseAsBool` — FIXED
