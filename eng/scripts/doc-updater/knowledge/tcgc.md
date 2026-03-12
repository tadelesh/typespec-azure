# TCGC Knowledge Base

Package: `@azure-tools/typespec-client-generator-core`
Source: `packages/typespec-client-generator-core/`

TypeSpec Client Generator Core (TCGC) introduces a client type graph and provides helper functions that client emitters rely on to generate client code instead of directly interacting with the TypeSpec core API.

---

## Table of Contents

1. [Decorators](#decorators)
2. [TypeSpec Enums and Models](#typespec-enums-and-models)
3. [Public Types (TypeScript Interfaces)](#public-types)
4. [Public Utility Functions](#public-utility-functions)
5. [Type Building Functions](#type-building-functions)
6. [Context and SDK Creation](#context-and-sdk-creation)
7. [Emitter Options](#emitter-options)
8. [Linter Rules](#linter-rules)
9. [Diagnostic Codes](#diagnostic-codes)
10. [Feature Areas](#feature-areas)
11. [Test File Locations](#test-file-locations)
12. [Existing Documentation Files](#existing-documentation-files)
13. [Spector Spec Coverage](#spector-spec-coverage)
14. [Design Documents](#design-documents)

---

## Decorators

All decorators are defined in `lib/decorators.tsp` (main namespace: `Azure.ClientGenerator.Core`) and `lib/legacy.tsp` (namespace: `Azure.ClientGenerator.Core.Legacy`). Implementations are in `src/decorators.ts`.

Every decorator with a `scope` parameter supports language-specific scoping:
- Single language: `"python"`
- Multiple languages: `"python, java"`
- Negation: `"!csharp"` or `"!(java, python)"`
- Supported identifiers: `csharp`, `python`, `java`, `javascript`, `go`

### Main Decorators (`Azure.ClientGenerator.Core`)

#### `@clientName`
```typespec
extern dec clientName(target: unknown, rename: valueof string, scope?: valueof string);
```
Overrides the generated name for SDK elements (clients, methods, parameters, unions, models, enums, model properties). Takes precedence over all other naming mechanisms.

#### `@convenientAPI`
```typespec
extern dec convenientAPI(target: Operation | Namespace | Interface, flag?: valueof boolean, scope?: valueof string);
```
Controls whether an operation generates a convenient method. When applied to a namespace or interface, affects all operations within that scope unless overridden. Default: `true`.

#### `@protocolAPI`
```typespec
extern dec protocolAPI(target: Operation | Namespace | Interface, flag?: valueof boolean, scope?: valueof string);
```
Controls whether an operation generates a protocol method. When applied to a namespace or interface, affects all operations within that scope unless overridden. Default: `true`.

#### `@client`
```typespec
extern dec client(target: Namespace | Interface, options?: ClientOptions, scope?: valueof string);
```
Defines a client in the generated SDK. Each `@client` is a root client. Cannot be used with `@clientLocation`. Cannot be used as augmentation.

`ClientOptions` model:
```typespec
model ClientOptions {
  service?: Namespace | Namespace[];  // Service namespace(s). Default: first parent @service namespace
  name?: string;                      // Client name. Default: <TargetName>Client
}
```

#### `@operationGroup`
```typespec
extern dec operationGroup(target: Namespace | Interface, scope?: valueof string);
```
Defines a sub-client (operation group) in the generated SDK. Cannot be used with `@clientLocation`. Cannot be used as augmentation.

#### `@usage`
```typespec
extern dec usage(target: Model | Enum | Union | Namespace, value: EnumMember | Union, scope?: valueof string);
```
Adds additional usage info to models/enums/unions. Default usage is calculated from operations. Usage propagates to properties, parent models, and discriminated sub-models.

#### `@access`
```typespec
extern dec access(target: ModelProperty | Model | Operation | Enum | Union | Namespace, value: EnumMember, scope?: valueof string);
```
Overrides access level (`Access.public` or `Access.internal`). When set on operations, it influences models/enums used by those operations. Access propagates to properties, parent models, and discriminated sub-models.

#### `@override`
```typespec
extern dec override(target: Operation, override: Operation, scope?: valueof string);
```
Customizes a method's parameter signature in the generated SDK. Currently only parameter signature customization is supported.

#### `@useSystemTextJsonConverter`
```typespec
extern dec useSystemTextJsonConverter(target: Model, scope?: valueof string);
```
Marks a model as needing a custom JSON converter. Used for backward compatibility (primarily C#).

#### `@clientInitialization`
```typespec
extern dec clientInitialization(target: Namespace | Interface, options: ClientInitializationOptions, scope?: valueof string);
```
Customizes how clients are initialized. Can elevate operation-level parameters to client level and control initialization mode.

`ClientInitializationOptions` model:
```typespec
model ClientInitializationOptions {
  parameters?: Model;                  // Parameters to add to client initialization
  initializedBy?: EnumMember | Union;  // How client can be initialized (InitializedBy values)
}
```

#### `@paramAlias`
```typespec
extern dec paramAlias(target: ModelProperty, paramAlias: valueof string, scope?: valueof string);
```
Aliases a client parameter to a different name. Permits different names in client initialization vs the original operation parameter.

#### `@clientNamespace`
```typespec
extern dec clientNamespace(target: Namespace | Interface | Model | Enum | Union, rename: valueof string, scope?: valueof string);
```
Changes the namespace of a client, model, enum, or union in the generated SDK.

#### `@alternateType`
```typespec
extern dec alternateType(target: ModelProperty | Scalar | Model | Enum | Union, alternate: unknown | ExternalType, scope?: valueof string);
```
Sets an alternate type for serialization. When source is `Scalar`, alternate must also be `Scalar`. External types (with `identity`) cannot be applied to model properties — must be applied to type definitions.

`ExternalType` model:
```typespec
model ExternalType {
  identity: string;      // e.g., "pystac.Collection"
  package?: string;      // e.g., "pystac"
  minVersion?: string;   // e.g., "1.13.0"
}
```

#### `@scope`
```typespec
extern dec scope(target: Operation | ModelProperty, scope?: valueof string);
```
Defines which language emitters an operation or model property applies to. Can omit elements from specific languages.

#### `@apiVersion`
```typespec
extern dec apiVersion(target: ModelProperty, value?: valueof boolean, scope?: valueof string);
```
Explicitly marks (or unmarks) a parameter as an API version parameter. By default, TCGC auto-detects by matching `api-version`/`apiversion` names or `@versioned` references. API version parameters are elevated to the client level.

#### `@clientApiVersions`
```typespec
extern dec clientApiVersions(target: Namespace, value: Enum, scope?: valueof string);
```
Specifies additional API versions the client supports, extending the service's `@versioned` versions. Useful for exposing older versions without fully annotating the spec.

#### `@deserializeEmptyStringAsNull`
```typespec
extern dec deserializeEmptyStringAsNull(target: ModelProperty, scope?: valueof string);
```
Indicates that a string property should be deserialized as `null` when its value is `""`.

#### `@responseAsBool`
```typespec
extern dec responseAsBool(target: Operation, scope?: valueof string);
```
Makes a HEAD operation return `bool`. 404 → `false`, 2xx → `true`, other errors still throw.

#### `@clientLocation`
```typespec
extern dec clientLocation(source: Operation | ModelProperty, target: Interface | Namespace | Operation | (valueof string), scope?: valueof string);
```
Moves an operation to a different client, or moves a parameter between operation and client levels. Cannot be used with `@client`/`@operationGroup`. Supports:
- Move operation to existing sub-client (target = Interface/Namespace)
- Move operation to new sub-client (target = string)
- Move operation to root client (target = root Namespace)
- Move parameter from operation to client (target = Namespace/Interface)
- Move parameter from client to operation (target = Operation)

#### `@clientDoc`
```typespec
extern dec clientDoc(target: unknown, documentation: valueof string, mode: EnumMember, scope?: valueof string);
```
Overrides documentation for a type in client libraries. Mode is `DocumentationMode.append` or `DocumentationMode.replace`.

#### `@clientOption`
```typespec
extern dec clientOption(target: unknown, name: valueof string, value: valueof unknown, scope?: valueof string);
```
Passes experimental flags/options to emitters without requiring TCGC reshipping. Always emits a warning that must be suppressed. An additional warning is emitted if no scope is provided.

### Legacy Decorators (`Azure.ClientGenerator.Core.Legacy`)

#### `@hierarchyBuilding`
```typespec
extern dec hierarchyBuilding(target: Model, value: Model, scope?: valueof string);
```
Adds multi-level inheritance support for discriminated models (not supported by pure TypeSpec). Considered legacy functionality.

#### `@flattenProperty`
```typespec
extern dec flattenProperty(target: ModelProperty, scope?: valueof string);
```
Marks a model property for flattening. Not recommended for greenfield services.

#### `@markAsLro`
```typespec
extern dec markAsLro(target: Operation, scope?: valueof string);
```
Forces an operation to be treated as a Long Running Operation even when the service side is not LRO. Generates polling mechanisms and LRO return types.

#### `@markAsPageable`
```typespec
extern dec markAsPageable(target: Operation, scope?: valueof string);
```
Forces an operation to be treated as pageable even without standard paging patterns. Generates iterators/async iterators.

#### `@disablePageable`
```typespec
extern dec disablePageable(target: Operation, scope?: valueof string);
```
Prevents an operation from being treated as pageable, even if it follows paging patterns (e.g., `@list`). The response is the paged model itself.

#### `@nextLinkVerb`
```typespec
extern dec nextLinkVerb(target: Operation, verb: "GET" | "POST", scope?: valueof string);
```
Overrides the HTTP verb for the next link operation in paging. Only `"POST"` and `"GET"` are supported.

#### `@clientDefaultValue`
```typespec
extern dec clientDefaultValue(target: ModelProperty, value: valueof string | boolean | numeric, scope?: valueof string);
```
Sets a client-level default value for a model property or operation parameter. For brownfield backward compatibility.

---

## TypeSpec Enums and Models

Defined in `lib/decorators.tsp`:

### `Usage` (enum)
```typespec
enum Usage {
  input: 2,    // Used in request
  output: 4,   // Used in response
  json: 256,   // Used with JSON content type
  xml: 512,    // Used with XML content type
}
```

### `Access` (enum)
```typespec
enum Access {
  public: "public",     // Open to user
  internal: "internal", // Hide from user
}
```

### `InitializedBy` (enum)
```typespec
enum InitializedBy {
  individually: 1,   // Client can be initialized individually
  parent: 2,         // Client can be initialized by parent client
  customizeCode: 4,  // Initialization omitted from generated code, handled manually
}
```

### `DocumentationMode` (enum)
```typespec
enum DocumentationMode {
  append: "append",   // Append client doc to existing doc
  replace: "replace", // Replace existing doc with client doc
}
```

### `ClientOptions` (model)
```typespec
model ClientOptions {
  service?: Namespace | Namespace[];
  name?: string;
}
```

### `ClientInitializationOptions` (model)
```typespec
model ClientInitializationOptions {
  parameters?: Model;
  initializedBy?: EnumMember | Union;
}
```

### `ExternalType` (model)
```typespec
model ExternalType {
  identity: string;
  package?: string;
  minVersion?: string;
}
```

---

## Public Types

All public TypeScript types are defined in `src/interfaces.ts` and exported from `src/index.ts`.

### Core Context Types

#### `TCGCContext`
Main context object for TCGC operations.
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
  license?: { name: string; company?: string; header?: string; link?: string; description?: string; };
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
  getClientOrOperationGroup(type: Namespace | Interface): SdkClient | SdkOperationGroup | undefined;
  getOperationsForClient(client: SdkClient | SdkOperationGroup): Operation[];
  getClientForOperation(operation: Operation): SdkClient | SdkOperationGroup;
  // Internal caches (prefixed with __)
}
```

#### `SdkContext<TOptions, TServiceOperation>`
Extends `TCGCContext` with emit context and the SDK package.
```typescript
interface SdkContext<TOptions, TServiceOperation> extends TCGCContext {
  emitContext: EmitContext<TOptions>;
  sdkPackage: SdkPackage<TServiceOperation>;
}
```

### Client/Operation Group Types (Decorator-level)

#### `SdkClient`
Represents a client at the decorator level (before full type graph).
```typescript
interface SdkClient {
  kind: "SdkClient";
  name: string;
  service: Namespace | Namespace[];  // @deprecated: Use `services`
  services: Namespace[];
  type: Namespace | Interface;
  subOperationGroups: SdkOperationGroup[];
}
```

#### `SdkOperationGroup`
Represents an operation group (sub-client) at the decorator level.
```typescript
interface SdkOperationGroup {
  kind: "SdkOperationGroup";
  type?: Namespace | Interface;
  subOperationGroups: SdkOperationGroup[];
  groupPath: string;
  service: Namespace;      // @deprecated: Use `services`
  services: Namespace[];
  parent?: SdkClient | SdkOperationGroup;
}
```

### Client Type Graph Types

#### `SdkPackage<TServiceOperation>`
Root type for the complete SDK package.
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
    apiVersion?: string;   // @deprecated: Use `apiVersions`
    apiVersions?: Map<string, string>;
  };
}
```

#### `SdkNamespace<TServiceOperation>`
Hierarchical namespace within the package.
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

#### `SdkClientType<TServiceOperation>`
Full client type in the type graph.
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
Client initialization configuration.
```typescript
interface SdkClientInitializationType extends SdkTypeBase {
  kind: "clientinitialization";
  name: string;
  isGeneratedName: boolean;
  parameters: (SdkEndpointParameter | SdkCredentialParameter | SdkMethodParameter)[];
  initializedBy: InitializedByFlags;
}
```

### SDK Type System

#### `SdkType` (union)
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
Scalar/primitive types.
```typescript
interface SdkBuiltInType<TKind extends SdkBuiltInKinds> extends SdkTypeBase {
  kind: TKind;  // "string" | "int32" | "float64" | "boolean" | "bytes" | "url" | "unknown" | ...
  encode?: string;
  name: string;
  baseType?: SdkBuiltInType<TKind>;
  crossLanguageDefinitionId: string;
}
```
Built-in kinds include: `numeric`, `integer`, `safeint`, `int8`, `int16`, `int32`, `int64`, `uint8`, `uint16`, `uint32`, `uint64`, `float`, `float32`, `float64`, `decimal`, `decimal128`, `string`, `url`, `bytes`, `boolean`, `plainDate`, `plainTime`, `unknown`.

#### `SdkDateTimeType`
```typescript
type SdkDateTimeType = SdkUtcDateTimeType | SdkOffsetDateTimeType;
// kind: "utcDateTime" | "offsetDateTime"
// encode: DateTimeKnownEncoding | string (e.g., "rfc3339", "rfc7231", "unixTimestamp")
// wireType: SdkBuiltInType
```

#### `SdkDurationType`
```typescript
interface SdkDurationType extends SdkTypeBase {
  kind: "duration";
  encode: DurationKnownEncoding | string;
  wireType: SdkBuiltInType;
}
```

#### `SdkArrayType`
```typescript
interface SdkArrayType extends SdkTypeBase {
  kind: "array";
  name: string;
  valueType: SdkType;
  crossLanguageDefinitionId: string;
}
```

#### `SdkTupleType`
```typescript
interface SdkTupleType extends SdkTypeBase {
  kind: "tuple";
  valueTypes: SdkType[];
}
```

#### `SdkDictionaryType`
```typescript
interface SdkDictionaryType extends SdkTypeBase {
  kind: "dict";
  keyType: SdkType;
  valueType: SdkType;
}
```

#### `SdkNullableType`
```typescript
interface SdkNullableType extends SdkTypeBase {
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
interface SdkEnumType extends SdkTypeBase {
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
interface SdkEnumValueType extends SdkTypeBase {
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
interface SdkConstantType extends SdkTypeBase {
  kind: "constant";
  value: string | number | boolean;
  valueType: SdkBuiltInType;
  name: string;
  isGeneratedName: boolean;
}
```

#### `SdkUnionType`
```typescript
interface SdkUnionType<TValueType extends SdkTypeBase = SdkType> extends SdkTypeBase {
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
interface SdkModelType extends SdkTypeBase {
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
interface SdkCredentialType extends SdkTypeBase {
  kind: "credential";
  scheme: HttpAuth;
}
```

#### `SdkEndpointType`
```typescript
interface SdkEndpointType extends SdkTypeBase {
  kind: "endpoint";
  serverUrl: string;
  templateArguments: SdkPathParameter[];
}
```

### Property Types

#### `SdkModelPropertyTypeBase` (base interface)
Common properties for all parameter/property types:
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
  encode?: ArrayKnownEncoding;  // "pipeDelimited" | "spaceDelimited" | "commaDelimited" | "newlineDelimited"
}
```

#### `SdkModelPropertyType`
Model property with serialization info.
```typescript
interface SdkModelPropertyType extends SdkModelPropertyTypeBase {
  kind: "property";
  discriminator: boolean;
  serializedName: string;       // @deprecated: Use serializationOptions
  serializationOptions: SerializationOptions;
  isMultipartFileInput: boolean; // @deprecated: Use multipartOptions?.isFilePart
  multipartOptions?: MultipartOptions; // @deprecated: Use serializationOptions.multipart
}
```

#### `SdkMethodParameter`
```typescript
interface SdkMethodParameter extends SdkModelPropertyTypeBase {
  kind: "method";
}
```

#### `SdkHeaderParameter`
```typescript
interface SdkHeaderParameter extends SdkModelPropertyTypeBase {
  kind: "header";
  collectionFormat?: CollectionFormat;
  serializedName: string;
  correspondingMethodParams: (SdkMethodParameter | SdkModelPropertyType)[];  // @deprecated
  methodParameterSegments: (SdkMethodParameter | SdkModelPropertyType)[][];
}
```

#### `SdkQueryParameter`
```typescript
interface SdkQueryParameter extends SdkModelPropertyTypeBase {
  kind: "query";
  collectionFormat?: CollectionFormat;
  serializedName: string;
  correspondingMethodParams: (SdkMethodParameter | SdkModelPropertyType)[];  // @deprecated
  methodParameterSegments: (SdkMethodParameter | SdkModelPropertyType)[][];
  explode: boolean;
}
```

#### `SdkPathParameter`
```typescript
interface SdkPathParameter extends SdkModelPropertyTypeBase {
  kind: "path";
  explode: boolean;
  style: "simple" | "label" | "matrix" | "fragment" | "path";
  allowReserved: boolean;
  serializedName: string;
  correspondingMethodParams: (SdkMethodParameter | SdkModelPropertyType)[];  // @deprecated
  methodParameterSegments: (SdkMethodParameter | SdkModelPropertyType)[][];
}
```

#### `SdkCookieParameter`
```typescript
interface SdkCookieParameter extends SdkModelPropertyTypeBase {
  kind: "cookie";
  serializedName: string;
  correspondingMethodParams: (SdkMethodParameter | SdkModelPropertyType)[];  // @deprecated
  methodParameterSegments: (SdkMethodParameter | SdkModelPropertyType)[][];
}
```

#### `SdkBodyParameter`
```typescript
interface SdkBodyParameter extends SdkModelPropertyTypeBase {
  kind: "body";
  serializedName: string;
  contentTypes: string[];
  defaultContentType: string;
  correspondingMethodParams: (SdkMethodParameter | SdkModelPropertyType)[];  // @deprecated
  methodParameterSegments: (SdkMethodParameter | SdkModelPropertyType)[][];
  streamMetadata?: SdkStreamMetadata;
}
```

#### `SdkEndpointParameter`
```typescript
interface SdkEndpointParameter extends SdkModelPropertyTypeBase<SdkEndpointType | SdkUnionType<SdkEndpointType>> {
  kind: "endpoint";
  urlEncode: boolean;
  onClient: true;
  serializedName?: string;  // @deprecated
}
```

#### `SdkCredentialParameter`
```typescript
interface SdkCredentialParameter extends SdkModelPropertyTypeBase<SdkCredentialType | SdkUnionType<SdkCredentialType>> {
  kind: "credential";
  onClient: true;
}
```

### Serialization Types

#### `SerializationOptions`
```typescript
interface SerializationOptions {
  json?: JsonSerializationOptions;
  xml?: XmlSerializationOptions;
  multipart?: MultipartOptions;
  binary?: BinarySerializationOptions;
}
```

#### `JsonSerializationOptions`
```typescript
interface JsonSerializationOptions {
  name: string;  // From @encodedName("application/json", "NAME") or original name
}
```

#### `XmlSerializationOptions`
```typescript
interface XmlSerializationOptions {
  name: string;
  attribute?: boolean;
  ns?: { namespace: string; prefix: string; };
  unwrapped?: boolean;
  itemsName?: string;
  itemsNs?: { namespace: string; prefix: string; };
}
```

#### `BinarySerializationOptions`
```typescript
interface BinarySerializationOptions {
  isFile: boolean;
  isText?: boolean;      // Only when isFile=true
  contentTypes?: string[];  // Only when isFile=true
  filename?: ModelProperty; // Only when isFile=true
}
```

#### `MultipartOptions`
```typescript
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

### Method & Operation Types

#### `SdkMethod<TServiceOperation>` (union)
```typescript
type SdkMethod<TServiceOperation> = SdkServiceMethod<TServiceOperation>;
type SdkServiceMethod<TServiceOperation> =
  | SdkBasicServiceMethod<TServiceOperation>
  | SdkPagingServiceMethod<TServiceOperation>
  | SdkLroServiceMethod<TServiceOperation>
  | SdkLroPagingServiceMethod<TServiceOperation>;
```

All methods share a base interface with:
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

Method kinds:
- `SdkBasicServiceMethod`: `kind: "basic"`
- `SdkPagingServiceMethod`: `kind: "paging"` + `pagingMetadata: SdkPagingServiceMetadata`
- `SdkLroServiceMethod`: `kind: "lro"` + `lroMetadata: SdkLroServiceMetadata`
- `SdkLroPagingServiceMethod`: `kind: "lropaging"` + both metadata

#### `SdkHttpOperation`
```typescript
interface SdkHttpOperation {
  __raw: HttpOperation;
  kind: "http";
  path: string;
  uriTemplate: string;
  verb: HttpVerb;
  parameters: (SdkPathParameter | SdkQueryParameter | SdkHeaderParameter | SdkCookieParameter)[];
  bodyParam?: SdkBodyParameter;
  responses: SdkHttpResponse[];
  exceptions: SdkHttpErrorResponse[];
  examples?: SdkHttpOperationExample[];
}
```

### Response Types

#### `SdkMethodResponse`
```typescript
interface SdkMethodResponse {
  kind: "method";
  type?: SdkType;
  resultSegments?: SdkModelPropertyType[];  // For LRO/paging patterns
  optional?: boolean;  // True when operation has at least one response without body
  streamMetadata?: SdkStreamMetadata;
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
  statusCodes: number | HttpStatusCodeRange;
  contentTypes?: string[];
  defaultContentType?: string;
  description?: string;
  streamMetadata?: SdkStreamMetadata;
}
```

#### `SdkHttpErrorResponse`
Same as `SdkHttpResponse` but `statusCodes` also accepts `"*"`.

#### `SdkStreamMetadata`
```typescript
interface SdkStreamMetadata {
  bodyType: SdkType;       // Type of @body property
  originalType: SdkType;   // Stream model type (HttpStream, JsonlStream, SSEStream)
  streamType: SdkType;     // Payload model being streamed
  contentTypes: string[];  // e.g., ["application/jsonl"], ["text/event-stream"]
}
```

### Paging Metadata

#### `SdkPagingServiceMetadata`
```typescript
interface SdkPagingServiceMetadata<TServiceOperation> {
  __raw?: PagingOperation;
  nextLinkSegments?: (SdkServiceResponseHeader | SdkModelPropertyType)[];
  nextLinkOperation?: SdkServiceMethod<TServiceOperation>;
  nextLinkVerb?: "GET" | "POST";
  nextLinkReInjectedParametersSegments?: (SdkMethodParameter | SdkModelPropertyType)[][];
  continuationTokenParameterSegments?: (SdkMethodParameter | SdkModelPropertyType)[];
  continuationTokenResponseSegments?: (SdkServiceResponseHeader | SdkModelPropertyType)[];
  pageItemsSegments?: SdkModelPropertyType[];
  pageSizeParameterSegments?: (SdkMethodParameter | SdkModelPropertyType)[];
}
```

### LRO Metadata

#### `SdkLroServiceMetadata`
```typescript
interface SdkLroServiceMetadata {
  __raw: LroMetadata;
  finalStateVia: FinalStateValue;
  pollingStep: SdkLroServicePollingStep;
  finalStep?: SdkLroServiceFinalStep;
  finalResponse?: SdkLroServiceFinalResponse;
  // Extra metadata
  operation: SdkServiceOperation;
  logicalResult: SdkModelType;
  statusMonitorStep?: SdkNextOperationLink | SdkNextOperationReference;
  pollingInfo: SdkPollingOperationStep;
  envelopeResult: SdkModelType;
  logicalPath?: string;
  finalResult?: SdkModelType | SdkArrayType | SdkBuiltInType<"unknown"> | "void";
  finalEnvelopeResult?: SdkModelType | SdkArrayType | SdkBuiltInType<"unknown"> | "void";
  finalResultPath?: string;
}
```

### Enums/Flags (TypeScript)

#### `UsageFlags`
```typescript
enum UsageFlags {
  None = 0,
  Input = 1 << 1,           // 2
  Output = 1 << 2,          // 4
  ApiVersionEnum = 1 << 3,  // 8
  JsonMergePatch = 1 << 4,  // 16 (Input+Json also set)
  MultipartFormData = 1 << 5, // 32 (Input also set)
  Spread = 1 << 6,          // 64
  Json = 1 << 8,            // 256
  Xml = 1 << 9,             // 512
  Exception = 1 << 10,      // 1024
  LroInitial = 1 << 11,     // 2048
  LroPolling = 1 << 12,     // 4096
  LroFinalEnvelope = 1 << 13, // 8192
  External = 1 << 14,       // 16384
}
```

#### `InitializedByFlags`
```typescript
enum InitializedByFlags {
  Default = 0,
  Individually = 1 << 0,  // 1
  Parent = 1 << 1,        // 2
  CustomizeCode = 1 << 2, // 4
}
```

#### `AccessFlags`
```typescript
type AccessFlags = "internal" | "public";
```

### Decorated Type System

#### `DecoratedType`
```typescript
interface DecoratedType {
  decorators: DecoratorInfo[];  // Only decorators in allowlist
}

interface DecoratorInfo {
  name: string;                    // Fully qualified: "TypeSpec.@encode", "TypeSpec.Xml.@attribute"
  arguments: Record<string, any>;
}
```

### Example Types

#### `SdkHttpOperationExample`
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
```

#### `SdkExampleValue` (union)
```typescript
type SdkExampleValue =
  | SdkStringExampleValue    // kind: "string"
  | SdkNumberExampleValue    // kind: "number"
  | SdkBooleanExampleValue   // kind: "boolean"
  | SdkNullExampleValue      // kind: "null"
  | SdkUnknownExampleValue   // kind: "unknown"
  | SdkArrayExampleValue     // kind: "array"
  | SdkDictionaryExampleValue // kind: "dict"
  | SdkUnionExampleValue     // kind: "union"
  | SdkModelExampleValue;    // kind: "model"
```

### License Types

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

### Other Type Aliases

```typescript
type SdkHttpPackage = SdkPackage<SdkHttpOperation>;
type LanguageScopes = "dotnet" | "java" | "python" | "javascript" | "go" | string;
type CollectionFormat = "multi" | "csv" | "ssv" | "tsv" | "pipes" | "simple" | "form";
type SdkServiceOperation = SdkHttpOperation;  // Currently only HTTP; gRPC planned
```

---

## Public Utility Functions

Exported from `src/public-utils.ts`.

### API Version & Parameter Handling

| Function | Signature | Description |
|----------|-----------|-------------|
| `getDefaultApiVersion` | `(context: TCGCContext, serviceNamespace: Namespace) => Version \| undefined` | Returns the default/latest API version for a versioned service |
| `isApiVersion` | `(context: TCGCContext, type: ModelProperty) => boolean` | Checks if a property is an API version parameter |
| `getEffectivePayloadType` | `(context: TCGCContext, type: Model, visibility?: Visibility) => Model` | Converts anonymous models to named equivalents |

### Naming & Identification

| Function | Signature | Description |
|----------|-----------|-------------|
| `getPropertyNames` | `(context: TCGCContext, property: ModelProperty) => [string, string]` | Returns `[libraryName, wireName]` |
| `getLibraryName` | `(context: TCGCContext, type: Type & { name?: string \| symbol }, scope?: string \| typeof AllScopes) => string` | Gets language-specific or client-friendly name |
| `getWireName` | `(context: TCGCContext, type: Type & { name: string }) => string` | Gets serialized/wire name |
| `getCrossLanguageDefinitionId` | `(context: TCGCContext, type: ..., operation?: Operation, appendNamespace?: boolean) => string` | Creates fully-qualified cross-language identifier |
| `getCrossLanguagePackageId` | `(context: TCGCContext) => [string, readonly Diagnostic[]]` | Returns cross-language package ID |
| `getGeneratedName` | `(context: TCGCContext, type: Model \| Union \| TspLiteralType, operation?: Operation) => string` | Creates names for anonymous models/unions |

### HTTP & Operation Handling

| Function | Signature | Description |
|----------|-----------|-------------|
| `getHttpOperationWithCache` | `(context: TCGCContext, operation: Operation) => HttpOperation` | Gets HttpOperation with caching |
| `getHttpOperationExamples` | `(context: TCGCContext, operation: HttpOperation) => SdkHttpOperationExample[]` | Retrieves examples for an operation |
| `getHttpOperationParameter` | `(method: SdkServiceMethod<SdkHttpOperation>, param: ...) => SdkHttpParameter \| SdkModelPropertyType \| undefined` | Maps method param to HTTP param |
| `getHttpOperationParametersForClientParameter` | `(client: SdkClientType<SdkHttpOperation>, param: ...) => (SdkHttpParameter \| SdkModelPropertyType)[]` | Finds HTTP params for a client param |
| `resolveOperationId` | `(context: TCGCContext, operation: Operation, honorRenaming?: boolean) => string` | Calculates operation ID |

### Type Detection

| Function | Signature | Description |
|----------|-----------|-------------|
| `isHttpMetadata` | `(context: TCGCContext, property: SdkModelPropertyType) => boolean` | Checks if property is HTTP metadata |
| `isAzureCoreModel` | `(t: SdkType) => boolean` | Checks if type is an Azure Core model |
| `isPagedResultModel` | `(context: TCGCContext, t: SdkType) => boolean` | Checks if type is a paged result model |

### Namespace & Client Options

| Function | Signature | Description |
|----------|-----------|-------------|
| `getNamespaceFromType` | `(type: Type \| SdkClient \| SdkOperationGroup \| undefined) => Namespace \| undefined` | Extracts namespace from various types |
| `listAllServiceNamespaces` | `(context: TCGCContext) => Namespace[]` | Lists all service namespaces |
| `getClientOptions` | `<T extends DecoratedType>(type: T, key: string) => unknown` | Retrieves `@clientOption` value by key |

---

## Type Building Functions

Exported from `src/types.ts`.

### Built-in Type Conversion

| Function | Signature | Description |
|----------|-----------|-------------|
| `getTypeSpecBuiltInType` | `(context: TCGCContext, kind: IntrinsicScalarName) => SdkBuiltInType` | Converts TypeSpec scalar kind to SDK built-in type |
| `getSdkBuiltInType` | `(context: TCGCContext, type: Scalar \| IntrinsicType \| ...) => SdkDateTimeType \| SdkDurationType \| SdkBuiltInType` | Converts scalars/literals to SDK types |
| `getSdkDurationType` | `(context: TCGCContext, type: Scalar) => SdkDurationType` | Converts Scalar to duration type |
| `addEncodeInfo` | `(context: TCGCContext, type: ModelProperty \| Scalar, propertyType: SdkType, defaultContentType?: string) => [void, readonly Diagnostic[]]` | Adds encoding information to types |

### Collection Types

| Function | Signature | Description |
|----------|-----------|-------------|
| `getSdkArrayOrDict` | `(context: TCGCContext, type: Model, operation?: Operation) => (SdkDictionaryType \| SdkArrayType) \| undefined` | Identifies and converts array/dict models |
| `getSdkTuple` | `(context: TCGCContext, type: Tuple, operation?: Operation) => SdkTupleType` | Converts TypeSpec Tuple to SDK tuple |

### Union, Enum & Constant Types

| Function | Signature | Description |
|----------|-----------|-------------|
| `getSdkUnion` | `(context: TCGCContext, type: Union, operation?: Operation) => SdkType` | Converts Union (handles nullable, union-as-enum) |
| `getSdkConstant` | `(context: TCGCContext, type: StringLiteral \| NumericLiteral \| BooleanLiteral, operation?: Operation) => SdkConstantType` | Converts literals to constants |
| `getSdkEnum` | `(context: TCGCContext, type: Enum, operation?: Operation) => SdkEnumType` | Converts TypeSpec Enum to SDK enum |
| `getSdkEnumValue` | `(context: TCGCContext, enumType: SdkEnumType, type: EnumMember) => SdkEnumValueType` | Converts enum member to value |
| `getSdkUnionEnum` | `(context: TCGCContext, type: UnionEnum, operation?: Operation) => SdkEnumType` | Converts union-as-enum patterns |

### Model Types

| Function | Signature | Description |
|----------|-----------|-------------|
| `getSdkModel` | `(context: TCGCContext, type: Model, operation?: Operation) => SdkModelType` | Converts Model to SDK model |
| `getSdkModelPropertyType` | `(context: TCGCContext, type: ModelProperty, operation?: Operation) => [SdkModelPropertyType, readonly Diagnostic[]]` | Converts property to SDK property |
| `getSdkModelPropertyTypeBase` | `(context: TCGCContext, type: ModelProperty, operation?: Operation) => [SdkModelPropertyTypeBase, readonly Diagnostic[]]` | Builds base property type |

### General Conversion

| Function | Signature | Description |
|----------|-----------|-------------|
| `getClientType` | `(context: TCGCContext, type: Type, operation?: Operation) => SdkType` | Main entry: converts any TypeSpec Type to SDK type |
| `getClientTypeWithDiagnostics` | `(context: TCGCContext, type: Type, operation?: Operation) => [SdkType, readonly Diagnostic[]]` | Same with diagnostics |

### Usage & Access

| Function | Signature | Description |
|----------|-----------|-------------|
| `updateUsageOrAccess` | `(context: TCGCContext, value: UsageFlags \| AccessFlags, type?: SdkType, options?: PropagationOptions) => [void, readonly Diagnostic[]]` | Updates and propagates usage/access flags |
| `getAllModels` | `(context: TCGCContext, options?: UsageFilteringOptions) => (SdkModelType \| SdkEnumType)[]` | Returns all models/enums |
| `getAllModelsWithDiagnostics` | `(context: TCGCContext, options?: UsageFilteringOptions) => [(SdkModelType \| SdkEnumType)[], readonly Diagnostic[]]` | Same with diagnostics |
| `getAllReferencedTypes` | `(context: TCGCContext, options?: UsageFilteringOptions) => (SdkModelType \| SdkEnumType \| SdkUnionType \| SdkNullableType)[]` | All referenced types including unions/nullables |
| `handleAllTypes` | `(context: TCGCContext) => [void, readonly Diagnostic[]]` | Entry point for building usage info |

### Other

| Function | Signature | Description |
|----------|-----------|-------------|
| `isReadOnly` | `(property: SdkModelPropertyTypeBase) => boolean` | Checks if property is read-only |
| `getSdkCredentialParameter` | `(context: TCGCContext, client: SdkClientType<SdkHttpOperation>) => SdkCredentialParameter \| undefined` | Builds credential parameter from auth |

---

## Context and SDK Creation

Exported from `src/context.ts`.

### `createTCGCContext`
```typescript
function createTCGCContext(program: Program, emitterName?: string, options?: CreateTCGCContextOptions): TCGCContext;
```
Creates the base TCGC context with caching infrastructure and helper methods.

### `createSdkContext`
```typescript
async function createSdkContext<TOptions, TServiceOperation>(
  context: EmitContext<TOptions>,
  emitterName?: string,
  options?: CreateSdkContextOptions,
): Promise<SdkContext<TOptions, TServiceOperation>>;
```
Creates the full SDK context, including building the `sdkPackage`, loading examples, and running validations.

`CreateSdkContextOptions`:
```typescript
interface CreateSdkContextOptions {
  versioning?: { previewStringRegex?: RegExp; };
  additionalDecorators?: string[];
  disableUsageAccessPropagationToBase?: boolean;
  exportTCGCoutput?: boolean;
  flattenUnionAsEnum?: boolean;
  enableLegacyHierarchyBuilding?: boolean;
}
```

### `$onEmit`
```typescript
async function $onEmit(context: EmitContext<TCGCEmitterOptions>): Promise<void>;
```
Default emitter entry point. Exports TCGC output as YAML.

---

## Emitter Options

Configurable in `tspconfig.yaml` under the `@azure-tools/typespec-client-generator-core` emitter.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `emitter-name` | `string` | Auto-detected | Specifies the target language emitter name for scoped output |
| `generate-protocol-methods` | `boolean` | `true` | Generate low-level protocol methods (unless `@protocolAPI` overrides) |
| `generate-convenience-methods` | `boolean` | `true` | Generate convenience methods (unless `@convenientAPI` overrides) |
| `api-version` | `string` | Latest | Target API version. Also accepts `"latest"` and `"all"` |
| `examples-dir` | `string` | `./examples` | Directory for example files |
| `namespace` | `string` | From spec | Override namespace for all spec types |
| `license` | `object` | None | License info: `{ name, company?, link?, header?, description? }` |

Predefined licenses: MIT License, Apache License 2.0, BSD 3-Clause License, MPL 2.0, GPL-3.0, LGPL-3.0.

---

## Linter Rules

Registered in `src/linter.ts`. Rule implementations in `src/rules/`.

### `require-client-suffix`
- **ID:** `@azure-tools/typespec-client-generator-core/require-client-suffix`
- **Severity:** Warning
- **Checks:** Client names (from `@client` decorator) end with `"Client"`.
- **Message:** `Client name "${"name"}" must end with Client.`
- **File:** `src/rules/require-client-suffix.rule.ts`

### `no-unnamed-types`
- **ID:** `@azure-tools/typespec-client-generator-core/no-unnamed-types`
- **Severity:** Warning
- **Checks:** Models and unions have explicit names (not auto-generated). Excludes LRO initial operations and multipart types.
- **Message:** `Anonymous ${"type"} with generated name "${"generatedName"}" detected.`
- **File:** `src/rules/no-unnamed-types.rule.ts`

### `property-name-conflict`
- **ID:** `@azure-tools/typespec-client-generator-core/property-name-conflict`
- **Severity:** Warning
- **Checks:** Model property name doesn't match enclosing model name (case-insensitive). Causes issues in C#.
- **Message:** `Property '${"propertyName"}' having the same name as its enclosing model will cause problems with C# code generation.`
- **File:** `src/rules/property-name-conflict.rule.ts`

**Rule sets:**
- `best-practices:csharp`: Enables `property-name-conflict`

---

## Diagnostic Codes

Complete list of diagnostic codes from `src/lib.ts`. Each code is prefixed with `@azure-tools/typespec-client-generator-core/` when reported.

### Errors

| Code | Message |
|------|---------|
| `invalid-access` | Access value must be "public" or "internal" |
| `invalid-usage` | Usage value must be one of: 2, 4, 256, or 512 |
| `conflicting-multipart-model-usage` | Model used as both multipart and regular body input |
| `discriminator-not-constant` | Discriminator must be constant |
| `server-param-not-path` | Template argument is not a path parameter |
| `unexpected-http-param-type` | Parameter has unexpected type |
| `no-corresponding-method-param` | Missing HTTP operation parameter in method |
| `unsupported-protocol` | Only HTTP/HTTPS protocols supported |
| `override-parameters-mismatch` | Override method has different parameters |
| `duplicate-client-name` | Duplicate client names in language scope |
| `duplicate-example-file` | Duplicate example file titles for operationId |
| `flatten-polymorphism` | Cannot flatten polymorphic type property |
| `unexpected-pageable-operation-return-type` | Pageable operation return type incorrect |
| `invalid-alternate-type` | Alternate type kind mismatch |
| `invalid-initialized-by` | Invalid initializedBy value |
| `invalid-deserializeEmptyStringAsNull-target-type` | Can only apply to string types |
| `invalid-client-doc-mode` | Invalid mode for @clientDoc |
| `legacy-hierarchy-building-circular-reference` | @hierarchyBuilding causes circular reference |
| `multiple-explicit-clients-multiple-services` | Multiple explicit clients with multiple services |
| `invalid-client-service-multiple` | @client with multiple services only on Namespace |
| `inconsistent-multiple-service` | Services must have same server/auth definitions |

### Warnings

| Code | Message |
|------|---------|
| `multiple-services` | Multiple services found; only first is used |
| `client-service` | Client not inside a service namespace |
| `union-null` | Union containing only null types |
| `union-circular` | Union containing self reference |
| `discriminator-not-string` | Discriminator value must be string |
| `wrong-client-decorator` | @client/@operationGroup on wrong type |
| `unsupported-kind` | Unsupported type kind |
| `multiple-response-types` | Operation returns multiple response types |
| `no-emitter-name` | Cannot find emitter name |
| `unsupported-generic-decorator-arg-type` | Cannot parse decorator argument type |
| `empty-client-name` | Empty value passed to @clientName |
| `duplicate-client-name-warning` | Duplicate client names (C# overloads) |
| `client-name-ineffective` | @clientName on override method not effective |
| `example-loading` | Invalid example file or directory |
| `example-value-no-mapping` | Example value doesn't match definition |
| `conflict-access-override` | @access override conflicts with calculated |
| `duplicate-decorator` | Decorator used twice with same scope |
| `empty-client-namespace` | Empty value to @clientNamespace |
| `api-version-not-string` | API version must be string or string enum |
| `invalid-encode-for-collection-format` | Invalid encoding for collection format |
| `non-head-bool-response-decorator` | @responseAsBool only for HEAD operations |
| `require-versioned-service` | Service must be versioned for decorator |
| `missing-service-versions` | @clientApiVersions missing required versions |
| `multiple-param-alias` | Multiple parameter aliases; only first used |
| `client-location-conflict` | @clientLocation conflicts with @client/@operationGroup |
| `client-location-wrong-type` | @clientLocation can only move to root namespace |
| `legacy-hierarchy-building-conflict` | @hierarchyBuilding decorator conflicts |
| `missing-scope` | @scope should have language-specific decorator |
| `external-library-version-mismatch` | Multiple versions of external library |
| `external-type-on-model-property` | @alternateType with external type on property |
| `invalid-mark-as-lro-target` | @markAsLro applied to non-model operation |
| `mark-as-lro-ineffective` | @markAsLro redundant with real LRO metadata |
| `invalid-mark-as-pageable-target` | @markAsPageable wrong target |
| `mark-as-pageable-ineffective` | @markAsPageable redundant with @list |
| `api-version-undefined` | API version not in service versioning list |
| `client-option` | @clientOption experimental; requires suppression |
| `client-option-requires-scope` | @clientOption needs language scope |

---

## Feature Areas

These are the major functional areas of TCGC, organized by capability.

### 1. Client Structure & Hierarchy
- **Decorators:** `@client`, `@operationGroup`, `@clientLocation`
- **Types:** `SdkClient`, `SdkOperationGroup`, `SdkClientType`
- **Description:** Defines root clients and sub-clients. Auto-detection from service namespaces/interfaces, or explicit declaration via decorators. `@clientLocation` can move operations between clients.
- **Tests:** `test/decorators/client.test.ts`, `test/decorators/client-location.test.ts`, `test/clients/structure.test.ts`

### 2. Client Initialization
- **Decorators:** `@clientInitialization`, `@paramAlias`
- **Types:** `SdkClientInitializationType`, `InitializedByFlags`
- **Enums:** `InitializedBy { individually, parent, customizeCode }`
- **Description:** Controls how clients are initialized. Elevates operation parameters to client level. Supports individual, parent, or combined initialization modes.
- **Tests:** `test/decorators/client-initialization.test.ts`, `test/decorators/param-alias.test.ts`, `test/clients/params.test.ts`

### 3. Client Naming & Namespacing
- **Decorators:** `@clientName`, `@clientNamespace`
- **Description:** Overrides generated names and namespaces for SDK elements. Supports per-language scoping.
- **Tests:** `test/decorators/client-name.test.ts`

### 4. Method Generation Control
- **Decorators:** `@convenientAPI`, `@protocolAPI`
- **Description:** Controls whether operations generate convenience methods, protocol methods, or both.
- **Tests:** `test/decorators/convenient-api.test.ts`, `test/decorators/protocol-api.test.ts`

### 5. Method Override
- **Decorators:** `@override`
- **Description:** Customizes method parameter signatures (e.g., group parameters into an option bag, change optionality).
- **Tests:** `test/decorators/override.test.ts`

### 6. Usage & Access Control
- **Decorators:** `@usage`, `@access`
- **Enums:** `Usage { input, output, json, xml }`, `Access { public, internal }`
- **Description:** Controls visibility and usage tracking of types. Propagates through type hierarchies.
- **Tests:** `test/decorators/usage.test.ts`, `test/decorators/usage-extended.test.ts`, `test/decorators/access.test.ts`

### 7. API Versioning
- **Decorators:** `@apiVersion`, `@clientApiVersions`
- **Description:** Marks API version parameters and specifies additional client API versions.
- **Tests:** `test/decorators/api-version.test.ts`, `test/decorators/client-api-versions.test.ts`, `test/package/versioning.test.ts`

### 8. Type System
- **Types:** All `Sdk*Type` types
- **Description:** Comprehensive type graph covering built-in scalars, datetime, duration, arrays, tuples, dicts, nullables, enums, constants, unions, models, credentials, endpoints.
- **Tests:** `test/types/` (18 test files covering each type)

### 9. Alternate Types
- **Decorators:** `@alternateType`
- **Description:** Replaces types at serialization level. Supports TypeSpec types and external types with package info.
- **Tests:** `test/decorators/alternate-type.test.ts`

### 10. Serialization
- **Types:** `SerializationOptions`, `JsonSerializationOptions`, `XmlSerializationOptions`, `BinarySerializationOptions`, `MultipartOptions`
- **Description:** Handles JSON, XML, binary, and multipart serialization options on models and properties.
- **Tests:** `test/types/serialization-options.test.ts`, `test/types/multipart.test.ts`

### 11. Paging Operations
- **Types:** `SdkPagingServiceMethod`, `SdkPagingServiceMetadata`
- **Legacy decorators:** `@markAsPageable`, `@disablePageable`, `@nextLinkVerb`
- **Description:** Handles paged list operations with next link, continuation token, and page items extraction.
- **Tests:** `test/methods/paged-operation.test.ts`, `test/decorators/mark-as-pageable.test.ts`, `test/decorators/disable-pageable.test.ts`, `test/decorators/next-link-verb.test.ts`

### 12. Long-Running Operations (LRO)
- **Types:** `SdkLroServiceMethod`, `SdkLroServiceMetadata`
- **Legacy decorators:** `@markAsLro`
- **Description:** Handles LRO patterns with polling, final state, and status monitor metadata.
- **Tests:** `test/methods/lro.test.ts`, `test/decorators/mark-as-lro.test.ts`

### 13. Streaming
- **Types:** `SdkStreamMetadata`
- **Description:** Handles streaming responses (JsonlStream, SSEStream) with content type and payload type metadata.
- **Tests:** `test/methods/streams.test.ts`

### 14. File Operations
- **Types:** `BinarySerializationOptions` (isFile, isText, contentTypes, filename)
- **Description:** Handles file upload/download with multipart and binary content types.
- **Tests:** `test/methods/file.test.ts`

### 15. Property Flattening
- **Legacy decorators:** `@flattenProperty`
- **Description:** Flattens model properties for backward compatibility with Swagger-generated SDKs.
- **Tests:** `test/decorators/flatten-property.test.ts`

### 16. Documentation Override
- **Decorators:** `@clientDoc`
- **Enums:** `DocumentationMode { append, replace }`
- **Description:** Overrides or appends client-specific documentation on types.
- **Tests:** `test/decorators/client-doc.test.ts`

### 17. Deserialization Behavior
- **Decorators:** `@deserializeEmptyStringAsNull`
- **Description:** Controls deserialization of empty strings as null for string properties.
- **Tests:** `test/decorators/deserialize-empty-string-as-null.test.ts`

### 18. HEAD Response as Boolean
- **Decorators:** `@responseAsBool`
- **Description:** Makes HEAD operations return boolean instead of void.
- **Tests:** `test/decorators/response-as-bool.test.ts`

### 19. Scope Control
- **Decorators:** `@scope`
- **Description:** Controls which language emitters see an operation or model property.
- **Tests:** `test/decorators/scope.test.ts`

### 20. Legacy Model Hierarchy
- **Legacy decorators:** `@hierarchyBuilding`
- **Description:** Supports multi-level inheritance for discriminated models in brownfield scenarios.
- **Tests:** `test/decorators/legacy-hierarchy-building.test.ts`

### 21. Default Values
- **Legacy decorators:** `@clientDefaultValue`
- **Description:** Sets client-level default values on properties/parameters for backward compatibility.
- **Tests:** `test/decorators/client-default-value.test.ts`

### 22. Client Options (Experimental)
- **Decorators:** `@clientOption`
- **Description:** Passes experimental flags to emitters without TCGC reshipping.
- **Tests:** `test/decorators/client-option.test.ts`

### 23. Multiple Services
- **Decorator:** `@client` with `service: Namespace[]`
- **Description:** Supports merging multiple service namespaces into a single client package.
- **Tests:** (covered by client.test.ts and structure.test.ts)

### 24. Examples
- **Types:** `SdkHttpOperationExample`, `SdkExampleValue`
- **Description:** Loads and parses operation examples from files.
- **Tests:** `test/examples/` (4 test files)

### 25. License
- **Types:** `LicenseInfo`
- **Description:** Generates license information for client code.
- **Tests:** `test/package/license.test.ts`

### 26. System Text JSON Converter
- **Decorators:** `@useSystemTextJsonConverter`
- **Description:** Marks models needing custom JSON converters (C# backward compatibility).
- **Tests:** (covered in decorator tests)

---

## Test File Locations

All tests are under `packages/typespec-client-generator-core/test/`.

### Core Tests
- `context.test.ts` — SDK context handling
- `internal-utils.test.ts` — Internal utilities

### Client Tests (`test/clients/`)
- `params.test.ts` — Client parameters (credential, endpoint, auth)
- `structure.test.ts` — Client hierarchy, grouping, initialization

### Decorator Tests (`test/decorators/`)
- `access.test.ts`
- `alternate-type.test.ts`
- `api-version.test.ts`
- `client-api-versions.test.ts`
- `client-default-value.test.ts`
- `client-doc.test.ts`
- `client-initialization.test.ts`
- `client-location.test.ts`
- `client-name.test.ts`
- `client-option.test.ts`
- `client.test.ts`
- `convenient-api.test.ts`
- `deserialize-empty-string-as-null.test.ts`
- `disable-pageable.test.ts`
- `flatten-property.test.ts`
- `general-list.test.ts`
- `legacy-hierarchy-building.test.ts`
- `mark-as-lro.test.ts`
- `mark-as-pageable.test.ts`
- `next-link-verb.test.ts`
- `override.test.ts`
- `param-alias.test.ts`
- `protocol-api.test.ts`
- `response-as-bool.test.ts`
- `scope.test.ts`
- `usage.test.ts`
- `usage-extended.test.ts`

### Example Tests (`test/examples/`)
- `helper.test.ts`
- `http-operation-examples.test.ts`
- `load.test.ts`
- `types.test.ts`

### HTTP Tests (`test/http/`)
- `body.test.ts`
- `method-parameter-segments.test.ts`
- `path.test.ts`

### Method Tests (`test/methods/`)
- `file.test.ts`
- `lro.test.ts`
- `paged-operation.test.ts`
- `parameters.test.ts`
- `responses.test.ts`
- `spread.test.ts`
- `streams.test.ts`

### Package Tests (`test/package/`)
- `api-versions-metadata.test.ts`
- `azure-widget-service.test.ts`
- `license.test.ts`
- `models-only.test.ts`
- `vanilla-widget-service.test.ts`
- `versioning.test.ts`

### Public Utils Tests (`test/public-utils/`)
- `get-cross-language-definition-id.test.ts`
- `get-default-api-version.test.ts`
- `get-effective-payload-type.test.ts`
- `get-generated-name.test.ts`
- `get-http-operation-parameter.test.ts`
- `get-http-operation-parameters-for-client-parameter.test.ts`
- `get-library-name.test.ts`
- `get-property-names.test.ts`
- `is-api-version.test.ts`
- `is-http-metadata.test.ts`
- `is-paged-result-model.test.ts`

### Type Tests (`test/types/`)
- `array.test.ts`
- `body-model-property.test.ts`
- `built-in.test.ts`
- `bytes.test.ts`
- `constant.test.ts`
- `date-time.test.ts`
- `dictionary.test.ts`
- `doc-summary.test.ts`
- `duration.test.ts`
- `encode-merge-patch.test.ts`
- `enum.test.ts`
- `model.test.ts`
- `multipart.test.ts`
- `serialization-options.test.ts`
- `tuple.test.ts`
- `union.test.ts`
- `usage-flags.test.ts`

### Rule Tests (`test/rules/`)
- `no-unnamed-types.test.ts`
- `property-name-conflict.test.ts`
- `require-client-suffix.test.ts`

### Validation Tests (`test/validations/`)
- `package.test.ts`
- `types.test.ts`

---

## Existing Documentation Files

### User Documentation
Location: `website/src/content/docs/docs/howtos/Generate client libraries/`

| File | Topic |
|------|-------|
| `00howtogen.mdx` | Overview of client generation |
| `01setup.mdx` | Setup and configuration |
| `02package.mdx` | Package configuration |
| `03client.mdx` | Client definition and structure |
| `04method.mdx` | Method generation |
| `05pagingOperations.mdx` | Paging operations |
| `06longRunningOperations.mdx` | Long-running operations |
| `07multipart.mdx` | Multipart form data |
| `08types.mdx` | Type system |
| `09renaming.mdx` | Renaming with @clientName |
| `10versioning.mdx` | API versioning |
| `11hierarchyBuilding.mdx` | Legacy hierarchy building |
| `12clientOptions.mdx` | Client options (@clientOption) |

### Emitter Developer Documentation
- `website/src/content/docs/docs/libraries/typespec-client-generator-core/guideline.md` — Comprehensive guide covering TCGC library usage, type graph structure, and calculation logic (369 lines)

### Design Documents
Location: `packages/typespec-client-generator-core/design-docs/`

| File | Topic |
|------|-------|
| `client.md` | Client type design (initialization patterns, hierarchy, customization) |
| `multiple-services.md` | Multiple service support design (combining services into single SDK) |

---

## Spector Spec Coverage

Location: `packages/azure-http-specs/specs/azure/client-generator-core/`

### Specs with Coverage

| Spec Directory | Feature Area |
|----------------|-------------|
| `access/` | `@access` decorator |
| `alternate-type/` | `@alternateType` decorator |
| `api-version/header/` | API version in header |
| `api-version/path/` | API version in path |
| `api-version/query/` | API version in query |
| `client-default-value/` | `@clientDefaultValue` decorator |
| `client-initialization/default/` | Default client initialization |
| `client-initialization/individually/` | Individual client initialization |
| `client-initialization/individuallyParent/` | Individual + parent initialization |
| `client-location/move-method-parameter-to-client/` | Move parameter to client |
| `client-location/move-to-existing-sub-client/` | Move operation to existing sub-client |
| `client-location/move-to-new-sub-client/` | Move operation to new sub-client |
| `client-location/move-to-root-client/` | Move operation to root client |
| `deserialize-empty-string-as-null/` | `@deserializeEmptyStringAsNull` decorator |
| `flatten-property/` | `@flattenProperty` decorator |
| `hierarchy-building/` | `@hierarchyBuilding` decorator |
| `next-link-verb/` | `@nextLinkVerb` decorator |
| `override/` | `@override` decorator |
| `usage/` | `@usage` decorator |

### Features WITHOUT Spector Coverage
These features have TCGC unit tests but no dedicated Spector specs:

- `@clientName` / `@clientNamespace` — Renaming/namespacing
- `@convenientAPI` / `@protocolAPI` — Method generation control
- `@client` / `@operationGroup` — Explicit client/operation group definition
- `@clientDoc` — Documentation override
- `@scope` — Language scoping
- `@paramAlias` — Parameter aliasing (only covered as part of `@clientInitialization` specs)
- `@responseAsBool` — HEAD response as boolean
- `@apiVersion` — API version parameter marking
- `@clientApiVersions` — Additional API versions
- `@markAsLro` — Force LRO treatment
- `@markAsPageable` / `@disablePageable` — Force/disable pagination
- `@clientOption` — Experimental options
- `@useSystemTextJsonConverter` — C# JSON converter
- Multiple services — Combining service namespaces

---

## Design Documents

### `design-docs/client.md`
Covers the client type design in TCGC:
- User scenarios for single clients and sub-clients
- Initialization patterns (individually, parent-only, combined)
- `SdkClientType`, `SdkInitializationType`, `initializedBy` property
- Examples of `@client`, `@operationGroup`, `@clientInitialization` usage
- YAML output examples showing generated type structures

### `design-docs/multiple-services.md`
Covers multiple service support:
- Syntax: `@client({service: [ServiceA, ServiceB]})` with array of service namespaces
- `@useDependency` for version specification
- TCGC behavior: creates root client with `apiVersions: []`, sub-clients for each service
- Operation group merging for name conflicts
- `@clientLocation` interaction with multiple services
- `apiVersionsMap` property for per-service version tracking
