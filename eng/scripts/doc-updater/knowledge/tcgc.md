# TCGC (TypeSpec Client Generator Core) — Package Knowledge Base

> **Package:** `@azure-tools/typespec-client-generator-core`
> **TypeSpec namespace:** `Azure.ClientGenerator.Core`
> **Legacy namespace:** `Azure.ClientGenerator.Core.Legacy`

---

## 1. Source Code Layout

| Path                                                   | Purpose                                |
| ------------------------------------------------------ | -------------------------------------- |
| `packages/typespec-client-generator-core/src/`         | TypeScript implementation              |
| `packages/typespec-client-generator-core/lib/`         | TypeSpec library declarations (`.tsp`) |
| `packages/typespec-client-generator-core/test/`        | Unit tests (vitest)                    |
| `packages/typespec-client-generator-core/design-docs/` | Design documents                       |

### Key source files

| File                | Contains                                                                                               |
| ------------------- | ------------------------------------------------------------------------------------------------------ |
| `interfaces.ts`     | All public TypeScript types/interfaces for the TCGC type graph                                         |
| `decorators.ts`     | Decorator JS implementations + helper getter/setter functions                                          |
| `public-utils.ts`   | Public utility functions (naming, API version, cross-language IDs, etc.)                               |
| `types.ts`          | Type creation/resolution (models, enums, unions, scalars → Sdk\* types)                                |
| `clients.ts`        | Client discovery and structure creation                                                                |
| `methods.ts`        | Method generation (basic, paging, LRO, LRO+paging)                                                     |
| `http.ts`           | HTTP-specific parameter/response handling                                                              |
| `context.ts`        | `createTCGCContext`, `createSdkContext`, `$onEmit`                                                     |
| `package.ts`        | `createSdkPackage` — builds the full `SdkPackage` from context                                         |
| `configs.ts`        | Default decorator allow-list                                                                           |
| `lib.ts`            | Library definition, emitter options schema, diagnostic codes                                           |
| `linter.ts`         | Linter rule definitions and rule sets                                                                  |
| `validate.ts`       | `$onValidate` entry point for validation                                                               |
| `example.ts`        | Example file loading and mapping                                                                       |
| `license.ts`        | License configuration resolution                                                                       |
| `media-types.ts`    | Content type / media type utilities                                                                    |
| `cache.ts`          | Client and operation group caching                                                                     |
| `internal-utils.ts` | Internal helpers (not exported publicly)                                                               |
| `index.ts`          | Package entry point — re-exports `context`, `decorators`, `interfaces`, `lib`, `public-utils`, `types` |
| `tsp-index.ts`      | TypeSpec decorator bindings (internal)                                                                 |

### TypeSpec library files (`lib/`)

| File              | Contains                                                    |
| ----------------- | ----------------------------------------------------------- |
| `main.tsp`        | Imports `decorators.tsp`, `augmentCore.tsp`, `legacy.tsp`   |
| `decorators.tsp`  | All decorator declarations + model/enum definitions         |
| `legacy.tsp`      | Legacy decorators under `Azure.ClientGenerator.Core.Legacy` |
| `augmentCore.tsp` | Empty file (placeholder for core augmentations)             |

---

## 2. Decorators

### 2.1 Main Decorators (`Azure.ClientGenerator.Core`)

All decorators accept an optional `scope?: valueof string` parameter for language-specific targeting.
Scope syntax: `"python"`, `"python, java"`, `"!csharp"`, `"!(java, python)"`.

#### `@clientName`

```typespec
extern dec clientName(target: unknown, rename: valueof string, scope?: valueof string);
```

Overrides generated name for any SDK element (clients, methods, parameters, models, enums, properties, unions). Takes highest priority over all other naming mechanisms.

#### `@client`

```typespec
extern dec client(target: Namespace | Interface, options?: ClientOptions, scope?: valueof string);
```

Defines a root client. Cannot be used with `@clientLocation`. Cannot be used as augmentation.

```typespec
model ClientOptions {
  service?: Namespace | Namespace[];
  name?: string;
}
```

#### `@operationGroup`

```typespec
extern dec operationGroup(target: Namespace | Interface, scope?: valueof string);
```

Defines a sub-client (operation group). Cannot be used with `@clientLocation`. Cannot be used as augmentation.

#### `@convenientAPI`

```typespec
extern dec convenientAPI(target: Operation | Namespace | Interface, flag?: valueof boolean, scope?: valueof string);
```

Controls whether convenience methods are generated. When applied to namespace/interface, affects all operations within unless overridden.

#### `@protocolAPI`

```typespec
extern dec protocolAPI(target: Operation | Namespace | Interface, flag?: valueof boolean, scope?: valueof string);
```

Controls whether protocol (low-level) methods are generated. When applied to namespace/interface, affects all operations within unless overridden.

#### `@usage`

```typespec
extern dec usage(target: Model | Enum | Union | Namespace, value: EnumMember | Union, scope?: valueof string);
```

Adds additional usage info. Usage propagates to properties, parent models, discriminated sub-models.

```typespec
enum Usage {
  input: 2,
  output: 4,
  json: 256,
  xml: 512,
}
```

#### `@access`

```typespec
extern dec access(target: ModelProperty | Model | Operation | Enum | Union | Namespace, value: EnumMember, scope?: valueof string);
```

Overrides access (visibility). Setting access on an operation influences models used by that operation. Access propagates to properties, parent models, discriminated sub-models.

```typespec
enum Access {
  public: "public",
  internal: "internal",
}
```

#### `@override`

```typespec
extern dec override(target: Operation, override: Operation, scope?: valueof string);
```

Customizes a method's parameter signature in the generated SDK. Used as augment decorator (`@@override`).

#### `@clientInitialization`

```typespec
extern dec clientInitialization(target: Namespace | Interface, options: ClientInitializationOptions, scope?: valueof string);
```

Customizes how clients are initialized. Elevates operation-level parameters to client-level. Used as augment decorator (`@@clientInitialization`).

```typespec
model ClientInitializationOptions {
  parameters?: Model;
  initializedBy?: EnumMember | Union;
}
```

```typespec
enum InitializedBy {
  individually: 1,
  parent: 2,
  customizeCode: 4,
}
```

#### `@paramAlias`

```typespec
extern dec paramAlias(target: ModelProperty, paramAlias: valueof string, scope?: valueof string);
```

Aliases a client parameter name. Used with `@clientInitialization` to rename elevated parameters. Used as augment decorator (`@@paramAlias`).

#### `@clientNamespace`

```typespec
extern dec clientNamespace(target: Namespace | Interface | Model | Enum | Union, rename: valueof string, scope?: valueof string);
```

Changes the namespace of a generated type in the client SDK.

#### `@alternateType`

```typespec
extern dec alternateType(target: ModelProperty | Scalar | Model | Enum | Union, alternate: unknown | ExternalType, scope?: valueof string);
```

Sets an alternate type for SDK generation. When source is `Scalar`, alternate must also be `Scalar`. External types (with `identity` property) cannot be applied to model properties.

```typespec
model ExternalType {
  identity: string;
  package?: string;
  minVersion?: string;
}
```

#### `@scope`

```typespec
extern dec scope(target: Operation | ModelProperty, scope?: valueof string);
```

Scopes an operation or property to specific languages. Omits the element from languages not in scope.

#### `@apiVersion`

```typespec
extern dec apiVersion(target: ModelProperty, value?: valueof boolean, scope?: valueof string);
```

Explicitly marks (or un-marks) a parameter as an API version parameter. By default, TCGC detects by matching name patterns (`api-version`, `apiversion`) or `@versioned` enum reference.

#### `@clientApiVersions`

```typespec
extern dec clientApiVersions(target: Namespace, value: Enum, scope?: valueof string);
```

Adds additional API versions beyond those from `@versioned`. The enum should spread the service's version enum.

#### `@deserializeEmptyStringAsNull`

```typespec
extern dec deserializeEmptyStringAsNull(target: ModelProperty, scope?: valueof string);
```

Indicates empty strings (`""`) should deserialize as `null`. Only valid on `string` or `string`-derived scalar properties.

#### `@responseAsBool`

```typespec
extern dec responseAsBool(target: Operation, scope?: valueof string);
```

For HEAD operations: models response as `bool`. 404 returns `false`, 2xx returns `true`, other codes raise errors.

