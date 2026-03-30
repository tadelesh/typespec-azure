# TCGC Package Knowledge Base

## Package Info

- **Name**: `@azure-tools/typespec-client-generator-core`
- **Namespace**: `Azure.ClientGenerator.Core`
- **Legacy Namespace**: `Azure.ClientGenerator.Core.Legacy`

## Decorators

### Core Decorators

| Decorator                       | Target                                                              | Key Parameters                                                    | Purpose                                    |
| ------------------------------- | ------------------------------------------------------------------- | ----------------------------------------------------------------- | ------------------------------------------ |
| `@client`                       | `Namespace \| Interface`                                            | `options?: ClientOptions`, `scope?`                               | Define client structure                    |
| `@operationGroup`               | `Namespace \| Interface`                                            | `scope?`                                                          | **Deprecated** alias for `@client`         |
| `@clientName`                   | any                                                                 | `rename: string`, `scope?`                                        | Override generated name                    |
| `@clientNamespace`              | `Namespace \| Interface \| Model \| Enum \| Union`                  | `rename: string`, `scope?`                                        | Override namespace                         |
| `@access`                       | `Model \| Enum \| Operation \| Union \| Namespace \| ModelProperty` | `value: Access.public \| Access.internal`, `scope?`               | Set public/internal access                 |
| `@usage`                        | `Model \| Enum \| Union \| Namespace`                               | `value: Usage flags`, `scope?`                                    | Declare input/output/serialization usage   |
| `@protocolAPI`                  | `Operation \| Namespace \| Interface`                               | `flag?: boolean`, `scope?`                                        | Control protocol method generation         |
| `@convenientAPI`                | `Operation \| Namespace \| Interface`                               | `flag?: boolean`, `scope?`                                        | Control convenience method generation      |
| `@override`                     | `Operation`                                                         | `override: Operation`, `scope?`                                   | Customize method signature                 |
| `@clientInitialization`         | `Namespace \| Interface`                                            | `options: ClientInitializationOptions`, `scope?`                  | Customize client init parameters           |
| `@paramAlias`                   | `ModelProperty`                                                     | `paramAlias: string`, `scope?`                                    | Alias parameter name at client level       |
| `@clientLocation`               | `Operation \| ModelProperty`                                        | `target: Interface \| Namespace \| Operation \| string`, `scope?` | Move operation/param between clients       |
| `@alternateType`                | `ModelProperty \| Scalar \| Model \| Enum \| Union`                 | `alternate: unknown \| ExternalType`, `scope?`                    | Replace type with alternate                |
| `@clientDoc`                    | any                                                                 | `documentation: string`, `mode: DocumentationMode`, `scope?`      | Override documentation                     |
| `@clientOption`                 | any                                                                 | `name: string`, `value: unknown`, `scope?`                        | Pass experimental options to emitters      |
| `@scope`                        | `Operation \| ModelProperty`                                        | `scope?`                                                          | Language-specific targeting                |
| `@apiVersion`                   | `ModelProperty`                                                     | `value?: boolean`, `scope?`                                       | Mark/unmark as API version param           |
| `@clientApiVersions`            | `Namespace`                                                         | `value: Enum`, `scope?`                                           | Specify additional API versions            |
| `@responseAsBool`               | `Operation` (HEAD only)                                             | `scope?`                                                          | Return bool for HEAD (404→false, 2xx→true) |
| `@deserializeEmptyStringAsNull` | `ModelProperty`                                                     | `scope?`                                                          | Treat empty string as null                 |
| `@useSystemTextJsonConverter`   | `Model`                                                             | `scope?`                                                          | C# custom JSON converter (backward compat) |

### Legacy Decorators (`Azure.ClientGenerator.Core.Legacy`)

| Decorator             | Target          | Key Parameters                                  | Purpose                               |
| --------------------- | --------------- | ----------------------------------------------- | ------------------------------------- |
| `@hierarchyBuilding`  | `Model`         | `value: Model`, `scope?`                        | Multi-level discriminator inheritance |
| `@flattenProperty`    | `ModelProperty` | `scope?`                                        | Flatten nested model property         |
| `@markAsLro`          | `Operation`     | `scope?`                                        | Force operation as LRO                |
| `@markAsPageable`     | `Operation`     | `scope?`                                        | Force operation as pageable           |
| `@disablePageable`    | `Operation`     | `scope?`                                        | Prevent pageable treatment            |
| `@nextLinkVerb`       | `Operation`     | `verb: "GET" \| "POST"`, `scope?`               | HTTP verb for next-link paging        |
| `@clientDefaultValue` | `ModelProperty` | `value: string \| boolean \| numeric`, `scope?` | Set client-level default value        |

