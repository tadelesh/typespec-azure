# TCGC Documentation Knowledge Base

## Package Info

- **Name**: `@azure-tools/typespec-client-generator-core`
- **Version**: 0.66.4
- **TSP Namespace**: `Azure.ClientGenerator.Core`
- **Legacy Namespace**: `Azure.ClientGenerator.Core.Legacy`

## Decorators

### Core Decorators

| Decorator                       | Signature Target                                    | Key Parameters                                                                |
| ------------------------------- | --------------------------------------------------- | ----------------------------------------------------------------------------- |
| `@clientName`                   | `unknown`                                           | `rename: valueof string`, `scope?: valueof string`                            |
| `@convenientAPI`                | `Operation \| Namespace \| Interface`               | `flag?: valueof boolean`, `scope?: valueof string`                            |
| `@protocolAPI`                  | `Operation \| Namespace \| Interface`               | `flag?: valueof boolean`, `scope?: valueof string`                            |
| `@client`                       | `Namespace \| Interface`                            | `options?: ClientOptions`, `scope?: valueof string`                           |
| `@operationGroup` (deprecated)  | `Namespace \| Interface`                            | `scope?: valueof string` — alias for `@client`                                |
| `@usage`                        | `Model \| Enum \| Union \| Namespace`               | `value: EnumMember \| Union`, `scope?: valueof string`                        |
| `@access`                       | `ModelProperty \| Model \| Operation \| ...`        | `value: EnumMember`, `scope?: valueof string`                                 |
| `@override`                     | `Operation`                                         | `override: Operation`, `scope?: valueof string`                               |
| `@flattenProperty`              | `ModelProperty`                                     | `scope?: valueof string`                                                      |
| `@alternateType`                | `ModelProperty \| Scalar \| Model \| Enum \| Union` | `alternate: unknown \| ExternalType`, `scope?: valueof string`                |
| `@clientInitialization`         | `Namespace \| Interface`                            | `options: ClientInitializationOptions`, `scope?: valueof string`              |
| `@paramAlias`                   | `ModelProperty`                                     | `paramAlias: valueof string`, `scope?: valueof string`                        |
| `@apiVersion`                   | `ModelProperty`                                     | `value?: valueof boolean`, `scope?: valueof string`                           |
| `@clientNamespace`              | `Namespace \| Interface \| Model \| Enum \| Union`  | `rename: valueof string`, `scope?: valueof string`                            |
| `@clientApiVersions`            | `Namespace`                                         | `value: Enum`, `scope?: valueof string`                                       |
| `@deserializeEmptyStringAsNull` | `ModelProperty`                                     | `scope?: valueof string`                                                      |
| `@responseAsBool`               | `Operation`                                         | `scope?: valueof string`                                                      |
| `@clientLocation`               | `Operation \| ModelProperty`                        | `target: Interface \| Namespace \| Operation \| (valueof string)`, `scope?`   |
| `@clientDoc`                    | `unknown`                                           | `documentation: valueof string`, `mode: EnumMember`, `scope?: valueof string` |
| `@scope`                        | `Operation \| ModelProperty`                        | `scope?: valueof string`                                                      |
| `@useSystemTextJsonConverter`   | `Model`                                             | `scope?: valueof string`                                                      |
| `@clientOption`                 | `unknown`                                           | `name: valueof string`, `value: valueof unknown`, `scope?: valueof string`    |

### Legacy Decorators (Azure.ClientGenerator.Core.Legacy)

| Decorator                | Signature Target | Key Parameters                                   |
| ------------------------ | ---------------- | ------------------------------------------------ |
| `@markAsLro`             | `Operation`      | `scope?: valueof string`                         |
| `@markAsPageable`        | `Operation`      | `scope?: valueof string`                         |
| `@disablePageable`       | `Operation`      | `scope?: valueof string`                         |
| `@nextLinkVerb`          | `Operation`      | `verb: valueof string`, `scope?: valueof string` |
| `@clientDefaultValue`    | `ModelProperty`  | `value: valueof ...`, `scope?: valueof string`   |
| `@hierarchyBuilding`     | `Model`          | `value: Model`, `scope?: valueof string`         |
| `@parameterizedNextLink` | `Operation`      | —                                                |

### Enums

- **Usage**: `input` (2), `output` (4), `json` (256), `xml` (512)
- **Access**: `public`, `internal`
- **InitializedBy**: `individually` (1), `parent` (2), `customizeCode` (4)
- **DocumentationMode**: `append`, `replace`

### Models

- **ClientOptions**: `service?: Namespace | Namespace[]`, `name?: string`, `autoMergeService?: boolean`
- **ClientInitializationOptions**: `parameters?: Model`, `initializedBy?: EnumMember | Union`
- **ExternalType**: `identity: string`, `package?: string`, `minVersion?: string`

## Feature-to-Doc Mapping

| Feature Area              | User Doc File                 | Guideline Section | Design Doc             |
| ------------------------- | ----------------------------- | ----------------- | ---------------------- |
| Client structure          | `03client.mdx`                | Client type graph | `client.md`            |
| Methods/operations        | `04method.mdx`                | Method types      | —                      |
| Paging                    | `05pagingOperations.mdx`      | —                 | —                      |
| Long-running operations   | `06longRunningOperations.mdx` | —                 | —                      |
| Multipart                 | `07multipart.mdx`             | —                 | —                      |
| Types (models/enums/etc.) | `08types.mdx`                 | Type graph        | —                      |
| Renaming                  | `09renaming.mdx`              | —                 | —                      |
| Versioning                | `10versioning.mdx`            | —                 | —                      |
| Hierarchy building        | `11hierarchyBuilding.mdx`     | —                 | —                      |
| Client options            | `12clientOptions.mdx`         | —                 | —                      |
| Package/namespace         | `02package.mdx`               | Package types     | —                      |
| Multiple services         | —                             | —                 | `multiple-services.md` |