#### `@useSystemTextJsonConverter`

```typespec
extern dec useSystemTextJsonConverter(target: Model, scope?: valueof string);
```

Indicates a model needs a custom JSON converter. Primarily for backward compatibility in C#.

#### `@clientLocation`

```typespec
extern dec clientLocation(source: Operation | ModelProperty, target: Interface | Namespace | Operation | (valueof string), scope?: valueof string);
```

Moves an operation to a different client, or moves a parameter between operation and client levels. Cannot be used with `@client`/`@operationGroup`. Supports:

- Moving operation to existing sub-client (target = Interface/Namespace)
- Moving operation to new sub-client (target = string name)
- Moving operation to root client (target = service Namespace)
- Moving parameter from operation to client (target = client Namespace/Interface)
- Moving parameter from client to operation (target = Operation)

#### `@clientDoc`

```typespec
extern dec clientDoc(target: unknown, documentation: valueof string, mode: EnumMember, scope?: valueof string);
```

Overrides documentation for client libraries with append or replace modes.

```typespec
enum DocumentationMode {
  append: "append",
  replace: "replace",
}
```

#### `@clientOption`

```typespec
extern dec clientOption(target: unknown, name: valueof string, value: valueof unknown, scope?: valueof string);
```

Passes experimental flags/options to emitters. Always emits a warning that must be suppressed. Intended for temporary workarounds.

### 2.2 Legacy Decorators (`Azure.ClientGenerator.Core.Legacy`)

These decorators live in the `Azure.ClientGenerator.Core.Legacy` namespace and are considered legacy. They should be documented with caution admonitions.

#### `@flattenProperty`

```typespec
extern dec flattenProperty(target: ModelProperty, scope?: valueof string);
```

Marks a model property for flattening. Not recommended for greenfield services.

#### `@hierarchyBuilding`

```typespec
extern dec hierarchyBuilding(target: Model, value: Model, scope?: valueof string);
```

Adds multi-level inheritance support for discriminated models. Enables scenarios where TypeSpec's single-level extends is insufficient.

#### `@markAsLro`

```typespec
extern dec markAsLro(target: Operation, scope?: valueof string);
```

Forces an operation to be treated as a Long Running Operation even when not truly long-running on the service side.

#### `@markAsPageable`

```typespec
extern dec markAsPageable(target: Operation, scope?: valueof string);
```

Forces an operation to be treated as pageable even without standard paging patterns.

#### `@disablePageable`

```typespec
extern dec disablePageable(target: Operation, scope?: valueof string);
```

Prevents a paging operation (e.g. decorated with `@list`) from being treated as pageable. The response is the paged model itself.

#### `@nextLinkVerb`

```typespec
extern dec nextLinkVerb(target: Operation, verb: "GET" | "POST", scope?: valueof string);
```

Specifies the HTTP verb for next link operations in paging. Defaults to GET.

#### `@clientDefaultValue`

```typespec
extern dec clientDefaultValue(target: ModelProperty, value: valueof string | boolean | numeric, scope?: valueof string);
```

Sets a client-level default value for a property/parameter. For brownfield backward compatibility.

---

## 3. Public Types (Type Graph)

### 3.1 Context Types

#### `TCGCContext`

Core context passed throughout TCGC. Key properties:

```typescript
interface TCGCContext {
  program: Program;
  diagnostics: readonly Diagnostic[];
  emitterName: string;
  arm?: boolean;
  generateProtocolMethods?: boolean;
  generateConvenienceMethods?: boolean;
  examplesDir?: string;
  namespaceFlag?: string;
  apiVersion?: string;
  license?: {
    name: string;
    company?: string;
    header?: string;
    link?: string;
    description?: string;
  };
  decoratorsAllowList?: string[];
  previewStringRegex: RegExp;
  disableUsageAccessPropagationToBase: boolean;
  flattenUnionAsEnum?: boolean;
  enableLegacyHierarchyBuilding?: boolean;

  // Methods
  getMutatedGlobalNamespace(): Namespace;
  getApiVersionsForType(type: Type): string[];
  setApiVersionsForType(type: Type, apiVersions: string[]): void;
  getPackageVersions(): Map<Namespace, string[]>;
  getPackageVersionEnum(): Map<Namespace, Enum | undefined>;
  getClients(): SdkClient[];
  getClientOrOperationGroup(
    type: Namespace | Interface,
  ): SdkClient | SdkOperationGroup | undefined;
  getOperationsForClient(client: SdkClient | SdkOperationGroup): Operation[];
  getClientForOperation(operation: Operation): SdkClient | SdkOperationGroup;
}
```

#### `SdkContext<TOptions, TServiceOperation>`

Extends `TCGCContext` with emit context and the complete SDK package:

```typescript
interface SdkContext<TOptions, TServiceOperation> extends TCGCContext {
  emitContext: EmitContext<TOptions>;
  sdkPackage: SdkPackage<TServiceOperation>;
}
```

### 3.2 Client Structure Types

#### `SdkClient`

Raw client representation (before full type graph resolution):

```typescript
interface SdkClient {
  kind: "SdkClient";
  name: string;
  service: Namespace | Namespace[]; // @deprecated — use `services`
  services: Namespace[];
  type: Namespace | Interface;
  subOperationGroups: SdkOperationGroup[];
}
```

#### `SdkOperationGroup`

Raw operation group (sub-client) representation:

```typescript
interface SdkOperationGroup {
  kind: "SdkOperationGroup";
  type?: Namespace | Interface;
  subOperationGroups: SdkOperationGroup[];
  groupPath: string;
  service: Namespace; // @deprecated — use `services`
  services: Namespace[];
  parent?: SdkClient | SdkOperationGroup;
}
```

#### `SdkClientType<TServiceOperation>`

Full resolved client in the type graph:

```typescript
interface SdkClientType<TServiceOperation> extends DecoratedType {
  __raw: SdkClient | SdkOperationGroup;
  kind: "client";
  name: string;
  namespace: string;
  doc?: string;
  summary?: string;
  clientInitialization: SdkClientInitializationType;
  methods: SdkMethod<TServiceOperation>[];
  apiVersions: string[];
  crossLanguageDefinitionId: string;
  parent?: SdkClientType<TServiceOperation>;
  children?: SdkClientType<TServiceOperation>[];
}
```

#### `SdkClientInitializationType`

```typescript
interface SdkClientInitializationType extends SdkTypeBase {
  kind: "clientinitialization";
  name: string;
  isGeneratedName: boolean;
  parameters: (
    | SdkEndpointParameter
    | SdkCredentialParameter
    | SdkMethodParameter
  )[];
  initializedBy: InitializedByFlags;
}
```

#### `InitializedByFlags`

```typescript
enum InitializedByFlags {
  Default = 0, // No user-specific setting (sub-clients default)
  Individually = 1, // Client initialized independently
  Parent = 2, // Client initialized by parent
  CustomizeCode = 4, // Initialization omitted from generated code
}
```

### 3.3 Package Type

#### `SdkPackage<TServiceOperation>`

Top-level output from TCGC:

```typescript
interface SdkPackage<TServiceOperation> {
  clients: SdkClientType<TServiceOperation>[];
  models: SdkModelType[];
  enums: SdkEnumType[];
  unions: (SdkUnionType | SdkNullableType)[];
  crossLanguagePackageId: string;
  namespaces: SdkNamespace<TServiceOperation>[];
  licenseInfo?: LicenseInfo;
  metadata: {
    apiVersion?: string; // @deprecated — use `apiVersions`
    apiVersions?: Map<string, string>;
  };
}
```

#### `SdkNamespace<TServiceOperation>`

```typescript
interface SdkNamespace<TServiceOperation> extends DecoratedType {
  __raw?: Namespace;
  name: string;
  fullName: string;
  clients: SdkClientType<TServiceOperation>[];
  models: SdkModelType[];
  enums: SdkEnumType[];
  unions: (SdkUnionType | SdkNullableType)[];
  namespaces: SdkNamespace<TServiceOperation>[];
}
```

#### `LicenseInfo`

```typescript
interface LicenseInfo {
  name: string;
  company: string;
  link: string;
  header: string;
  description: string;
}
```

### 3.4 SDK Types (the `SdkType` union)