### Functions (for use with `@override`)

| Function            | Parameters                                                                 | Purpose                   |
| ------------------- | -------------------------------------------------------------------------- | ------------------------- |
| `replaceParameter`  | `operation, selector: string \| ModelProperty, replacement: ModelProperty` | Replace a parameter       |
| `removeParameter`   | `operation, selector: string \| ModelProperty`                             | Remove optional parameter |
| `addParameter`      | `operation, parameter: ModelProperty`                                      | Add new parameter         |
| `reorderParameters` | `operation, order: string[]`                                               | Reorder parameters        |

## Key Public Types

### Core Types

- **`SdkPackage`** — Top-level entry: `clients`, `models`, `enums`, `unions`, `namespaces`, `metadata`, `licenseInfo`
- **`SdkClientType`** — Client: `name`, `methods`, `clientInitialization`, `apiVersions`, `parent`, `children`
- **`SdkClientInitializationType`** — Init config: `parameters`, `initializedBy` (Individually/Parent/CustomizeCode)
- **`SdkModelType`** — Model: `name`, `namespace`, `properties`, `access`, `usage`, `baseModel`, `discriminatorValue`, `discriminatedSubtypes`
- **`SdkEnumType`** — Enum: `name`, `values`, `valueType`, `isFixed`, `isFlags`, `isUnionAsEnum`
- **`SdkUnionType`** — Union: `name`, `variantTypes`, `access`, `usage`

### Method Types

- **`SdkBasicServiceMethod`** — Basic operation method
- **`SdkPagingServiceMethod`** — Pageable method with `pagingMetadata`
- **`SdkLroServiceMethod`** — Long-running method with `lroMetadata`
- **`SdkLroPagingServiceMethod`** — Combined LRO + paging

### HTTP Types

- **`SdkHttpOperation`** — HTTP operation: `path`, `verb`, `parameters`, `bodyParam`, `responses`, `exceptions`
- **`SdkHeaderParameter`**, **`SdkQueryParameter`**, **`SdkPathParameter`**, **`SdkBodyParameter`**, **`SdkCookieParameter`**

### Flags

- **`UsageFlags`**: `None`, `Input` (2), `Output` (4), `ApiVersionEnum` (8), `JsonMergePatch`, `MultipartFormData`, `Spread`, `Json` (256), `Xml` (512), `Exception`, `LroInitial`, `LroPolling`, `LroFinalEnvelope`, `External`
- **`InitializedByFlags`**: `Default` (0), `Individually` (1), `Parent` (2), `CustomizeCode` (4)
- **`AccessFlags`**: `"public"` | `"internal"`

## Emitter Options

| Option                         | Type      | Default    | Description                                                       |
| ------------------------------ | --------- | ---------- | ----------------------------------------------------------------- |
| `generate-protocol-methods`    | `boolean` | `true`     | Generate protocol methods                                         |
| `generate-convenience-methods` | `boolean` | `true`     | Generate convenience methods                                      |
| `api-version`                  | `string`  | `latest`   | Target API version (`latest`, `all`, or specific)                 |
| `emitter-name`                 | `string`  | —          | Target language emitter                                           |
| `license`                      | `object`  | —          | License info (`name`, `company`, `link`, `header`, `description`) |
| `examples-dir`                 | `string`  | `examples` | Examples directory path                                           |
| `namespace`                    | `string`  | —          | Override namespace for all types                                  |

## Feature-to-Documentation Mapping

