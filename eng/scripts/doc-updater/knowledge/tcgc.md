# TCGC Package Knowledge Base

## Package Overview

TypeSpec Client Generator Core (TCGC) introduces a client type graph and provides helper functions
for client emitters to generate client code without directly interacting with the TypeSpec core API.

- Package: `@azure-tools/typespec-client-generator-core`
- TypeSpec namespace: `Azure.ClientGenerator.Core` (core) and `Azure.ClientGenerator.Core.Legacy` (legacy)

---

## Decorators

### Core Namespace (`Azure.ClientGenerator.Core`)

All core decorators accept an optional `scope?: valueof string` parameter as last argument for
language-specific application. Valid scope identifiers: `csharp`, `python`, `java`, `javascript`, `go`.
Scope supports comma-separated lists (`"python, java"`), negation (`"!csharp"`), and combined patterns (`"!(java, python)"`).

#### `@clientName`

```typespec
extern dec clientName(target: unknown, rename: valueof string, scope?: valueof string);
```

Renames any TypeSpec entity (model, property, operation, parameter, enum, union) in generated client SDK.
Takes precedence over all other naming including `name` in `@client` and default naming conventions.
Augment form: `@@clientName`.

#### `@convenientAPI`

```typespec
extern dec convenientAPI(target: Operation | Namespace | Interface, flag?: valueof boolean, scope?: valueof string);
```

Controls whether a convenient (high-level) method is generated. Applied to namespace/interface, affects all
contained operations unless overridden. Default is context.generateConvenienceMethods.

#### `@protocolAPI`

```typespec
extern dec protocolAPI(target: Operation | Namespace | Interface, flag?: valueof boolean, scope?: valueof string);
```

Controls whether a low-level protocol method is generated. Applied to namespace/interface, affects all
contained operations unless overridden. Default is context.generateProtocolMethods.

#### `@client`

```typespec
extern dec client(target: Namespace | Interface, options?: ClientOptions, scope?: valueof string);
```

Defines an SDK client. Cannot be used with `@clientLocation`. Cannot be used as augmentation.
`ClientOptions` model: `{ service?: Namespace | Namespace[], name?: string, autoMergeService?: boolean }`.
Root explicit clients must have `service` set.

#### `@operationGroup` (DEPRECATED)

Alias for `@client`. Do not use in new code.

#### `@usage`

```typespec
extern dec usage(entity: Model | Enum | Union | Namespace, value: EnumMember | Union, scope?: valueof string);
```

Sets usage flags. Values: `Usage.Input`, `Usage.Output`, `Usage.Json`, `Usage.Xml`.
Can combine with `|`: `Usage.Input | Usage.Output`.
`UsageFlags` bitwise enum: None, Input, Output, ApiVersionEnum, JsonMergePatch, MultipartFormData, Spread, Json, Xml, Exception, LroInitial, LroPolling, LroFinalEnvelope, External.

#### `@access`

```typespec
extern dec access(entity: Model | Enum | Operation | Union | Namespace | ModelProperty, value: EnumMember, scope?: valueof string);
```

Sets access level: `Access.public` or `Access.internal`.

#### `@override`

```typespec
extern dec override(target: Operation, override: Operation, scope?: valueof string);
```

Overrides one operation with another. Parameter lists must be compatible.
Documented in: `04method.mdx` ("Customizing method signatures with `@override`").

#### `@useSystemTextJsonConverter`

```typespec
extern dec useSystemTextJsonConverter(target: Model, scope?: valueof string);
```

Enables .NET System.Text.Json converter for a model. C#-specific.

#### `@clientInitialization`

```typespec
extern dec clientInitialization(target: Namespace | Interface, options: ClientInitializationOptions, scope?: valueof string);
```

Sets client initialization configuration. `ClientInitializationOptions`: `{ initializedBy?: InitializedByFlags, parameters?: ModelProperty[] }`.
`InitializedByFlags`: Client, Individually, or both.
Augment form: `@@clientInitialization`.

#### `@paramAlias`

```typespec
extern dec paramAlias(target: ModelProperty, paramAlias: valueof string, scope?: valueof string);
```

Aliases a parameter name when elevated to client-level initialization parameter.
Documented in: `03client.mdx` (client initialization section).

#### `@clientNamespace`

```typespec
extern dec clientNamespace(entity: Namespace | Interface | Model | Enum | Union, value: string, scope?: valueof string);
```

Sets the SDK namespace for a type independent of TypeSpec namespace.
Augment form: `@@clientNamespace`.
Documented in: `02package.mdx`, `03client.mdx`.

#### `@alternateType`

```typespec
extern dec alternateType(source: ModelProperty | Scalar | Model | Enum | Union, alternate: Type, scope?: valueof string);
```