```typescript
type SdkType =
  | SdkBuiltInType
  | SdkDateTimeType
  | SdkDurationType
  | SdkArrayType
  | SdkTupleType
  | SdkDictionaryType
  | SdkNullableType
  | SdkEnumType
  | SdkEnumValueType
  | SdkConstantType
  | SdkUnionType
  | SdkModelType
  | SdkCredentialType
  | SdkEndpointType;
```

#### `SdkBuiltInType`

```typescript
interface SdkBuiltInType<TKind extends SdkBuiltInKinds> extends SdkTypeBase {
  kind: TKind; // "string" | "int32" | "float64" | "boolean" | "bytes" | "url" | "plainDate" | "plainTime" | "unknown" | ...
  encode?: string;
  name: string;
  baseType?: SdkBuiltInType<TKind>;
  crossLanguageDefinitionId: string;
}
```

Built-in kind values: `numeric`, `integer`, `safeint`, `int8`, `int16`, `int32`, `int64`, `uint8`, `uint16`, `uint32`, `uint64`, `float`, `float32`, `float64`, `decimal`, `decimal128`, `string`, `url`, `bytes`, `boolean`, `plainDate`, `plainTime`, `unknown`.

#### `SdkDateTimeType`

```typescript
type SdkDateTimeType = SdkUtcDateTimeType | SdkOffsetDateTimeType;
// kind: "utcDateTime" | "offsetDateTime"
// encode: DateTimeKnownEncoding | string  (e.g. "rfc3339", "rfc7231", "unixTimestamp")
// wireType: SdkBuiltInType
```

#### `SdkDurationType`

```typescript
interface SdkDurationType {
  kind: "duration";
  encode: DurationKnownEncoding | string;
  wireType: SdkBuiltInType;
}
```

#### `SdkArrayType`

```typescript
interface SdkArrayType {
  kind: "array";
  name: string;
  valueType: SdkType;
  crossLanguageDefinitionId: string;
}
```

#### `SdkTupleType`

```typescript
interface SdkTupleType {
  kind: "tuple";
  valueTypes: SdkType[];
}
```

#### `SdkDictionaryType`

```typescript
interface SdkDictionaryType {
  kind: "dict";
  keyType: SdkType;
  valueType: SdkType;
}
```

#### `SdkNullableType`

```typescript
interface SdkNullableType {
  kind: "nullable";
  name: string;
  isGeneratedName: boolean;
  crossLanguageDefinitionId: string;
  type: SdkType;
  usage: UsageFlags;
  access: AccessFlags;
  namespace: string;
}
```

#### `SdkEnumType`

```typescript
interface SdkEnumType {
  kind: "enum";
  name: string;
  isGeneratedName: boolean;
  namespace: string;
  valueType: SdkBuiltInType;
  values: SdkEnumValueType[];
  isFixed: boolean;
  isFlags: boolean;
  usage: UsageFlags;
  access: AccessFlags;
  crossLanguageDefinitionId: string;
  apiVersions: string[];
  isUnionAsEnum: boolean;
}
```

#### `SdkEnumValueType`

```typescript
interface SdkEnumValueType {
  kind: "enumvalue";
  name: string;
  value: string | number;
  enumType: SdkEnumType;
  valueType: SdkBuiltInType;
  crossLanguageDefinitionId: string;
}
```

#### `SdkConstantType`

```typescript
interface SdkConstantType {
  kind: "constant";
  value: string | number | boolean;
  valueType: SdkBuiltInType;
  name: string;
  isGeneratedName: boolean;
}
```

#### `SdkUnionType`

```typescript
interface SdkUnionType<TValueType = SdkType> {
  kind: "union";
  name: string;
  isGeneratedName: boolean;
  namespace: string;
  variantTypes: TValueType[];
  crossLanguageDefinitionId: string;
  access: AccessFlags;
  usage: UsageFlags;
  discriminatedOptions?: DiscriminatedOptions;
}

interface DiscriminatedOptions {
  envelope: "object" | "none";
  discriminatorPropertyName: string;
  envelopePropertyName?: string;
}
```

#### `SdkModelType`

```typescript
interface SdkModelType {
  kind: "model";
  properties: SdkModelPropertyType[];
  name: string;
  isGeneratedName: boolean;
  namespace: string;
  access: AccessFlags;
  usage: UsageFlags;
  additionalProperties?: SdkType;
  discriminatorValue?: string;
  discriminatedSubtypes?: Record<string, SdkModelType>;
  discriminatorProperty?: SdkModelPropertyType;
  baseModel?: SdkModelType;
  crossLanguageDefinitionId: string;
  apiVersions: string[];
  serializationOptions: SerializationOptions;
}
```

#### `SdkCredentialType`

```typescript
interface SdkCredentialType {
  kind: "credential";
  scheme: HttpAuth;
}
```

#### `SdkEndpointType`

```typescript
interface SdkEndpointType {
  kind: "endpoint";
  serverUrl: string; // e.g. "{endpoint}" or "https://example.com"
  templateArguments: SdkPathParameter[];
}
```

### 3.5 Property Types

#### Common base: `SdkModelPropertyTypeBase`

All properties share these fields:

```typescript
interface SdkModelPropertyTypeBase<TType = SdkType> extends DecoratedType {
  __raw?: ModelProperty;
  type: TType;
  name: string;
  isGeneratedName: boolean;
  doc?: string;
  summary?: string;
  apiVersions: string[];
  onClient: boolean;
  clientDefaultValue?: unknown;
  isApiVersionParam: boolean;
  optional: boolean;
  crossLanguageDefinitionId: string;
  visibility?: Visibility[];
  access: AccessFlags;
  flatten: boolean;
  encode?: ArrayKnownEncoding; // "pipeDelimited" | "spaceDelimited" | "commaDelimited" | "newlineDelimited"
}
```

#### `SdkModelPropertyType` (kind: `"property"`)

```typescript
interface SdkModelPropertyType extends SdkModelPropertyTypeBase {
  kind: "property";
  discriminator: boolean;
  serializedName: string; // @deprecated — use serializationOptions.xxx.name
  serializationOptions: SerializationOptions;
  isMultipartFileInput: boolean; // @deprecated — use multipartOptions?.isFilePart
  multipartOptions?: MultipartOptions; // @deprecated — use serializationOptions.multipart
}
```

#### `SdkEndpointParameter` (kind: `"endpoint"`)

```typescript
interface SdkEndpointParameter extends SdkModelPropertyTypeBase<
  SdkEndpointType | SdkUnionType<SdkEndpointType>
> {
  kind: "endpoint";
  urlEncode: boolean;
  onClient: true;
  serializedName?: string; // @deprecated
}
```

#### `SdkCredentialParameter` (kind: `"credential"`)

```typescript
interface SdkCredentialParameter extends SdkModelPropertyTypeBase<
  SdkCredentialType | SdkUnionType<SdkCredentialType>
> {
  kind: "credential";
  onClient: true;
}
```

#### `SdkMethodParameter` (kind: `"method"`)

```typescript
interface SdkMethodParameter extends SdkModelPropertyTypeBase {
  kind: "method";
}
```

### 3.6 HTTP Parameter Types

All HTTP parameters have `serializedName`, `correspondingMethodParams` (deprecated), and `methodParameterSegments`.

#### `SdkHeaderParameter` (kind: `"header"`)

```typescript
interface SdkHeaderParameter extends SdkModelPropertyTypeBase {
  kind: "header";
  collectionFormat?: CollectionFormat;
  serializedName: string;
  correspondingMethodParams: (SdkMethodParameter | SdkModelPropertyType)[]; // @deprecated
  methodParameterSegments: (SdkMethodParameter | SdkModelPropertyType)[][];
}
```

#### `SdkQueryParameter` (kind: `"query"`)

```typescript
interface SdkQueryParameter extends SdkModelPropertyTypeBase {
  kind: "query";
  collectionFormat?: CollectionFormat;
  serializedName: string;
  explode: boolean;
  correspondingMethodParams: ...;   // @deprecated
  methodParameterSegments: ...;
}
```

#### `SdkPathParameter` (kind: `"path"`)

```typescript
interface SdkPathParameter extends SdkModelPropertyTypeBase {
  kind: "path";
  explode: boolean;
  style: "simple" | "label" | "matrix" | "fragment" | "path";
  allowReserved: boolean;
  serializedName: string;
  correspondingMethodParams: ...;   // @deprecated
  methodParameterSegments: ...;
}
```