| Feature Area                   | User Docs (howto)             | Guideline | Design Docs            | Spector Specs                                                  |
| ------------------------------ | ----------------------------- | --------- | ---------------------- | -------------------------------------------------------------- |
| Service & Namespace            | `02package.mdx`               | ✓         | —                      | `client/namespace`                                             |
| Client Structure               | `03client.mdx`                | ✓         | `client.md`            | `client/structure/*`                                           |
| Client Initialization          | `03client.mdx`                | ✓         | `client.md`            | `azure/client-generator-core/client-initialization/*`          |
| Client Location                | `03client.mdx`                | ✓         | —                      | `azure/client-generator-core/client-location/*`                |
| Methods & Signatures           | `04method.mdx`                | ✓         | —                      | —                                                              |
| Override & Parameter Functions | `04method.mdx`                | ✓         | —                      | `azure/client-generator-core/override`                         |
| Paging                         | `05pagingOperations.mdx`      | ✓         | —                      | `azure/core/page`, `azure/payload/pageable`                    |
| LRO                            | `06longRunningOperations.mdx` | ✓         | —                      | `azure/core/lro/*`                                             |
| Multipart                      | `07multipart.mdx`             | ✓         | —                      | —                                                              |
| Types & Models                 | `08types.mdx`                 | ✓         | —                      | —                                                              |
| Renaming                       | `09renaming.mdx`              | ✓         | —                      | `client/naming/*`                                              |
| Versioning                     | `10versioning.mdx`            | ✓         | —                      | `azure/client-generator-core/api-version/*`                    |
| Hierarchy Building (Legacy)    | `11hierarchyBuilding.mdx`     | —         | —                      | `azure/client-generator-core/hierarchy-building`               |
| Client Options                 | `12clientOptions.mdx`         | ✓         | —                      | —                                                              |
| Access Control                 | `04method.mdx`                | ✓         | —                      | `azure/client-generator-core/access`                           |
| Usage Flags                    | `04method.mdx`                | ✓         | —                      | `azure/client-generator-core/usage`                            |
| Protocol/Convenience           | `04method.mdx`                | ✓         | —                      | —                                                              |
| Alternate Types                | `08types.mdx`                 | ✓         | —                      | `azure/client-generator-core/alternate-type`                   |
| Client Doc                     | `08types.mdx`                 | ✓         | —                      | —                                                              |
| Flatten Property (Legacy)      | `08types.mdx`                 | —         | —                      | `azure/client-generator-core/flatten-property`                 |
| Client Default Value (Legacy)  | `08types.mdx`                 | —         | —                      | `azure/client-generator-core/client-default-value`             |
| Next Link Verb (Legacy)        | —                             | —         | —                      | `azure/client-generator-core/next-link-verb`                   |
| Deserialize Empty String       | —                             | —         | —                      | `azure/client-generator-core/deserialize-empty-string-as-null` |
| Response as Bool               | —                             | guideline | —                      | —                                                              |
| Multiple Services              | —                             | —         | `multiple-services.md` | `service/multi-service`                                        |
| Param Alias                    | `03client.mdx`                | —         | —                      | `azure/client-generator-core/client-initialization/*`          |

## Documentation Conventions

### User-Facing Howto Docs

- **Location**: `website/src/content/docs/docs/howtos/Generate client libraries/`
- **File naming**: `NNtopic.mdx` — zero-padded number prefix
- **All code examples** use `<ClientTabs>` with six language blocks: `typespec`, `python`, `csharp`, `typescript`, `java`, `go`
- **`<ClientTabs>` blocks** MUST be generated by the `@doc-example-generator` skill
- **Legacy decorators** marked with `:::caution` admonitions
- **NOT_SUPPORTED** or **TODO** used for languages that haven't implemented a feature yet
- **Frontmatter**: `title`, `sidebar: { order: N }`

### Emitter Developer Guide

- **Location**: `website/src/content/docs/docs/libraries/typespec-client-generator-core/guideline.md`
- Describes the client type graph, calculation logic, and helper functions
- Type descriptions must align with `SdkPackage` structure

### Design Documents

- **Location**: `packages/typespec-client-generator-core/design-docs/`
- Current docs: `client.md`, `multiple-services.md`
- Show detailed YAML representations of TCGC output

## Test File Paths

Unit tests are at `packages/typespec-client-generator-core/test/`:

- **Decorator tests**: `decorators/` — `access.test.ts`, `alternate-type.test.ts`, `client-initialization.test.ts`, `override.test.ts`, `scope.test.ts`, `usage.test.ts`, etc.
- **Type tests**: `types/` — `array.test.ts`, `enum.test.ts`, `union.test.ts`, `built-in.test.ts`, etc.
- **Method tests**: `methods/` — `lro.test.ts`, `paged-operation.test.ts`, `parameters.test.ts`, `spread.test.ts`, etc.
- **Client tests**: `clients/` — `structure.test.ts`, `params.test.ts`

Spector specs are at `packages/azure-http-specs/specs/`.