Replaces type with an external type. Commonly used to substitute with types from external packages.
Documented in: `08types.mdx`.

#### `@scope`

```typespec
extern dec scope(target: Operation | ModelProperty, scope?: valueof string);
```

Includes or excludes an operation or model property from specific language emitters.

#### `@apiVersion`

```typespec
extern dec apiVersion(target: ModelProperty, value?: valueof boolean, scope?: valueof string);
```

Marks a parameter as the API version parameter. Useful when the parameter name is not `api-version`.
Documented in: `10versioning.mdx`.

#### `@clientApiVersions`

```typespec
extern dec clientApiVersions(target: Namespace, value: Enum, scope?: valueof string);
```

Adds additional API versions for a client. Useful for merging multiple service API version enums.

#### `@deserializeEmptyStringAsNull`

```typespec
extern dec deserializeEmptyStringAsNull(target: ModelProperty, scope?: valueof string);
```

Treats empty strings as null during deserialization. Only valid on string properties.

#### `@responseAsBool`

```typespec
extern dec responseAsBool(target: Operation, scope?: valueof string);
```

Converts a `@head` operation response to a boolean return type. Only valid on `@head` operations.

#### `@clientLocation`

```typespec
extern dec clientLocation(
  source: Operation | ModelProperty,
  target: Interface | Namespace | Operation | string,
  scope?: valueof string
);
```

Moves operations or model properties to a different location in the client hierarchy.
Cannot be used together with `@client` for the same operation (they conflict).
Augment form: `@@clientLocation`.
Documented in: `03client.mdx`.

#### `@clientDoc`

```typespec
extern dec clientDoc(target: Type, documentation: string, mode: EnumMember, scope?: valueof string);
```

Sets client-level documentation. `mode`: `DocMode.append` or `DocMode.replace`.
Documented in: `08types.mdx`.

#### `@clientOption`

```typespec
extern dec clientOption(target: Type, name: string, value: unknown, scope?: valueof string);
```

**Experimental.** Sets custom client options for emitters. `scope` is required (warning generated if omitted).
Known option: `omitSlashFromEmptyRoute` (boolean) — omits slash from empty route paths.
Documented in: `12clientOptions.mdx`.

---

### Legacy Namespace (`Azure.ClientGenerator.Core.Legacy`)

All legacy decorators must be referenced with the full namespace prefix `@Azure.ClientGenerator.Core.Legacy.<name>`
in TypeSpec examples, unless the spec includes `using Azure.ClientGenerator.Core.Legacy;`.

#### `@Azure.ClientGenerator.Core.Legacy.hierarchyBuilding`

```typespec
extern dec hierarchyBuilding(target: Model, value: Model, scope?: valueof string);
```

Enables multi-level inheritance for discriminated models. **NOT RECOMMENDED** — only use when explicitly
requested by SDK architects. Requires `enableLegacyHierarchyBuilding` configuration.
Documented in: `08types.mdx` (Multi-Level Inheritance section), `11hierarchyBuilding.mdx`.

#### `@Azure.ClientGenerator.Core.Legacy.flattenProperty`

```typespec
extern dec flattenProperty(target: ModelProperty, scope?: valueof string);
```

Marks a model property for flattening in generated clients. **NOT RECOMMENDED** for new services.
In Java, has no effect.
TypeSpec examples must use full namespace: `@Azure.ClientGenerator.Core.Legacy.flattenProperty`.
Documented in: `08types.mdx` (Flattening section).

#### `@Azure.ClientGenerator.Core.Legacy.markAsLro`

```typespec
extern dec markAsLro(target: Operation, scope?: valueof string);
```

Forces an operation to be treated as a Long-Running Operation. **Legacy** — only use when standard LRO
patterns are not feasible. Requires verification and testing of generated code.

#### `@Azure.ClientGenerator.Core.Legacy.markAsPageable`

```typespec
extern dec markAsPageable(target: Operation, scope?: valueof string);
```

Forces an operation to be treated as pageable. **Legacy** — only use when standard paging patterns are not feasible.

#### `@Azure.ClientGenerator.Core.Legacy.disablePageable`

```typespec
extern dec disablePageable(target: Operation, scope?: valueof string);
```

Prevents an operation from being treated as pageable, even when it follows standard paging patterns (e.g., `@list`).
The response will be the paged model itself rather than list items.

#### `@Azure.ClientGenerator.Core.Legacy.nextLinkVerb`

```typespec
extern dec nextLinkVerb(target: Operation, verb: "GET" | "POST", scope?: valueof string);
```