#### `SdkCookieParameter` (kind: `"cookie"`)

```typescript
interface SdkCookieParameter extends SdkModelPropertyTypeBase {
  kind: "cookie";
  serializedName: string;
  correspondingMethodParams: ...;   // @deprecated
  methodParameterSegments: ...;
}
```

#### `SdkBodyParameter` (kind: `"body"`)

```typescript
interface SdkBodyParameter extends SdkModelPropertyTypeBase {
  kind: "body";
  serializedName: string;
  contentTypes: string[];
  defaultContentType: string;
  correspondingMethodParams: ...;   // @deprecated
  methodParameterSegments: ...;
  streamMetadata?: SdkStreamMetadata;
}
```

#### `CollectionFormat`

```typescript
type CollectionFormat =
  | "multi"
  | "csv"
  | "ssv"
  | "tsv"
  | "pipes"
  | "simple"
  | "form";
```

#### `SdkHttpParameter` (union)

```typescript
type SdkHttpParameter =
  | SdkQueryParameter
  | SdkPathParameter
  | SdkBodyParameter
  | SdkHeaderParameter
  | SdkCookieParameter;
```

### 3.7 Serialization Options

```typescript
interface SerializationOptions {
  json?: JsonSerializationOptions;
  xml?: XmlSerializationOptions;
  multipart?: MultipartOptions;
  binary?: BinarySerializationOptions;
}

interface JsonSerializationOptions {
  name: string;
}

interface XmlSerializationOptions {
  name: string;
  attribute?: boolean;
  ns?: { namespace: string; prefix: string };
  unwrapped?: boolean;
  itemsName?: string;
  itemsNs?: { namespace: string; prefix: string };
}

interface BinarySerializationOptions {
  isFile: boolean;
  isText?: boolean;
  contentTypes?: string[];
  filename?: ModelProperty;
}

interface MultipartOptions {
  name: string;
  isFilePart: boolean;
  isMulti: boolean;
  filename?: SdkModelPropertyType;
  contentType?: SdkModelPropertyType;
  defaultContentTypes: string[];
  headers: SdkHeaderParameter[];
}
```

### 3.8 Method Types

#### `SdkMethod` (union type)

```typescript
type SdkMethod<TServiceOperation> = SdkServiceMethod<TServiceOperation>;
type SdkServiceMethod<TServiceOperation> =
  | SdkBasicServiceMethod<TServiceOperation>
  | SdkPagingServiceMethod<TServiceOperation>
  | SdkLroServiceMethod<TServiceOperation>
  | SdkLroPagingServiceMethod<TServiceOperation>;
```

All methods share the `SdkServiceMethodBase` interface:

```typescript
interface SdkServiceMethodBase<TServiceOperation> extends DecoratedType {
  __raw?: Operation;
  name: string;
  access: AccessFlags;
  apiVersions: string[];
  doc?: string;
  summary?: string;
  crossLanguageDefinitionId: string;
  operation: TServiceOperation;
  parameters: SdkMethodParameter[];
  response: SdkMethodResponse;
  exception?: SdkMethodResponse;
  generateConvenient: boolean;
  generateProtocol: boolean;
  isOverride: boolean;
}
```

#### `SdkBasicServiceMethod` (kind: `"basic"`)

Standard request-response method.

#### `SdkPagingServiceMethod` (kind: `"paging"`)

Adds `pagingMetadata: SdkPagingServiceMetadata`.

```typescript
interface SdkPagingServiceMetadata<TServiceOperation> {
  __raw?: PagingOperation;
  nextLinkSegments?: (SdkServiceResponseHeader | SdkModelPropertyType)[];
  nextLinkOperation?: SdkServiceMethod<TServiceOperation>;
  nextLinkVerb?: "GET" | "POST";
  nextLinkReInjectedParametersSegments?: (
    | SdkMethodParameter
    | SdkModelPropertyType
  )[][];
  continuationTokenParameterSegments?: (
    | SdkMethodParameter
    | SdkModelPropertyType
  )[];
  continuationTokenResponseSegments?: (
    | SdkServiceResponseHeader
    | SdkModelPropertyType
  )[];
  pageItemsSegments?: SdkModelPropertyType[];
  pageSizeParameterSegments?: (SdkMethodParameter | SdkModelPropertyType)[];
}
```

#### `SdkLroServiceMethod` (kind: `"lro"`)

Adds `lroMetadata: SdkLroServiceMetadata`.

```typescript
interface SdkLroServiceMetadata {
  __raw: LroMetadata;
  finalStateVia: FinalStateValue;
  pollingStep: SdkLroServicePollingStep;
  finalStep?: SdkLroServiceFinalStep;
  finalResponse?: SdkLroServiceFinalResponse;
  operation: SdkServiceOperation;
  logicalResult: SdkModelType;
  statusMonitorStep?: SdkNextOperationLink | SdkNextOperationReference;
  pollingInfo: SdkPollingOperationStep;
  envelopeResult: SdkModelType;
  logicalPath?: string;
  finalResult?:
    | SdkModelType
    | SdkArrayType
    | SdkBuiltInType<"unknown">
    | "void";
  finalEnvelopeResult?:
    | SdkModelType
    | SdkArrayType
    | SdkBuiltInType<"unknown">
    | "void";
  finalResultPath?: string;
}
```

#### `SdkLroPagingServiceMethod` (kind: `"lropaging"`)

Combines both LRO and paging metadata.

### 3.9 Response Types

#### `SdkMethodResponse`

```typescript
interface SdkMethodResponse {
  kind: "method";
  type?: SdkType;
  resultSegments?: SdkModelPropertyType[]; // For LRO/paging: path to result from response
  optional?: boolean; // True when at least one HTTP response has no body
  streamMetadata?: SdkStreamMetadata;
}
```

#### `SdkHttpOperation`

```typescript
interface SdkHttpOperation {
  __raw: HttpOperation;
  kind: "http";
  path: string;
  uriTemplate: string;
  verb: HttpVerb;
  parameters: (
    | SdkPathParameter
    | SdkQueryParameter
    | SdkHeaderParameter
    | SdkCookieParameter
  )[];
  bodyParam?: SdkBodyParameter;
  responses: SdkHttpResponse[];
  exceptions: SdkHttpErrorResponse[];
  examples?: SdkHttpOperationExample[];
}
```

#### `SdkHttpResponse`

```typescript
interface SdkHttpResponse {
  __raw: HttpOperationResponse;
  kind: "http";
  type?: SdkType;
  headers: SdkServiceResponseHeader[];
  apiVersions: string[];
  contentTypes?: string[];
  defaultContentType?: string;
  description?: string;
  statusCodes: number | HttpStatusCodeRange;
  streamMetadata?: SdkStreamMetadata;
}
```

#### `SdkStreamMetadata`

```typescript
interface SdkStreamMetadata {
  bodyType: SdkType;
  originalType: SdkType;
  streamType: SdkType;
  contentTypes: string[];
}
```

### 3.10 Flags and Enums

#### `UsageFlags`

```typescript
enum UsageFlags {
  None = 0,
  Input = 1 << 1, // 2
  Output = 1 << 2, // 4
  ApiVersionEnum = 1 << 3, // 8
  JsonMergePatch = 1 << 4, // 16 (Input + Json also set)
  MultipartFormData = 1 << 5, // 32 (Input also set)
  Spread = 1 << 6, // 64
  Json = 1 << 8, // 256
  Xml = 1 << 9, // 512
  Exception = 1 << 10, // 1024
  LroInitial = 1 << 11, // 2048
  LroPolling = 1 << 12, // 4096
  LroFinalEnvelope = 1 << 13, // 8192
  External = 1 << 14, // 16384
}
```

#### `AccessFlags`

```typescript
type AccessFlags = "internal" | "public";
```

### 3.11 Decorated Type Support

```typescript
interface DecoratedType {
  decorators: DecoratorInfo[];
}

interface DecoratorInfo {
  name: string; // Fully qualified, e.g. "TypeSpec.@encode"
  arguments: Record<string, any>;
}
```

### 3.12 External Type Info

```typescript
interface ExternalTypeInfo {
  kind: "externalTypeInfo";
  identity: string;
  package?: string;
  minVersion?: string;
}
```