## Doc Conventions

- User docs use `.mdx` extension in `website/src/content/docs/docs/howtos/Generate client libraries/`
- User docs use `<ClientTabs>` blocks with 6 language tabs: typespec, python, csharp, typescript, java, go
- All `<ClientTabs>` blocks must be produced by the @doc-example-generator skill
- Legacy/deprecated features use `:::caution` admonitions
- Guideline doc is plain `.md` at `website/src/content/docs/docs/libraries/typespec-client-generator-core/guideline.md`
- Design docs are plain `.md` at `packages/typespec-client-generator-core/design-docs/`

## Naming History

- `@moveTo` was renamed to `@clientLocation` — docs must use `@clientLocation`
- `@operationGroup` is deprecated in favor of `@client`

## Key Public Types (TCGC Type Graph)

### Package Level

- `SdkPackage` — top-level: `clients`, `models`, `enums`, `unions`, `namespaces`, `licenseInfo`
- `SdkNamespace` — namespace org: `clients`, `models`, `enums`, `unions`, `namespaces`

### Client Level

- `SdkClientType` — generated client: `name`, `namespace`, `clientInitialization`, `methods`, `apiVersions`, `parent`, `children`
- `SdkClientInitializationType` — init config: `parameters`, `initializedBy`

### Method Level

- `SdkBasicServiceMethod` — kind `"basic"`
- `SdkPagingServiceMethod` — kind `"paging"` with `SdkPagingServiceMetadata`
- `SdkLroServiceMethod` — kind `"lro"` with `SdkLroServiceMetadata`
- `SdkLroPagingServiceMethod` — kind `"lropaging"`
- `SdkMethodResponse` — `type`, `resultSegments`

### HTTP Level

- `SdkHttpOperation` — `path`, `verb`, `parameters`, `bodyParam`, `responses`, `exceptions`
- `SdkPathParameter`, `SdkQueryParameter`, `SdkHeaderParameter`, `SdkCookieParameter`
- `SdkBodyParameter` — `contentTypes`, `defaultContentType`

### Type Level

- `SdkModelType` — `properties`, `additionalProperties`, `discriminatorValue`, `baseModel`
- `SdkModelPropertyType` — `type`, `optional`, `flatten`, `onClient`, `serializationOptions`
- `SdkEnumType` — `values`, `isFixed`, `isFlags`, `valueType`
- `SdkUnionType` — `variantTypes`, `discriminatedOptions`
- `SdkArrayType` — `valueType`
- `SdkDictionaryType` — `keyType`, `valueType`
- `SdkBuiltInType` — primitives (string, int32, float64, boolean, etc.)
- `SdkDateTimeType` — `encode` (rfc3339, rfc7231, unixTimestamp)
- `SdkDurationType` — `encode`
- `SdkConstantType` — `value`, `valueType`
- `SdkNullableType` — wraps nullable types
- `SdkCredentialType` — auth scheme
- `SdkEndpointType` — server URL template

### Flags

- `UsageFlags` — `None`, `Input`, `Output`, `ApiVersionEnum`, `JsonMergePatch`, `MultipartFormData`, `Spread`, `Json`, `Xml`, `Exception`, `LroInitial`, `LroPolling`, `LroFinalEnvelope`, `External`
- `InitializedByFlags` — `Default`, `Individually`, `Parent`, `CustomizeCode`
- `AccessFlags` — `"public" | "internal"`

## Test File Paths

- Decorators: `packages/typespec-client-generator-core/test/decorators/`
- Types: `packages/typespec-client-generator-core/test/types/`
- Methods: `packages/typespec-client-generator-core/test/methods/`
- Clients: `packages/typespec-client-generator-core/test/clients/`
- HTTP: `packages/typespec-client-generator-core/test/http/`
- Package: `packages/typespec-client-generator-core/test/package/`
- Public utils: `packages/typespec-client-generator-core/test/public-utils/`
- Examples: `packages/typespec-client-generator-core/test/examples/`

## Spector Spec Coverage

### TCGC-specific specs (`packages/azure-http-specs/specs/azure/client-generator-core/`)

Covered: `access`, `alternate-type`, `api-version`, `client-default-value`, `client-initialization`, `client-location`, `deserialize-empty-string-as-null`, `flatten-property`, `hierarchy-building`, `next-link-verb`, `override`, `usage`

### Client structure specs (`packages/azure-http-specs/specs/client/`)

Covered: `namespace`, `naming`, `overload`, `structure` (client-operation-group, default, multi-client, renamed-operation, two-operation-group)

### Missing Spector specs

- `@scope` — no dedicated spec
- `@clientApiVersions` — no dedicated spec
- `@responseAsBool` — no dedicated spec
- `@clientDoc` — no dedicated spec
- `@clientOption` — no dedicated spec
- `@clientNamespace` — no dedicated spec
- `@clientName` — no dedicated spec (partial coverage in `client/naming`)

## Undocumented Features in User Docs

- `@scope` — not documented in any user-facing howto doc
- `@deserializeEmptyStringAsNull` — not documented in any user-facing howto doc
- `@responseAsBool` — only referenced in guideline.md, not in howto docs
- `@clientApiVersions` — not documented in any user-facing howto doc