Specifies HTTP verb for the next link operation in paging. Only `"GET"` and `"POST"` are supported.
**Legacy** — use only when standard paging patterns are insufficient.

#### `@Azure.ClientGenerator.Core.Legacy.clientDefaultValue`

```typespec
extern dec clientDefaultValue(target: ModelProperty, value: string | boolean | Numeric, scope?: valueof string);
```

Sets a client-level default value for a model property or operation parameter. **Legacy** — only for
maintaining backward compatibility in existing brownfield services. New services should use standard
TypeSpec default values.
TypeSpec examples must use full namespace: `@Azure.ClientGenerator.Core.Legacy.clientDefaultValue(value)`.
Documented in: `08types.mdx`.

---

## Public Types

### Core Context Types

#### `TCGCContext`

Main context for code generation.

- `program`: TypeSpec program
- `diagnostics`: Diagnostic[]
- `emitterName`: string
- `arm`: boolean — is this an ARM service
- `generateProtocolMethods`: boolean
- `generateConvenienceMethods`: boolean
- `apiVersion`: string | undefined
- `license`: LicenseInfo | undefined
- `decoratorsAllowList`: string[] | undefined

#### `SdkContext<TOptions, TServiceOperation>`

Extends `TCGCContext` with emitter context.

- `emitContext`: EmitContext
- `sdkPackage`: SdkPackage

### Client Types

#### `SdkClientType<TServiceOperation>`

- `kind: "client"`
- `name`: string
- `namespace`: string
- `clientInitialization`: SdkClientInitializationType
- `methods`: SdkMethod[]
- `apiVersions`: string[]
- `crossLanguageDefinitionId`: string
- `parent?`: SdkClientType
- `children?`: SdkClientType[]

#### `SdkClientInitializationType`

- `kind: "clientinitialization"`
- `parameters`: SdkParameter[]
- `initializedBy`: InitializedByFlags

### Type System

#### `SdkType` (Union)

`SdkBuiltInType | SdkDateTimeType | SdkDurationType | SdkArrayType | SdkTupleType | SdkDictionaryType | SdkNullableType | SdkEnumType | SdkConstantType | SdkUnionType | SdkModelType`

#### `SdkBuiltInType` kinds

`numeric, integer, safeint, int8, int16, int32, int64, uint8, uint16, uint32, uint64, float, float32, float64, decimal, decimal128, string, url, bytes, boolean, plainDate, plainTime, unknown`

#### `SdkModelType`

- `kind: "model"`
- `name`, `isGeneratedName`, `namespace`
- `access`: AccessFlags
- `usage`: UsageFlags
- `properties`: SdkModelPropertyType[]
- `additionalProperties?`
- `discriminatorValue?`, `discriminatedSubtypes?`, `discriminatorProperty?`
- `baseModel?`
- `crossLanguageDefinitionId`, `apiVersions`
- `serializationOptions`

#### `SdkEnumType`

- `kind: "enum"`
- `enumValues`: SdkEnumValueType[]
- `knownValues?` — for extensible enums
- `access`, `usage`

### Method Types

#### `SdkBasicServiceMethod` / `SdkPagingServiceMethod` / `SdkLroServiceMethod` / `SdkLroPagingServiceMethod`

- `kind: "basic" | "paging" | "lro" | "lropaging"`
- `generateConvenient`, `generateProtocol`
- `operation`: TServiceOperation
- `parameters`: SdkMethodParameter[]
- `response`: SdkMethodResponse

#### `SdkHttpOperation`

- `kind: "http"`
- `path`, `uriTemplate`
- `verb`: HttpVerb
- `parameters`, `bodyParam?`
- `responses`, `exceptions`

### Package Types

#### `SdkPackage<TServiceOperation>`

- `clients`: SdkClientType[]
- `models`: SdkModelType[]
- `enums`: SdkEnumType[]
- `unions`: (SdkUnionType | SdkNullableType)[]
- `crossLanguagePackageId`, `crossLanguageVersion`
- `namespaces`: SdkNamespace[]
- `licenseInfo?`

### Flag Enums

#### `UsageFlags` (bitwise)

`None, Input, Output, ApiVersionEnum, JsonMergePatch, MultipartFormData, Spread, Json, Xml, Exception, LroInitial, LroPolling, LroFinalEnvelope, External`

#### `AccessFlags`

`"internal" | "public"`

---

## Feature Areas and Documentation Mapping