### 3.13 Example Types

```typescript
interface SdkHttpOperationExample {
  kind: "http";
  name: string;
  doc: string;
  filePath: string;
  rawExample: any;
  parameters: SdkHttpParameterExampleValue[];
  responses: SdkHttpResponseExampleValue[];
}

type SdkExampleValue =
  | SdkStringExampleValue // kind: "string"
  | SdkNumberExampleValue // kind: "number"
  | SdkBooleanExampleValue // kind: "boolean"
  | SdkNullExampleValue // kind: "null"
  | SdkUnknownExampleValue // kind: "unknown"
  | SdkArrayExampleValue // kind: "array"
  | SdkDictionaryExampleValue // kind: "dict"
  | SdkUnionExampleValue // kind: "union"
  | SdkModelExampleValue; // kind: "model"
```

---

## 4. Public Utility Functions

Exported from `public-utils.ts`:

| Function                                       | Signature                                                                            | Description                                                                     |
| ---------------------------------------------- | ------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------- |
| `getDefaultApiVersion`                         | `(context: TCGCContext, serviceNamespace: Namespace) => Version \| undefined`        | Returns the default (latest) API version for a versioned service                |
| `isApiVersion`                                 | `(context: TCGCContext, type: ModelProperty) => boolean`                             | Checks if a parameter is an API version parameter                               |
| `getEffectivePayloadType`                      | `(context: TCGCContext, type: Model, visibility?: Visibility) => Model`              | Returns named model equivalent of anonymous models, ignoring metadata           |
| `getPropertyNames`                             | `(context: TCGCContext, property: ModelProperty) => [string, string]`                | Returns `[libraryName, wireName]` tuple                                         |
| `getLibraryName`                               | `(context: TCGCContext, type: Type & { name?: string \| symbol }, scope?) => string` | Gets the client name. Priority: `@clientName` > `@friendlyName` > TypeSpec name |
| `getWireName`                                  | `(context: TCGCContext, type: Type & { name: string }) => string`                    | Gets serialized name (respects `@encodedName`)                                  |
| `getCrossLanguageDefinitionId`                 | `(context, type, operation?, appendNamespace?) => string`                            | Generates unique cross-language ID for a type                                   |
| `getCrossLanguagePackageId`                    | `(context: TCGCContext) => [string, readonly Diagnostic[]]`                          | Gets the cross-language package ID                                              |
| `getGeneratedName`                             | `(context, type: Model \| Union \| TspLiteralType, operation?) => string`            | Creates a name for anonymous models/unions                                      |
| `getHttpOperationWithCache`                    | `(context: TCGCContext, operation: Operation) => HttpOperation`                      | Cached HTTP operation lookup                                                    |
| `getHttpOperationExamples`                     | `(context: TCGCContext, operation: HttpOperation) => SdkHttpOperationExample[]`      | Gets examples for an HTTP operation                                             |
| `isAzureCoreModel`                             | `(t: SdkType) => boolean`                                                            | Checks if a type is an Azure Core model                                         |
| `isPagedResultModel`                           | `(context: TCGCContext, t: SdkType) => boolean`                                      | Checks if a type is used as a paged result                                      |
| `getHttpOperationParameter`                    | `(method, param) => SdkHttpParameter \| SdkModelPropertyType \| undefined`           | Finds the HTTP parameter corresponding to a method parameter                    |
| `getHttpOperationParametersForClientParameter` | `(client, param) => SdkHttpParameter[]`                                              | Finds HTTP parameters for a client initialization parameter                     |
| `listAllServiceNamespaces`                     | `(context: TCGCContext) => Namespace[]`                                              | Lists all service namespaces in the program                                     |
| `resolveOperationId`                           | `(context, operation, honorRenaming?) => string`                                     | Calculates operation ID                                                         |
| `isHttpMetadata`                               | `(context, property: SdkModelPropertyType) => boolean`                               | Checks if a property is HTTP metadata                                           |
| `getNamespaceFromType`                         | `(type) => Namespace \| undefined`                                                   | Extracts namespace from a type                                                  |
| `getClientOptions`                             | `<T extends DecoratedType>(type: T, key: string) => unknown`                         | Gets a `@clientOption` value by key from a decorated type                       |

Exported from `decorators.ts` (key helper functions):

| Function                                           | Description                                         |
| -------------------------------------------------- | --------------------------------------------------- |
| `listClients(context)`                             | Lists all `SdkClient` objects                       |
| `listOperationGroups(context, client, recursive?)` | Lists operation groups for a client                 |
| `listOperationsInOperationGroup(context, group)`   | Lists operations in a client or operation group     |
| `getClient(context, type)`                         | Gets `SdkClient` for a namespace/interface          |
| `isOperationGroup(context, type)`                  | Checks if namespace/interface is an operation group |
| `shouldGenerateProtocol(context, entity)`          | Whether to generate protocol method                 |
| `shouldGenerateConvenient(context, entity)`        | Whether to generate convenience method              |
| `getUsageOverride(context, entity)`                | Gets `@usage` override value                        |
| `getUsage(context, entity)`                        | Gets computed usage flags                           |
| `getAccessOverride(context, entity)`               | Gets `@access` override value                       |
| `getAccess(context, entity)`                       | Gets computed access                                |
| `shouldFlattenProperty(context, target)`           | Whether property should be flattened                |
| `getClientNameOverride(context, type, scope?)`     | Gets `@clientName` override                         |
| `getOverriddenClientMethod(context, operation)`    | Gets `@override` operation                          |
| `getAlternateType(context, type, scope?)`          | Gets `@alternateType` override                      |
| `getClientInitializationOptions(context, type)`    | Gets `@clientInitialization` options                |
| `getParamAlias(context, original)`                 | Gets `@paramAlias` value                            |
| `getIsApiVersion(context, param)`                  | Gets explicit `@apiVersion` setting                 |
| `getClientNamespace(context, type)`                | Gets `@clientNamespace` override                    |
| `getExplicitClientApiVersions(context, type)`      | Gets `@clientApiVersions` enum                      |
| `getResponseAsBool(context, target)`               | Gets `@responseAsBool` setting                      |
| `getClientDocExplicit(context, type)`              | Gets `@clientDoc` value                             |
| `getClientLocation(context, entity)`               | Gets `@clientLocation` target                       |
| `getLegacyHierarchyBuilding(context, target)`      | Gets `@hierarchyBuilding` parent model              |
| `getMarkAsLro(context, entity)`                    | Whether operation is marked as LRO                  |
| `getMarkAsPageable(context, entity)`               | Gets pageable marking info                          |
| `getDisablePageable(context, entity)`              | Whether paging is disabled                          |
| `getNextLinkVerb(context, entity)`                 | Gets next link HTTP verb                            |
| `getClientDefaultValue(context, type)`             | Gets client default value                           |
| `isInScope(context, entity)`                       | Whether operation/property is in scope              |

Exported from `context.ts`:

| Function                                             | Description                                     |
| ---------------------------------------------------- | ----------------------------------------------- |
| `createTCGCContext(program, emitterName?, options?)` | Creates a basic `TCGCContext`                   |
| `createSdkContext(context, emitterName?, options?)`  | Creates the full `SdkContext` with `sdkPackage` |
| `$onEmit(context)`                                   | Emitter entry point                             |

Exported from `types.ts` (key functions):

| Function                                   | Description                         |
| ------------------------------------------ | ----------------------------------- |
| `getClientType(context, type, operation?)` | Converts TypeSpec type to `SdkType` |
| `getSdkModel(context, type, operation?)`   | Converts Model to `SdkModelType`    |
| `getSdkEnum(context, type, operation?)`    | Converts Enum to `SdkEnumType`      |
| `getSdkUnion(context, type, operation?)`   | Converts Union to `SdkType`         |
| `getSdkBuiltInType(context, type)`         | Converts Scalar to `SdkBuiltInType` |
| `getAllModels(context)`                    | Gets all referenced models          |
| `getAllReferencedTypes(context)`           | Gets all referenced types           |
| `isReadOnly(property)`                     | Checks if property is read-only     |
| `updateUsageOrAccess(context, ...)`        | Updates usage/access for types      |

---

## 5. Emitter Options

### Unbranded (basic) options