| Feature | Documentation File | Key Decorators |
|---|---|---|
| Client generation overview | `00howtogen.mdx` | `@service` |
| SDK customization setup | `01setup.mdx` | `using Azure.ClientGenerator.Core` |
| Package/namespace configuration | `02package.mdx` | `@clientNamespace`, `@service` |
| Client hierarchy | `03client.mdx` | `@client`, `@clientLocation`, `@clientName`, `@clientNamespace`, `@clientInitialization`, `@paramAlias` |
| Method customization | `04method.mdx` | `@protocolAPI`, `@convenientAPI`, `@access`, `@usage`, `@override`, `@clientLocation` |
| Paging operations | `05pagingOperations.mdx` | `@list`, `@pageItems`, `@nextLink`, `@continuationToken` |
| Long-running operations | `06longRunningOperations.mdx` | `@pollingOperation`, Azure.Core LRO templates |
| Multipart | `07multipart.mdx` | `@multipartBody`, `HttpPart<T>` |
| Types and models | `08types.mdx` | `@clientNamespace`, `@clientDoc`, `@alternateType`, `@Azure.ClientGenerator.Core.Legacy.clientDefaultValue`, `@Azure.ClientGenerator.Core.Legacy.flattenProperty`, `@Azure.ClientGenerator.Core.Legacy.hierarchyBuilding` |
| Renaming | `09renaming.mdx` | `@clientName`, `@@clientName` |
| API versioning | `10versioning.mdx` | `@versioned`, `@added`, `@removed`, `@apiVersion` |
| Legacy hierarchy building | `11hierarchyBuilding.mdx` | `@Azure.ClientGenerator.Core.Legacy.hierarchyBuilding` |
| Client options | `12clientOptions.mdx` | `@clientOption` |
| Emitter developer guide | `guideline.md` | SDK type graph, `listClients()`, `createSdkContext()` |

---

## Doc Conventions

### Formatting Rules

1. **`<ClientTabs>` blocks** — every code example must use `<ClientTabs>` with six language tabs: `typespec`, `python`, `csharp`, `typescript`, `java`, `go`. If a language is not supported, use `// NOT_SUPPORTED`.
2. **All `<ClientTabs>` blocks MUST be generated by the `@doc-example-generator` skill** — never hand-write language tab code.
3. **Legacy decorators** — wrap in `:::caution` admonition with warning that the feature is not recommended for new services.
4. **TypeSpec examples** — use full namespace for legacy decorators (`@Azure.ClientGenerator.Core.Legacy.flattenProperty`), not just short names.
5. **Customization files** — code examples for user customizations should appear in a `client.tsp` file alongside a `main.tsp`.

### Decorator Reference Conventions

- Inline decorator references: backtick wrapped, e.g. `` `@clientName` ``
- Legacy decorators referenced in prose: use full namespace, e.g. `` `@Azure.ClientGenerator.Core.Legacy.flattenProperty` ``

---

## Cross-Reference Notes

- **`@client` vs `@clientLocation`**: These cannot both be applied to the same operation; `@clientLocation` cannot move clients that no longer exist after `@client` restructuring.
- **Paging decorators** (`@list`, `@pageItems`, `@nextLink`, `@continuationToken`) come from `@typespec/http` or `Azure.Core`, not TCGC. TCGC reads them to produce `SdkPagingServiceMethod`.
- **LRO decorators** (`@pollingOperation`, `@finalOperation`, etc.) come from `Azure.Core`. TCGC reads them to produce `SdkLroServiceMethod`.
- **`@flattenProperty`** is in `Azure.ClientGenerator.Core.Legacy` namespace.
- **`@markAsLro`, `@markAsPageable`, `@disablePageable`, `@nextLinkVerb`** are all in `Azure.ClientGenerator.Core.Legacy` namespace.
- **`@clientDefaultValue`** is in `Azure.ClientGenerator.Core.Legacy` namespace.

---

## Test File Index

Key test files for TCGC features:

- Decorators: `test/decorators/*.test.ts` (29 files)
- Types: `test/types/*.test.ts` (17 files)
- Methods: `test/methods/*.test.ts` (7 files)
- Clients: `test/clients/*.test.ts` (2 files)
- Package: `test/package/*.test.ts` (8 files)
- Functions (parameter manipulation): `test/functions/*.test.ts` (4 files)
- HTTP: `test/http/*.test.ts` (3 files)
- Public utils: `test/public-utils/*.test.ts` (12 files)

Notable test files for specific features:
- Client hierarchy: `test/decorators/client.test.ts`, `test/clients/structure.test.ts`
- Client initialization: `test/decorators/client-initialization.test.ts`
- Paging: `test/methods/paged-operation.test.ts`, `test/decorators/mark-as-pageable.test.ts`
- LRO: `test/methods/lro.test.ts`, `test/decorators/mark-as-lro.test.ts`
- Legacy hierarchy: `test/decorators/legacy-hierarchy-building.test.ts`
- Flatten property: included in `test/types/model.test.ts`