| Option                         | Type       | Default | Description                                                      |
| ------------------------------ | ---------- | ------- | ---------------------------------------------------------------- |
| `generate-protocol-methods`    | `boolean?` | `true`  | Generate low-level protocol methods                              |
| `generate-convenience-methods` | `boolean?` | `true`  | Generate convenience methods                                     |
| `api-version`                  | `string?`  | latest  | Target API version (`"latest"`, `"all"`, or specific)            |
| `license`                      | `object?`  | —       | License info: `{ name, company?, link?, header?, description? }` |

### Branded (Azure) options — extends unbranded

| Option         | Type      | Default     | Description                           |
| -------------- | --------- | ----------- | ------------------------------------- |
| `examples-dir` | `string?` | `examples/` | Directory for example files           |
| `namespace`    | `string?` | —           | Override namespace for all spec types |

### TCGC standalone emitter options — extends branded

| Option         | Type      | Default | Description                  |
| -------------- | --------- | ------- | ---------------------------- |
| `emitter-name` | `string?` | —       | Target language emitter name |

### `CreateSdkContextOptions` (programmatic)

| Option                                | Type       | Default       | Description                                   |
| ------------------------------------- | ---------- | ------------- | --------------------------------------------- |
| `versioning.previewStringRegex`       | `RegExp`   | `/-preview$/` | Regex to match preview versions               |
| `additionalDecorators`                | `string[]` | `[]`          | Extra decorators to include in the allow-list |
| `disableUsageAccessPropagationToBase` | `boolean`  | `false`       | Skip propagation to base models               |
| `exportTCGCoutput`                    | `boolean`  | `false`       | Export `tcgc-output.yaml` file                |
| `flattenUnionAsEnum`                  | `boolean`  | `true`        | Flatten union-as-enum                         |
| `enableLegacyHierarchyBuilding`       | `boolean`  | `true`        | Respect `@hierarchyBuilding` decorator        |

---

## 6. Linter Rules

| Rule Name                | Description                                                               | Severity |
| ------------------------ | ------------------------------------------------------------------------- | -------- |
| `require-client-suffix`  | Client names must end with `Client`                                       | warning  |
| `no-unnamed-types`       | Types should be named, not anonymous/inline                               | warning  |
| `property-name-conflict` | Property name should not conflict with enclosing model name (C# specific) | warning  |

Rule set: `best-practices:csharp` enables `property-name-conflict`.

---

## 7. Diagnostic Codes

Key diagnostics emitted by TCGC (from `lib.ts`):

| Code                                               | Severity | Description                                                  |
| -------------------------------------------------- | -------- | ------------------------------------------------------------ |
| `multiple-services`                                | warning  | Multiple services found; only first used                     |
| `client-service`                                   | warning  | Client not inside a service namespace                        |
| `union-null`                                       | warning  | Union contains only null types                               |
| `union-circular`                                   | warning  | Union references itself                                      |
| `invalid-access`                                   | error    | Access must be "public" or "internal"                        |
| `invalid-usage`                                    | error    | Usage value not valid                                        |
| `conflicting-multipart-model-usage`                | error    | Model used as both multipart and regular body                |
| `discriminator-not-constant`                       | error    | Discriminator must be constant                               |
| `discriminator-not-string`                         | warning  | Discriminator value must be string                           |
| `wrong-client-decorator`                           | warning  | `@client`/`@operationGroup` on wrong target                  |
| `server-param-not-path`                            | error    | Server template arg must be path parameter                   |
| `unexpected-http-param-type`                       | error    | Wrong parameter type                                         |
| `multiple-response-types`                          | warning  | Multiple response types in operation                         |
| `no-corresponding-method-param`                    | error    | Missing HTTP parameter in method                             |
| `unsupported-protocol`                             | error    | Only HTTP/HTTPS supported                                    |
| `no-emitter-name`                                  | warning  | Emitter name not found                                       |
| `empty-client-name`                                | warning  | Empty `@clientName` value                                    |
| `override-parameters-mismatch`                     | error    | `@override` parameter mismatch                               |
| `duplicate-client-name`                            | error    | Duplicate client name in scope                               |
| `duplicate-client-name-warning`                    | warning  | Duplicate client name warning                                |
| `client-name-ineffective`                          | warning  | `@clientName` has no effect                                  |
| `example-loading`                                  | warning  | Example file loading issues                                  |
| `duplicate-example-file`                           | error    | Duplicate example title                                      |
| `example-value-no-mapping`                         | warning  | Example value doesn't match definition                       |
| `flatten-polymorphism`                             | error    | Cannot flatten polymorphic property                          |
| `conflict-access-override`                         | warning  | Conflicting `@access` overrides                              |
| `duplicate-decorator`                              | warning  | Same decorator applied twice in same scope                   |
| `empty-client-namespace`                           | warning  | Empty `@clientNamespace` value                               |
| `unexpected-pageable-operation-return-type`        | error    | Pageable operation return type issue                         |
| `invalid-alternate-type`                           | error    | Alternate type mismatch (scalar vs non-scalar)               |
| `invalid-initialized-by`                           | error    | Invalid `InitializedBy` value                                |
| `invalid-deserializeEmptyStringAsNull-target-type` | error    | Wrong target type for decorator                              |
| `api-version-not-string`                           | warning  | API version must be string/string enum                       |
| `non-head-bool-response-decorator`                 | warning  | `@responseAsBool` on non-HEAD operation                      |
| `require-versioned-service`                        | warning  | Service must be versioned for decorator                      |
| `missing-service-versions`                         | warning  | `@clientApiVersions` missing service versions                |
| `invalid-client-doc-mode`                          | error    | Invalid `@clientDoc` mode                                    |
| `multiple-param-alias`                             | warning  | Multiple `@paramAlias` on same property                      |
| `client-location-conflict`                         | warning  | `@clientLocation` conflicts with `@client`/`@operationGroup` |
| `client-location-wrong-type`                       | warning  | `@clientLocation` target not in service namespace            |
| `legacy-hierarchy-building-conflict`               | warning  | `@hierarchyBuilding` property mismatch                       |
| `legacy-hierarchy-building-circular-reference`     | error    | Circular `@hierarchyBuilding` reference                      |
| `missing-scope`                                    | warning  | `@scope` should be applied with other scoped decorators      |
| `external-library-version-mismatch`                | warning  | Multiple external library versions                           |
| `external-type-on-model-property`                  | warning  | External alternate type on property                          |
| `invalid-mark-as-lro-target`                       | warning  | `@markAsLro` on non-model-returning operation                |
| `mark-as-lro-ineffective`                          | warning  | `@markAsLro` on already-LRO operation                        |
| `invalid-mark-as-pageable-target`                  | warning  | `@markAsPageable` on invalid target                          |
| `mark-as-pageable-ineffective`                     | warning  | `@markAsPageable` on already-pageable operation              |
| `api-version-undefined`                            | warning  | Configured API version not in service version list           |
| `multiple-explicit-clients-multiple-services`      | error    | Multiple clients with multiple services                      |
| `invalid-client-service-multiple`                  | error    | `@client` with multiple services only on Namespace           |
| `inconsistent-multiple-service`                    | error    | Services have different server/auth                          |
| `client-option`                                    | warning  | `@clientOption` experimental usage                           |
| `client-option-requires-scope`                     | warning  | `@clientOption` should have scope                            |

---

## 8. Test Files

### Test directory structure

```
packages/typespec-client-generator-core/test/
├── tester.ts                           # Test helper/setup
├── utils.ts                            # Test utilities
├── context.test.ts                     # SDK context creation
├── internal-utils.test.ts              # Internal utilities
├── clients/
│   ├── params.test.ts                  # Client initialization parameters
│   └── structure.test.ts               # Client hierarchy and structure
├── decorators/
│   ├── access.test.ts                  # @access decorator
│   ├── alternate-type.test.ts          # @alternateType decorator
│   ├── api-version.test.ts             # @apiVersion decorator
│   ├── client-api-versions.test.ts     # @clientApiVersions decorator
│   ├── client-default-value.test.ts    # @clientDefaultValue (legacy)
│   ├── client-doc.test.ts              # @clientDoc decorator
│   ├── client-initialization.test.ts   # @clientInitialization decorator
│   ├── client-location.test.ts         # @clientLocation decorator
│   ├── client-name.test.ts             # @clientName decorator
│   ├── client-namespace.test.ts        # @clientNamespace decorator
│   ├── client-option.test.ts           # @clientOption decorator
│   ├── client.test.ts                  # @client decorator
│   ├── convenient-api.test.ts          # @convenientAPI decorator
│   ├── deserialize-empty-string-as-null.test.ts
│   ├── disable-pageable.test.ts        # @disablePageable (legacy)
│   ├── flatten-property.test.ts        # @flattenProperty (legacy)
│   ├── general-list.test.ts            # List/pagination patterns
│   ├── legacy-hierarchy-building.test.ts # @hierarchyBuilding (legacy)
│   ├── mark-as-lro.test.ts             # @markAsLro (legacy)
│   ├── mark-as-pageable.test.ts        # @markAsPageable (legacy)
│   ├── next-link-verb.test.ts          # @nextLinkVerb (legacy)
│   ├── override.test.ts                # @override decorator
│   ├── param-alias.test.ts             # @paramAlias decorator
│   ├── protocol-api.test.ts            # @protocolAPI decorator
│   ├── response-as-bool.test.ts        # @responseAsBool decorator
│   ├── scope.test.ts                   # @scope decorator
│   ├── usage-extended.test.ts          # Extended usage flags
│   └── usage.test.ts                   # @usage decorator
├── types/
│   ├── array.test.ts                   # Array types
│   ├── built-in.test.ts                # Built-in scalar types
│   ├── bytes.test.ts                   # Binary/bytes types
│   ├── body-model-property.test.ts     # Body properties
│   ├── constant.test.ts                # Constants
│   ├── date-time.test.ts               # DateTime types
│   ├── dictionary.test.ts              # Dictionary types
│   ├── doc-summary.test.ts             # Documentation/summary
│   ├── duration.test.ts                # Duration types
│   ├── encode-merge-patch.test.ts      # Merge patch encoding
│   ├── enum.test.ts                    # Enum types
│   ├── model.test.ts                   # Model types
│   ├── multipart.test.ts              # Multipart form data
│   ├── serialization-options.test.ts   # Serialization options
│   ├── tuple.test.ts                   # Tuple types
│   ├── union.test.ts                   # Union types
│   ├── usage-flags.test.ts             # Usage flag combinations
│   └── utils.ts                        # Test utilities
├── methods/
│   ├── file.test.ts                    # File upload/download
│   ├── lro.test.ts                     # Long-running operations
│   ├── paged-operation.test.ts         # Pagination
│   ├── parameters.test.ts              # Method parameters
│   ├── responses.test.ts               # Response types
│   ├── spread.test.ts                  # Parameter spreading
│   └── streams.test.ts                 # Streaming responses
├── public-utils/
│   ├── get-cross-language-definition-id.test.ts
│   ├── get-default-api-version.test.ts
│   ├── get-effective-payload-type.test.ts
│   ├── get-generated-name.test.ts
│   ├── get-http-operation-parameter.test.ts
│   ├── get-http-operation-parameters-for-client-parameter.test.ts
│   ├── get-library-name.test.ts
│   ├── get-property-names.test.ts
│   ├── is-api-version.test.ts
│   ├── is-http-metadata.test.ts
│   └── is-paged-result-model.test.ts
├── package/
│   ├── api-versions-metadata.test.ts
│   ├── azure-widget-service.test.ts
│   ├── license.test.ts
│   ├── models-only.test.ts
│   ├── namespaces.test.ts
│   ├── vanilla-widget-service.test.ts
│   └── versioning.test.ts
├── http/
│   ├── body.test.ts
│   ├── method-parameter-segments.test.ts
│   └── path.test.ts
├── examples/
│   ├── helper.test.ts
│   ├── http-operation-examples.test.ts
│   ├── load.test.ts
│   └── types.test.ts
├── validations/
│   ├── package.test.ts
│   └── types.test.ts
└── rules/
    ├── no-unnamed-types.test.ts
    ├── property-name-conflict.test.ts
    └── require-client-suffix.test.ts
```

---

## 9. Existing Documentation

### 9.1 User Documentation

Location: `website/src/content/docs/docs/howtos/Generate client libraries/`

| File                          | Title / Topic                                                        |
| ----------------------------- | -------------------------------------------------------------------- |
| `00howtogen.mdx`              | How to Generate Client Libraries — overview and quick start          |
| `01setup.mdx`                 | Setup for SDK Customization — configuring `client.tsp`               |
| `02package.mdx`               | Common Behavior for Client Packages — service definition, namespaces |
| `03client.mdx`                | Clients — structure, single/multi-client, hierarchy, customization   |
| `04method.mdx`                | Basic Methods — method generation, convenience vs protocol           |
| `05pagingOperations.mdx`      | Paging Operations — `@list`, `@nextLink`, `@items` patterns          |
| `06longRunningOperations.mdx` | Long-Running Operations — LRO patterns, polling                      |
| `07multipart.mdx`             | Multipart Operations — multipart form data, file uploads             |
| `08types.mdx`                 | Generated Types — type mappings, models, enums, unions, usage        |
| `09renaming.mdx`              | Renaming Types — `@clientName` usage                                 |
| `10versioning.mdx`            | Versioning — API version handling                                    |
| `11hierarchyBuilding.mdx`     | Multi-Layer Discriminator Hierarchy — `@hierarchyBuilding` (legacy)  |
| `12clientOptions.mdx`         | Client Options — `@clientOption` decorator                           |

### 9.2 Emitter Developer Documentation

Location: `website/src/content/docs/docs/libraries/typespec-client-generator-core/guideline.md`

Sections:

- TCGC Library — usage, exporting type graph, playground, flags
- TCGC Raw Types and Helpers — `SdkClient`, `SdkOperationGroup`, `listClients()`, etc.
- Client Type Graph — common properties, `SdkPackage`, license, client, method, operation, type, examples
- Client Type Calculation Logic — client/method detection, parameter handling, return types, access/usage calculation, naming logic, decorator allow-list

### 9.3 Design Documents

Location: `packages/typespec-client-generator-core/design-docs/`

| File                   | Topic                                                                                       |
| ---------------------- | ------------------------------------------------------------------------------------------- |
| `client.md`            | Client structure design — `SdkClient`, initialization, `@clientInitialization`, sub-clients |
| `multiple-services.md` | Multiple services support — combining services, versioning, operation group merging         |

---

## 10. Spector Test Specs (azure-http-specs)

### TCGC-specific specs

Location: `packages/azure-http-specs/specs/azure/client-generator-core/`

| Directory                                                                                                                                                                             | Feature Tested                                   |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| `access/`                                                                                                                                                                             | `@access` decorator — public/internal visibility |
| `alternate-type/`                                                                                                                                                                     | `@alternateType` decorator                       |
| `api-version/query/`, `api-version/header/`, `api-version/path/`                                                                                                                      | API version parameter locations                  |
| `client-default-value/`                                                                                                                                                               | `@clientDefaultValue` (legacy)                   |
| `client-initialization/default/`, `client-initialization/individually/`, `client-initialization/individuallyParent/`                                                                  | Client initialization patterns                   |
| `client-location/move-to-new-sub-client/`, `client-location/move-method-parameter-to-client/`, `client-location/move-to-root-client/`, `client-location/move-to-existing-sub-client/` | `@clientLocation` scenarios                      |
| `deserialize-empty-string-as-null/`                                                                                                                                                   | `@deserializeEmptyStringAsNull`                  |
| `flatten-property/`                                                                                                                                                                   | `@flattenProperty` (legacy)                      |
| `hierarchy-building/`                                                                                                                                                                 | `@hierarchyBuilding` (legacy)                    |
| `next-link-verb/`                                                                                                                                                                     | `@nextLinkVerb` (legacy)                         |
| `override/`                                                                                                                                                                           | `@override` decorator                            |
| `usage/`                                                                                                                                                                              | `@usage` decorator                               |

### Related Azure specs

| Directory                                        | Relevance                            |
| ------------------------------------------------ | ------------------------------------ |
| `azure/resource-manager/operation-templates/`    | ARM operation patterns (LRO, paging) |
| `azure/resource-manager/multi-service/`          | Multiple ARM services                |
| `azure/resource-manager/method-subscription-id/` | Subscription ID handling             |
| `azure/core/page/`                               | Azure Core pagination                |
| `azure/versioning/previewVersion/`               | Preview version handling             |
| `azure/encode/duration/`                         | Duration encoding                    |
| `azure/example/basic/`                           | Example file loading                 |
| `azure/special-headers/client-request-id/`       | Client request ID header             |
| `service/multi-service/`                         | Non-Azure multi-service              |

---

## 11. Feature Areas

This section maps TCGC capabilities to their documentation, test, and spec coverage for gap analysis.

| Feature Area             | Decorators                                              | User Doc                      | Unit Tests                                                                                             | Spector Spec                                  |
| ------------------------ | ------------------------------------------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------ | --------------------------------------------- |
| Client Definition        | `@client`, `@operationGroup`                            | `03client.mdx`                | `decorators/client.test.ts`, `clients/structure.test.ts`                                               | —                                             |
| Client Naming            | `@clientName`                                           | `09renaming.mdx`              | `decorators/client-name.test.ts`                                                                       | —                                             |
| Client Namespace         | `@clientNamespace`                                      | `08types.mdx`                 | `decorators/client-namespace.test.ts`                                                                  | —                                             |
| Client Initialization    | `@clientInitialization`, `@paramAlias`, `InitializedBy` | `03client.mdx`                | `decorators/client-initialization.test.ts`, `decorators/param-alias.test.ts`, `clients/params.test.ts` | `client-initialization/`                      |
| Client Location          | `@clientLocation`                                       | `03client.mdx`                | `decorators/client-location.test.ts`                                                                   | `client-location/`                            |
| Operation Override       | `@override`                                             | `04method.mdx`                | `decorators/override.test.ts`                                                                          | `override/`                                   |
| Convenience/Protocol API | `@convenientAPI`, `@protocolAPI`                        | `04method.mdx`                | `decorators/convenient-api.test.ts`, `decorators/protocol-api.test.ts`                                 | —                                             |
| Access Control           | `@access`, `Access` enum                                | `08types.mdx`                 | `decorators/access.test.ts`                                                                            | `access/`                                     |
| Usage Control            | `@usage`, `Usage` enum                                  | `08types.mdx`                 | `decorators/usage.test.ts`, `decorators/usage-extended.test.ts`                                        | `usage/`                                      |
| Alternate Type           | `@alternateType`, `ExternalType`                        | `08types.mdx`                 | `decorators/alternate-type.test.ts`                                                                    | `alternate-type/`                             |
| Scoping                  | `@scope`                                                | —                             | `decorators/scope.test.ts`                                                                             | —                                             |
| API Version              | `@apiVersion`, `@clientApiVersions`                     | `10versioning.mdx`            | `decorators/api-version.test.ts`, `decorators/client-api-versions.test.ts`                             | `api-version/`                                |
| Flatten Property         | `@flattenProperty` (legacy)                             | —                             | `decorators/flatten-property.test.ts`                                                                  | `flatten-property/`                           |
| Hierarchy Building       | `@hierarchyBuilding` (legacy)                           | `11hierarchyBuilding.mdx`     | `decorators/legacy-hierarchy-building.test.ts`                                                         | `hierarchy-building/`                         |
| Mark as LRO              | `@markAsLro` (legacy)                                   | —                             | `decorators/mark-as-lro.test.ts`                                                                       | —                                             |
| Mark as Pageable         | `@markAsPageable` (legacy)                              | —                             | `decorators/mark-as-pageable.test.ts`                                                                  | —                                             |
| Disable Pageable         | `@disablePageable` (legacy)                             | —                             | `decorators/disable-pageable.test.ts`                                                                  | —                                             |
| Next Link Verb           | `@nextLinkVerb` (legacy)                                | —                             | `decorators/next-link-verb.test.ts`                                                                    | `next-link-verb/`                             |
| Client Default Value     | `@clientDefaultValue` (legacy)                          | —                             | `decorators/client-default-value.test.ts`                                                              | `client-default-value/`                       |
| Deserialize Empty String | `@deserializeEmptyStringAsNull`                         | —                             | `decorators/deserialize-empty-string-as-null.test.ts`                                                  | `deserialize-empty-string-as-null/`           |
| Response as Bool         | `@responseAsBool`                                       | —                             | `decorators/response-as-bool.test.ts`                                                                  | —                                             |
| Client Doc               | `@clientDoc`, `DocumentationMode`                       | —                             | `decorators/client-doc.test.ts`                                                                        | —                                             |
| Client Option            | `@clientOption`                                         | `12clientOptions.mdx`         | `decorators/client-option.test.ts`                                                                     | —                                             |
| System Text Json         | `@useSystemTextJsonConverter`                           | —                             | —                                                                                                      | —                                             |
| Paging Operations        | —                                                       | `05pagingOperations.mdx`      | `methods/paged-operation.test.ts`, `decorators/general-list.test.ts`                                   | `azure/core/page/`                            |
| Long-Running Operations  | —                                                       | `06longRunningOperations.mdx` | `methods/lro.test.ts`                                                                                  | `azure/resource-manager/operation-templates/` |
| Multipart                | —                                                       | `07multipart.mdx`             | `types/multipart.test.ts`                                                                              | —                                             |
| Streaming                | —                                                       | —                             | `methods/streams.test.ts`                                                                              | —                                             |
| File Upload/Download     | —                                                       | —                             | `methods/file.test.ts`                                                                                 | —                                             |
| Parameter Spreading      | —                                                       | `04method.mdx`                | `methods/spread.test.ts`                                                                               | —                                             |
| Versioning               | `@versioned` (TypeSpec core)                            | `10versioning.mdx`            | `package/versioning.test.ts`, `package/api-versions-metadata.test.ts`                                  | `azure/versioning/previewVersion/`            |
| Multiple Services        | `@client({service: [...]})`                             | —                             | `package/azure-widget-service.test.ts`                                                                 | `azure/resource-manager/multi-service/`       |
| License                  | license config                                          | `02package.mdx`               | `package/license.test.ts`                                                                              | —                                             |
| Examples                 | `examples-dir` config                                   | —                             | `examples/`                                                                                            | `azure/example/basic/`                        |
| Type Generation          | —                                                       | `08types.mdx`                 | `types/` (16 files)                                                                                    | —                                             |
| Methods & Parameters     | —                                                       | `04method.mdx`                | `methods/parameters.test.ts`, `methods/responses.test.ts`                                              | —                                             |

### Documentation Gaps (features with no user doc page)

The following features have decorators and/or tests but **no dedicated user documentation**:

- `@scope` — scoping operations/properties to specific languages
- `@flattenProperty` — property flattening (legacy)
- `@markAsLro` — forcing LRO behavior (legacy)
- `@markAsPageable` — forcing pageable behavior (legacy)
- `@disablePageable` — disabling pageable behavior (legacy)
- `@nextLinkVerb` — next link HTTP verb override (legacy)
- `@clientDefaultValue` — client default values (legacy)
- `@deserializeEmptyStringAsNull` — empty string deserialization
- `@responseAsBool` — HEAD operation boolean response
- `@clientDoc` — client documentation override
- `@useSystemTextJsonConverter` — C# JSON converter
- Streaming / file operations
- Multiple services (`@client({service: [A, B]})`)

### Spector Gaps (features with no spec)

The following features have decorators/tests but **no Spector spec**:

- `@client` / `@operationGroup` definition
- `@clientName` renaming
- `@clientNamespace` namespace override
- `@convenientAPI` / `@protocolAPI` control
- `@scope` scoping
- `@markAsLro` (legacy)
- `@markAsPageable` (legacy)
- `@disablePageable` (legacy)
- `@responseAsBool`
- `@clientDoc`
- `@clientOption`
- `@useSystemTextJsonConverter`
- Multipart operations
- Streaming
- File upload/download
- Parameter spreading

---

## 12. Default Decorator Allow-List

From `configs.ts`, these decorators are included in the `DecoratedType.decorators` list by default:

```typescript
[
  "TypeSpec\\.Xml\\..*",
  "Azure\\.Core\\.@useFinalStateVia",
  "Autorest\\.@example",
  "Azure\\.ClientGenerator\\.Core\\.@clientOption",
];
```

Emitters can extend this list via `CreateSdkContextOptions.additionalDecorators`.
