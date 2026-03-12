# TypeSpec Client Generator Core (TCGC) — Package Knowledge Base

This knowledge base serves as the authoritative reference for a documentation-update agent
maintaining TCGC docs. It covers decorators, the client type graph, public APIs, emitter
options, linter rules, test coverage, Spector specs, and existing documentation.

Package name: `@azure-tools/typespec-client-generator-core`
TypeSpec namespace: `Azure.ClientGenerator.Core` (legacy: `Azure.ClientGenerator.Core.Legacy`)
Source: `packages/typespec-client-generator-core/`

---

## 1. Decorators

All decorators accept an optional trailing `scope?: valueof string` parameter that targets
specific language emitters. Scope patterns:

- Single: `"python"`
- Multiple: `"python, java"`
- Negation: `"!csharp"` or `"!(java, python)"`
- Supported identifiers: `csharp`, `python`, `java`, `javascript`, `go`

### 1.1 Core Decorators (`Azure.ClientGenerator.Core`)

Defined in `lib/decorators.tsp`, implemented in `src/decorators.ts`.

#### `@clientName`

```typespec
extern dec clientName(target: unknown, rename: valueof string, scope?: valueof string);
```

Overrides generated name for any SDK element (clients, methods, parameters, unions, models,
enums, model properties). Takes precedence over all other naming.

#### `@convenientAPI`

```typespec
extern dec convenientAPI(
  target: Operation | Namespace | Interface,
  flag?: valueof boolean,
  scope?: valueof string
);
```

Controls whether to generate a convenience method. When applied to a namespace or interface,
it affects all operations within that scope unless explicitly overridden. Default: `true`.

#### `@protocolAPI`

```typespec
extern dec protocolAPI(
  target: Operation | Namespace | Interface,
  flag?: valueof boolean,
  scope?: valueof string
);
```

Controls whether to generate a protocol (low-level) method. Same scope inheritance as
`@convenientAPI`. Default: `true`.

#### `@client`

```typespec
extern dec client(target: Namespace | Interface, options?: ClientOptions, scope?: valueof string);

model ClientOptions {
  service?: Namespace | Namespace[];
  name?: string;
}
```

Defines a root client. When any `@client`/`@operationGroup` is present, those definitions
control the client hierarchy. Cannot be used with `@clientLocation`. Cannot be used as
augmentation.

#### `@operationGroup`

```typespec
extern dec operationGroup(target: Namespace | Interface, scope?: valueof string);
```

Defines a sub-client (operation group). Cannot be used with `@clientLocation`. Cannot be used
as augmentation.

#### `@usage`

```typespec
extern dec usage(
  target: Model | Enum | Union | Namespace,
  value: EnumMember | Union,
  scope?: valueof string
);
```

Adds additional usage info to models/enums. Usage propagates to properties, parent models,
and discriminated sub-models.

TypeSpec-side enum values:

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
extern dec access(
  target: ModelProperty | Model | Operation | Enum | Union | Namespace,
  value: EnumMember,
  scope?: valueof string
);
```

Overrides access (`Access.public` or `Access.internal`). Access propagates from operations to
models/enums they use.

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

Customizes a method's parameter signature in the generated SDK.

#### `@useSystemTextJsonConverter`

```typespec
extern dec useSystemTextJsonConverter(target: Model, scope?: valueof string);
```

Marks a model for custom JSON converter (C# backward compatibility).

#### `@clientInitialization`

```typespec
extern dec clientInitialization(
  target: Namespace | Interface,
  options: ClientInitializationOptions,
  scope?: valueof string
);

model ClientInitializationOptions {
  parameters?: Model;
  initializedBy?: EnumMember | Union;
}
```

Customizes client initialization. Elevates operation parameters to client level. Can be
combined with `@paramAlias`.

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

Aliases a client initialization parameter to a different name.

#### `@clientNamespace`

```typespec
extern dec clientNamespace(
  target: Namespace | Interface | Model | Enum | Union,
  rename: valueof string,
  scope?: valueof string
);
```

Changes the namespace of a client, model, enum, or union in the generated SDK.

#### `@alternateType`

```typespec
extern dec alternateType(
  target: ModelProperty | Scalar | Model | Enum | Union,
  alternate: unknown | ExternalType,
  scope?: valueof string
);

model ExternalType {
  identity: string;
  package?: string;
  minVersion?: string;
}
```

Sets an alternate type for SDK generation. When source is `Scalar`, alternate must also be
`Scalar`. External types (with `identity`) cannot be applied to model properties — they must
be applied to the type definition itself.

#### `@scope`

```typespec
extern dec scope(target: Operation | ModelProperty, scope?: valueof string);
```

Scopes an operation or model property to specific languages. Use to omit elements from
certain languages.

#### `@apiVersion`

```typespec
extern dec apiVersion(target: ModelProperty, value?: valueof boolean, scope?: valueof string);
```

Explicitly marks/unmarks a parameter as an API version parameter. By default, parameters
named `api-version` or `apiversion` or referenced by `@versioned` are detected
automatically.

#### `@clientApiVersions`

```typespec
extern dec clientApiVersions(target: Namespace, value: Enum, scope?: valueof string);
```

Specifies additional API versions for the client beyond those from `@versioned`.

#### `@deserializeEmptyStringAsNull`

```typespec
extern dec deserializeEmptyStringAsNull(target: ModelProperty, scope?: valueof string);
```

Indicates a string property should deserialize `""` as `null`. Only valid on `string` or
scalar derived from `string`.

#### `@responseAsBool`

```typespec
extern dec responseAsBool(target: Operation, scope?: valueof string);
```

For HEAD operations: model as `Response<bool>` where 404 returns `false`, 2xx returns `true`.
Only valid on HEAD operations.

#### `@clientLocation`

```typespec
extern dec clientLocation(
  source: Operation | ModelProperty,
  target: Interface | Namespace | Operation | (valueof string),
  scope?: valueof string
);
```

Moves an operation to a different client, or moves a parameter between operation/client
level. When target is a string, creates a new sub-client. Cannot be used alongside `@client`
or `@operationGroup`.

#### `@clientDoc`

```typespec
extern dec clientDoc(
  target: unknown,
  documentation: valueof string,
  mode: EnumMember,
  scope?: valueof string
);

enum DocumentationMode {
  append: "append",
  replace: "replace",
}
```

Overrides or appends client-specific documentation.

#### `@clientOption`

```typespec
extern dec clientOption(
  target: unknown,
  name: valueof string,
  value: valueof unknown,
  scope?: valueof string
);
```

Passes experimental options to emitters. Always emits a warning that must be suppressed. An
additional warning is emitted if no scope is provided.

### 1.2 Legacy Decorators (`Azure.ClientGenerator.Core.Legacy`)

Defined in `lib/legacy.tsp`.

#### `@hierarchyBuilding`

```typespec
extern dec hierarchyBuilding(target: Model, value: Model, scope?: valueof string);
```

Adds multi-level inheritance for discriminated models (not natively supported in TypeSpec).
Legacy functionality.

#### `@flattenProperty`

```typespec
extern dec flattenProperty(target: ModelProperty, scope?: valueof string);
```

Flattens a model property. Not recommended for greenfield services.

#### `@markAsLro`

```typespec
extern dec markAsLro(target: Operation, scope?: valueof string);
```

Forces an operation to be treated as LRO even when it isn't long-running on the service side.
Only valid on operations returning a model. Emits a warning if the operation already has real
LRO metadata.

#### `@markAsPageable`

```typespec
extern dec markAsPageable(target: Operation, scope?: valueof string);
```

Forces an operation to be treated as pageable. Only valid on operations returning a model
with a `@pageItems`-decorated property or a property named `value`.

#### `@disablePageable`

```typespec
extern dec disablePageable(target: Operation, scope?: valueof string);
```

Prevents an operation from being treated as pageable even if it follows paging patterns.

#### `@nextLinkVerb`

```typespec
extern dec nextLinkVerb(target: Operation, verb: "GET" | "POST", scope?: valueof string);
```

Overrides the HTTP verb for next-page requests in paging. Only `"POST"` and `"GET"` are
supported.

#### `@clientDefaultValue`

```typespec
extern dec clientDefaultValue(
  target: ModelProperty,
  value: valueof string | boolean | numeric,
  scope?: valueof string
);
```

Sets a client-level default value for backward compatibility.

---

## 2. Public Types (Client Type Graph)

All types defined in `src/interfaces.ts` and re-exported from `src/index.ts`.

### 2.1 Top-Level Entry Points

#### `SdkContext`

```typescript
interface SdkContext<
  TOptions extends object = Record<string, any>,
  TServiceOperation extends SdkServiceOperation = SdkHttpOperation,
> extends TCGCContext {
  emitContext: EmitContext<TOptions>;
  sdkPackage: SdkPackage<TServiceOperation>;
}
```

The main entry point for emitters. Created via `createSdkContext()`.

#### `TCGCContext`

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
  getClientOrOperationGroup(type: Namespace | Interface): SdkClient | SdkOperationGroup | undefined;
  getOperationsForClient(client: SdkClient | SdkOperationGroup): Operation[];
  getClientForOperation(operation: Operation): SdkClient | SdkOperationGroup;
}
```

#### `SdkPackage`

```typescript
interface SdkPackage<TServiceOperation extends SdkServiceOperation> {
  clients: SdkClientType<TServiceOperation>[];
  models: SdkModelType[];
  enums: SdkEnumType[];
  unions: (SdkUnionType | SdkNullableType)[];
  crossLanguagePackageId: string;
  namespaces: SdkNamespace<TServiceOperation>[];
  licenseInfo?: LicenseInfo;
  metadata: {
    apiVersion?: string; // @deprecated — use apiVersions
    apiVersions?: Map<string, string>;
  };
}
```

#### `SdkNamespace`

```typescript
interface SdkNamespace<TServiceOperation extends SdkServiceOperation> extends DecoratedType {
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

### 2.2 Client Types

#### `SdkClientType`

```typescript
interface SdkClientType<TServiceOperation extends SdkServiceOperation> extends DecoratedType {
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
  parameters: (SdkEndpointParameter | SdkCredentialParameter | SdkMethodParameter)[];
  initializedBy: InitializedByFlags;
}
```

#### `SdkClient` / `SdkOperationGroup` (raw decorator result types)

```typescript
interface SdkClient {
  kind: "SdkClient";
  name: string;
  service: Namespace | Namespace[]; // @deprecated — use services
  services: Namespace[];
  type: Namespace | Interface;
  subOperationGroups: SdkOperationGroup[];
}

interface SdkOperationGroup {
  kind: "SdkOperationGroup";
  type?: Namespace | Interface;
  subOperationGroups: SdkOperationGroup[];
  groupPath: string;
  service: Namespace; // @deprecated — use services
  services: Namespace[];
  parent?: SdkClient | SdkOperationGroup;
}
```

### 2.3 SdkType Union

```typescript
type SdkType =
  | SdkBuiltInType
  | SdkDateTimeType // utcDateTime | offsetDateTime
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
interface SdkBuiltInType<TKind extends SdkBuiltInKinds = SdkBuiltInKinds> extends SdkTypeBase {
  kind: TKind;
  encode?: string;
  name: string;
  baseType?: SdkBuiltInType<TKind>;
  crossLanguageDefinitionId: string;
}
```

`SdkBuiltInKinds` values: `numeric`, `integer`, `safeint`, `int8`, `int16`, `int32`, `int64`,
`uint8`, `uint16`, `uint32`, `uint64`, `float`, `float32`, `float64`, `decimal`, `decimal128`,
`string`, `url`, `bytes`, `boolean`, `plainDate`, `plainTime`, `unknown`.

#### `SdkDateTimeType`

```typescript
// SdkUtcDateTimeType (kind: "utcDateTime") | SdkOffsetDateTimeType (kind: "offsetDateTime")
interface SdkDateTimeTypeBase extends SdkTypeBase {
  name: string;
  baseType?: SdkDateTimeType;
  encode: DateTimeKnownEncoding | string; // "rfc3339" | "rfc7231" | "unixTimestamp"
  wireType: SdkBuiltInType;
  crossLanguageDefinitionId: string;
}
```

#### `SdkDurationType`

```typescript
interface SdkDurationType extends SdkTypeBase {
  kind: "duration";
  name: string;
  baseType?: SdkDurationType;
  encode: DurationKnownEncoding | string;
  wireType: SdkBuiltInType;
  crossLanguageDefinitionId: string;
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
interface SdkEnumValueType<TValueType extends SdkTypeBase = SdkBuiltInType> extends SdkTypeBase {
  kind: "enumvalue";
  name: string;
  value: string | number;
  enumType: SdkEnumType;
  valueType: TValueType;
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
  name: string;
  isGeneratedName: boolean;
  namespace: string;
  kind: "union";
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

### 2.4 Property / Parameter Types

#### Base: `SdkModelPropertyTypeBase`

```typescript
interface SdkModelPropertyTypeBase<TType extends SdkTypeBase = SdkType> extends DecoratedType {
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
  correspondingMethodParams: (SdkMethodParameter | SdkModelPropertyType)[]; // @deprecated
  methodParameterSegments: (SdkMethodParameter | SdkModelPropertyType)[][];
  explode: boolean;
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
  correspondingMethodParams: (SdkMethodParameter | SdkModelPropertyType)[]; // @deprecated
  methodParameterSegments: (SdkMethodParameter | SdkModelPropertyType)[][];
}
```

#### `SdkCookieParameter` (kind: `"cookie"`)

```typescript
interface SdkCookieParameter extends SdkModelPropertyTypeBase {
  kind: "cookie";
  serializedName: string;
  correspondingMethodParams: (SdkMethodParameter | SdkModelPropertyType)[]; // @deprecated
  methodParameterSegments: (SdkMethodParameter | SdkModelPropertyType)[][];
}
```

#### `SdkBodyParameter` (kind: `"body"`)

```typescript
interface SdkBodyParameter extends SdkModelPropertyTypeBase {
  kind: "body";
  serializedName: string;
  contentTypes: string[];
  defaultContentType: string;
  correspondingMethodParams: (SdkMethodParameter | SdkModelPropertyType)[]; // @deprecated
  methodParameterSegments: (SdkMethodParameter | SdkModelPropertyType)[][];
  streamMetadata?: SdkStreamMetadata;
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

#### `SdkHttpParameter` (aggregate type)

```typescript
type SdkHttpParameter =
  | SdkQueryParameter
  | SdkPathParameter
  | SdkBodyParameter
  | SdkHeaderParameter
  | SdkCookieParameter;
```

### 2.5 Serialization Options

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

### 2.6 Method Types

#### `SdkMethod` / `SdkServiceMethod`

```typescript
type SdkMethod<TServiceOperation extends SdkServiceOperation> = SdkServiceMethod<TServiceOperation>;

type SdkServiceMethod<TServiceOperation extends SdkServiceOperation> =
  | SdkBasicServiceMethod<TServiceOperation> // kind: "basic"
  | SdkPagingServiceMethod<TServiceOperation> // kind: "paging"
  | SdkLroServiceMethod<TServiceOperation> // kind: "lro"
  | SdkLroPagingServiceMethod<TServiceOperation>; // kind: "lropaging"
```

All methods share `SdkServiceMethodBase`:

```typescript
interface SdkServiceMethodBase<
  TServiceOperation extends SdkServiceOperation,
> extends DecoratedType {
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

#### `SdkMethodResponse`

```typescript
interface SdkMethodResponse {
  kind: "method";
  type?: SdkType;
  resultSegments?: SdkModelPropertyType[];
  optional?: boolean;
  streamMetadata?: SdkStreamMetadata;
}
```

#### Paging metadata

```typescript
interface SdkPagingServiceMetadata<TServiceOperation extends SdkServiceOperation> {
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

#### LRO metadata

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
  finalResult?: SdkModelType | SdkArrayType | SdkBuiltInType<"unknown"> | "void";
  finalEnvelopeResult?: SdkModelType | SdkArrayType | SdkBuiltInType<"unknown"> | "void";
  finalResultPath?: string;
}

type SdkLroServiceFinalStep =
  | SdkFinalOperationLink // kind: "finalOperationLink"
  | SdkFinalOperationReference // kind: "finalOperationReference"
  | SdkPollingSuccessProperty // kind: "pollingSuccessProperty"
  | SdkNoPollingSuccessProperty; // kind: "noPollingResult"
```

### 2.7 HTTP Operation Types

```typescript
type SdkServiceOperation = SdkHttpOperation;

interface SdkHttpOperation extends SdkServiceOperationBase {
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

interface SdkHttpResponse extends SdkHttpResponseBase {
  statusCodes: number | HttpStatusCodeRange;
}

interface SdkHttpErrorResponse extends SdkHttpResponseBase {
  statusCodes: number | HttpStatusCodeRange | "*";
}

interface SdkServiceResponseHeader extends SdkModelPropertyTypeBase {
  __raw: ModelProperty;
  kind: "responseheader";
  serializedName: string;
}

interface SdkStreamMetadata {
  bodyType: SdkType;
  originalType: SdkType;
  streamType: SdkType;
  contentTypes: string[];
}
```

### 2.8 Enum / Flag Types

```typescript
enum UsageFlags {
  None = 0,
  Input = 1 << 1, // 2
  Output = 1 << 2, // 4
  ApiVersionEnum = 1 << 3, // 8
  JsonMergePatch = 1 << 4, // 16 (implies Input + Json)
  MultipartFormData = 1 << 5, // 32 (implies Input)
  Spread = 1 << 6, // 64
  Json = 1 << 8, // 256
  Xml = 1 << 9, // 512
  Exception = 1 << 10, // 1024
  LroInitial = 1 << 11, // 2048
  LroPolling = 1 << 12, // 4096
  LroFinalEnvelope = 1 << 13, // 8192
  External = 1 << 14, // 16384
}

enum InitializedByFlags {
  Default = 0,
  Individually = 1 << 0, // 1
  Parent = 1 << 1, // 2
  CustomizeCode = 1 << 2, // 4
}

type AccessFlags = "internal" | "public";
type CollectionFormat = "multi" | "csv" | "ssv" | "tsv" | "pipes" | "simple" | "form";
type ArrayKnownEncoding =
  | "pipeDelimited"
  | "spaceDelimited"
  | "commaDelimited"
  | "newlineDelimited";
```

### 2.9 Example Types

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

### 2.10 Decorated Type & External Type Info

```typescript
interface DecoratedType {
  decorators: DecoratorInfo[];
}

interface DecoratorInfo {
  name: string; // Fully qualified, e.g. "TypeSpec.@encode"
  arguments: Record<string, any>;
}

interface ExternalTypeInfo {
  kind: "externalTypeInfo";
  identity: string;
  package?: string;
  minVersion?: string;
}
```

### 2.11 License Info

```typescript
interface LicenseInfo {
  name: string;
  company: string;
  link: string;
  header: string;
  description: string;
}
```

---

## 3. Public Utility Functions

Exported from `src/public-utils.ts`.

| Function                                       | Signature                                                                                       | Purpose                                            |
| ---------------------------------------------- | ----------------------------------------------------------------------------------------------- | -------------------------------------------------- |
| `getDefaultApiVersion`                         | `(context: TCGCContext, client: SdkClient): string \| undefined`                                | Gets default API version for a client              |
| `isApiVersion`                                 | `(context: TCGCContext, type: ModelProperty): boolean`                                          | Checks if a property is an API version parameter   |
| `getEffectivePayloadType`                      | `(context: TCGCContext, type: Model): Model`                                                    | Gets the effective model type for payload          |
| `getPropertyNames`                             | `(context: TCGCContext, property: ModelProperty): [string, string]`                             | Returns `[libraryName, serializedName]`            |
| `getLibraryName`                               | `(context: TCGCContext, type: Type & { name: string }): string`                                 | Gets the SDK library name (respects `@clientName`) |
| `getWireName`                                  | `(context: TCGCContext, type: Type & { name: string }): string`                                 | Gets the wire (serialized) name                    |
| `getCrossLanguageDefinitionId`                 | `(context: TCGCContext, type: ...): [string, Diagnostic[]]`                                     | Gets the unique cross-language definition ID       |
| `getCrossLanguagePackageId`                    | `(context: TCGCContext): [string, Diagnostic[]]`                                                | Gets the cross-language package ID                 |
| `getGeneratedName`                             | `(context: TCGCContext, type: ...): string`                                                     | Generates a name for anonymous types               |
| `getHttpOperationWithCache`                    | `(context: TCGCContext, operation: Operation): HttpOperation`                                   | Cached HTTP operation resolution                   |
| `getHttpOperationExamples`                     | `(context: TCGCContext, operation: HttpOperation): SdkHttpOperationExample[]`                   | Gets examples for an HTTP operation                |
| `isAzureCoreModel`                             | `(t: SdkType): boolean`                                                                         | Checks if a type is an Azure Core model            |
| `isPagedResultModel`                           | `(context: TCGCContext, t: SdkType): boolean`                                                   | Checks if a type is a paged result model           |
| `getHttpOperationParameter`                    | `(operation: SdkHttpOperation, methodParam: SdkMethodParameter): SdkHttpParameter \| undefined` | Maps method param to HTTP param                    |
| `getHttpOperationParametersForClientParameter` | `(client: SdkClientType, clientParam: ...): ...`                                                | Maps client param to HTTP params across methods    |
| `listAllServiceNamespaces`                     | `(context: TCGCContext): Namespace[]`                                                           | Lists all service namespaces                       |
| `resolveOperationId`                           | `(context: TCGCContext, operation: Operation): string`                                          | Resolves the operation ID for an operation         |
| `isHttpMetadata`                               | `(context: TCGCContext, property: SdkModelPropertyType): boolean`                               | Checks if a property is HTTP metadata              |
| `getNamespaceFromType`                         | `(context: TCGCContext, type: ...): string`                                                     | Gets the namespace string for a type               |
| `getClientOptions`                             | `<T extends DecoratedType>(type: T, key: string): unknown`                                      | Gets `@clientOption` values from a decorated type  |

---

## 4. Decorator Helper Functions

Exported from `src/decorators.ts`.

| Function                                          | Purpose                                                |
| ------------------------------------------------- | ------------------------------------------------------ |
| `getClient(context, type)`                        | Gets the `SdkClient` for a namespace/interface         |
| `listClients(context)`                            | Lists all defined `SdkClient` instances                |
| `isOperationGroup(context, type)`                 | Checks if a namespace/interface is an operation group  |
| `getOperationGroup(context, type)`                | Gets the `SdkOperationGroup` for a namespace/interface |
| `listOperationGroups(context, client)`            | Lists operation groups for a client                    |
| `listOperationsInOperationGroup(context, group)`  | Lists operations in an operation group                 |
| `shouldGenerateProtocol(context, operation)`      | Whether to generate protocol method                    |
| `shouldGenerateConvenient(context, operation)`    | Whether to generate convenience method                 |
| `getUsageOverride(context, entity)`               | Gets `@usage` override value                           |
| `getUsage(context, entity)`                       | Gets effective usage flags                             |
| `getAccessOverride(context, entity)`              | Gets `@access` override value                          |
| `getAccess(context, entity)`                      | Gets effective access flags                            |
| `shouldFlattenProperty(context, target)`          | Whether a property is flattened                        |
| `getClientNameOverride(context, entity)`          | Gets `@clientName` override                            |
| `getOverriddenClientMethod(context, operation)`   | Gets `@override` override operation                    |
| `getAlternateType(context, target)`               | Gets alternate type definition                         |
| `getClientInitializationOptions(context, target)` | Gets `@clientInitialization` options                   |
| `getParamAlias(context, original)`                | Gets `@paramAlias` alias name                          |
| `getIsApiVersion(context, param)`                 | Gets explicit `@apiVersion` setting                    |
| `getClientNamespace(context, type)`               | Gets `@clientNamespace` override                       |
| `getExplicitClientApiVersions(context, target)`   | Gets `@clientApiVersions` enum                         |
| `getResponseAsBool(context, target)`              | Gets `@responseAsBool` setting                         |
| `getClientDocExplicit(context, target)`           | Gets `@clientDoc` documentation                        |
| `getClientLocation(context, entity)`              | Gets `@clientLocation` setting                         |
| `getLegacyHierarchyBuilding(context, target)`     | Gets `@hierarchyBuilding` parent model                 |
| `getMarkAsLro(context, entity)`                   | Gets `@markAsLro` setting                              |
| `getMarkAsPageable(context, entity)`              | Gets `@markAsPageable` setting                         |
| `getDisablePageable(context, entity)`             | Gets `@disablePageable` setting                        |
| `getNextLinkVerb(context, entity)`                | Gets `@nextLinkVerb` verb                              |
| `getClientDefaultValue(context, entity)`          | Gets `@clientDefaultValue` value                       |
| `isInScope(context, entity)`                      | Gets `@scope` setting                                  |

---

## 5. Context Creation & Emitter Options

### `createSdkContext`

```typescript
async function createSdkContext<TOptions, TServiceOperation>(
  context: EmitContext<TOptions>,
  emitterName?: string,
  options?: CreateSdkContextOptions,
): Promise<SdkContext<TOptions, TServiceOperation>>;

interface CreateSdkContextOptions {
  readonly versioning?: { readonly previewStringRegex?: RegExp };
  additionalDecorators?: string[];
  disableUsageAccessPropagationToBase?: boolean;
  exportTCGCoutput?: boolean;
  flattenUnionAsEnum?: boolean;
  enableLegacyHierarchyBuilding?: boolean;
}
```

### `createTCGCContext`

```typescript
function createTCGCContext(
  program: Program,
  emitterName?: string,
  options?: CreateTCGCContextOptions,
): TCGCContext;
```

### Emitter Options (tspconfig.yaml)

Defined in `src/lib.ts`.

| Option                         | Type       | Description                                                                         |
| ------------------------------ | ---------- | ----------------------------------------------------------------------------------- |
| `generate-protocol-methods`    | `boolean?` | Generate low-level protocol methods. Default: `true`                                |
| `generate-convenience-methods` | `boolean?` | Generate convenience methods. Default: `true`                                       |
| `api-version`                  | `string?`  | Generate for specific version. Accepts `"latest"`, `"all"`, or specific version     |
| `license`                      | `object?`  | License info (`name` required; optional `company`, `link`, `header`, `description`) |
| `examples-dir`                 | `string?`  | Directory for example files. Default: `examples` at project root                    |
| `namespace`                    | `string?`  | Override namespace for all spec types                                               |
| `emitter-name`                 | `string?`  | Output TCGC code models for a specific language emitter                             |

Predefined licenses: MIT License, Apache License 2.0, BSD 3-Clause License, MPL 2.0,
GPL-3.0, LGPL-3.0.

---

## 6. Linter Rules

Defined in `src/rules/`.

| Rule                     | File                             | Description                                                      |
| ------------------------ | -------------------------------- | ---------------------------------------------------------------- |
| `no-unnamed-types`       | `no-unnamed-types.rule.ts`       | Requires types to be named rather than anonymous/inline          |
| `property-name-conflict` | `property-name-conflict.rule.ts` | Warns when property name matches enclosing model name (C# issue) |
| `require-client-suffix`  | `require-client-suffix.rule.ts`  | Client names should end with `Client`                            |

---

## 7. Feature Areas

### 7.1 Client Structure & Hierarchy

- Default client detection from `@service` namespace
- Explicit clients via `@client` decorator
- Sub-clients/operation groups via `@operationGroup`
- Operation relocation via `@clientLocation`
- Multi-service support via `@client({service: [NS1, NS2]})`
- Client naming via `@client({name: "..."})` or `@clientName`
- Tests: `test/clients/structure.test.ts`, `test/clients/params.test.ts`
- Docs: `03client.mdx`, `design-docs/client.md`, `design-docs/multiple-services.md`

### 7.2 Client Initialization

- Default parameters: endpoint, credential, API version
- `@clientInitialization` to elevate operation params to client
- `@paramAlias` to alias parameter names
- `InitializedBy` flags: `individually`, `parent`, `customizeCode`
- Tests: `test/decorators/@client-initialization.test.ts`, `test/decorators/@param-alias.test.ts`
- Docs: `03client.mdx`

### 7.3 Method Generation

- Protocol vs convenience methods (`@protocolAPI`, `@convenientAPI`)
- Method signature override (`@override`)
- Basic, paging, LRO, LRO+paging method kinds
- Parameter spreading
- Tests: `test/methods/parameters.test.ts`, `test/methods/spread.test.ts`, `test/methods/responses.test.ts`
- Docs: `04method.mdx`

### 7.4 Paging Operations

- Next link pagination (`@pageItems`, `@nextLink`, `@list`)
- Continuation token pagination (`@continuationToken`)
- Next link verb override (`@nextLinkVerb`)
- Force pageable (`@markAsPageable`) / disable pageable (`@disablePageable`)
- Tests: `test/methods/paged-operation.test.ts`, `test/decorators/@mark-as-pageable.test.ts`,
  `test/decorators/@disable-pageable.test.ts`, `test/decorators/@next-link-verb.test.ts`
- Docs: `05pagingOperations.mdx`

### 7.5 Long-Running Operations (LRO)

- Polling metadata, final state, status monitor
- Force LRO (`@markAsLro`)
- Tests: `test/methods/lro.test.ts`, `test/decorators/@mark-as-lro.test.ts`
- Docs: `06longRunningOperations.mdx`

### 7.6 Multipart Operations

- Multipart body params, file parts, multi-valued parts
- Part headers, content type
- Tests: `test/types/multipart.test.ts`, `test/methods/file.test.ts`
- Docs: `07multipart.mdx`

### 7.7 Type System

- Built-in scalars, date/time, duration
- Models, enums, unions, constants
- Arrays, tuples, dictionaries
- Nullable types
- Discriminated models/unions
- Serialization options (JSON, XML, binary, multipart)
- Tests: `test/types/` directory (model, enum, union, array, dictionary, built-in, etc.)
- Docs: `08types.mdx`

### 7.8 Naming & Renaming

- `@clientName` for SDK names
- `@clientNamespace` for namespace overrides
- `@encodedName` for wire names (TypeSpec core)
- Generated names for anonymous types
- Tests: `test/decorators/@client-name.test.ts`, `test/decorators/@client-namespace.test.ts`
- Docs: `09renaming.mdx`

### 7.9 Access & Usage Control

- `@access(Access.public | Access.internal)` — access propagation
- `@usage(Usage.input | Usage.output | Usage.json | Usage.xml)` — usage propagation
- Tests: `test/decorators/@access.test.ts`, `test/decorators/@usage.test.ts`,
  `test/decorators/@usage-extended.test.ts`
- Docs: No dedicated page (mentioned across multiple pages)

### 7.10 Versioning

- `@versioned` for service versioning
- `@clientApiVersions` for additional client API versions
- `@apiVersion` to mark/unmark API version parameters
- API version as config option
- Tests: `test/decorators/@client-api-versions.test.ts`, `test/decorators/@apiVersion.test.ts`
- Docs: `10versioning.mdx`

### 7.11 Alternate Types

- `@alternateType` for type replacement (TypeSpec or external types)
- External type identity, package, minVersion
- Tests: `test/decorators/@alternate-type.test.ts`
- Docs: No dedicated page

### 7.12 Scoping

- `@scope` to limit operations/properties to specific languages
- Tests: `test/decorators/@scope.test.ts`
- Docs: No dedicated page

### 7.13 Legacy Hierarchy Building

- `@hierarchyBuilding` for multi-level discriminator inheritance
- Tests: `test/decorators/@legacy-hierarchy-building.test.ts`
- Docs: `11hierarchyBuilding.mdx`

### 7.14 Client Documentation Override

- `@clientDoc` with append/replace modes
- Tests: `test/decorators/@client-doc.test.ts`
- Docs: No dedicated page

### 7.15 Client Options

- `@clientOption` for passing experimental emitter options
- `getClientOptions` helper for reading values
- Tests: `test/decorators/@client-option.test.ts`
- Docs: `12clientOptions.mdx`

### 7.16 Response As Bool

- `@responseAsBool` for HEAD operations
- Tests: `test/decorators/@response-as-bool.test.ts`
- Docs: No dedicated page

### 7.17 Deserialize Empty String As Null

- `@deserializeEmptyStringAsNull`
- Tests: `test/decorators/@deserialize-empty-string-as-null.test.ts`
- Docs: No dedicated page

### 7.18 Flatten Property

- `@flattenProperty` (legacy, not recommended)
- Tests: `test/decorators/@flatten-property.test.ts`
- Docs: No dedicated page

### 7.19 Client Default Value

- `@clientDefaultValue` (legacy, backward compat)
- Tests: `test/decorators/@client-default-value.test.ts`
- Docs: No dedicated page

### 7.20 UseSystemTextJsonConverter

- `@useSystemTextJsonConverter` (C# backward compat)
- Tests: `test/decorators/@general-list.test.ts`
- Docs: No dedicated page

### 7.21 Streaming

- `SdkStreamMetadata` for JSONL/SSE streams
- Body/response `streamMetadata` property
- Tests: `test/methods/streams.test.ts`
- Docs: No dedicated page

### 7.22 Package Configuration

- License configuration
- Namespace override
- API version selection
- Examples directory
- Docs: `02package.mdx`

---

## 8. Test File Map

All under `packages/typespec-client-generator-core/test/`.

### Clients

- `clients/structure.test.ts` — Client hierarchy, `@client`, `@operationGroup`
- `clients/params.test.ts` — Client parameter handling

### Decorators

- `decorators/@access.test.ts`
- `decorators/@alternate-type.test.ts`
- `decorators/@apiVersion.test.ts`
- `decorators/@client.test.ts`
- `decorators/@client-api-versions.test.ts`
- `decorators/@client-default-value.test.ts`
- `decorators/@client-doc.test.ts`
- `decorators/@client-initialization.test.ts`
- `decorators/@client-location.test.ts`
- `decorators/@client-name.test.ts`
- `decorators/@client-namespace.test.ts`
- `decorators/@client-option.test.ts`
- `decorators/@convenient-api.test.ts`
- `decorators/@deserialize-empty-string-as-null.test.ts`
- `decorators/@disable-pageable.test.ts`
- `decorators/@flatten-property.test.ts`
- `decorators/@general-list.test.ts` — XML, Azure, C# decorators
- `decorators/@legacy-hierarchy-building.test.ts`
- `decorators/@mark-as-lro.test.ts`
- `decorators/@mark-as-pageable.test.ts`
- `decorators/@next-link-verb.test.ts`
- `decorators/@override.test.ts`
- `decorators/@param-alias.test.ts`
- `decorators/@protocol-api.test.ts`
- `decorators/@response-as-bool.test.ts`
- `decorators/@scope.test.ts`
- `decorators/@usage.test.ts`
- `decorators/@usage-extended.test.ts`

### Methods

- `methods/file.test.ts`
- `methods/lro.test.ts`
- `methods/parameters.test.ts`
- `methods/paged-operation.test.ts`
- `methods/responses.test.ts`
- `methods/spread.test.ts`
- `methods/streams.test.ts`

### Types

- `types/array.test.ts`
- `types/body-model-property.test.ts`
- `types/built-in.test.ts`
- `types/bytes.test.ts`
- `types/constant.test.ts`
- `types/date-time.test.ts`
- `types/dictionary.test.ts`
- `types/doc-summary.test.ts`
- `types/duration.test.ts`
- `types/encode-merge-patch.test.ts`
- `types/enum.test.ts`
- `types/model.test.ts`
- `types/multipart.test.ts`
- `types/serialization-options.test.ts`
- `types/tuple.test.ts`
- `types/union.test.ts`
- `types/usage-flags.test.ts`

### HTTP

- `http/body.test.ts`
- `http/method-parameter-segments.test.ts`
- `http/path.test.ts`

### Public Utils

- `public-utils/get-cross-language-definition-id.test.ts`
- `public-utils/get-default-api-version.test.ts`
- `public-utils/get-effective-payload-type.test.ts`
- `public-utils/get-generated-name.test.ts`
- `public-utils/get-http-operation-parameter.test.ts`
- `public-utils/get-http-operation-parameters-for-client-parameter.test.ts`
- `public-utils/get-library-name.test.ts`
- `public-utils/get-property-names.test.ts`
- `public-utils/is-api-version.test.ts`
- `public-utils/is-http-metadata.test.ts`
- `public-utils/is-paged-result-model.test.ts`

### Package

- `package/` — Package-level construction tests

### Examples

- `examples/helper.test.ts`
- `examples/http-operation-examples.test.ts`
- `examples/load.test.ts`
- `examples/types.test.ts`

### Rules

- `rules/no-unnamed-types.test.ts`
- `rules/property-name-conflict.test.ts`
- `rules/require-client-suffix.test.ts`

### Validations

- `validations/package.test.ts`
- `validations/types.test.ts`

### Core

- `context.test.ts`
- `internal-utils.test.ts`

---

## 9. Existing Documentation Map

### 9.1 User Documentation (`website/src/content/docs/docs/howtos/Generate client libraries/`)

| File                          | Title                               | Features Covered                                                                               |
| ----------------------------- | ----------------------------------- | ---------------------------------------------------------------------------------------------- |
| `00howtogen.mdx`              | How to generate client libraries    | Overview, emitter setup                                                                        |
| `01setup.mdx`                 | Setup for SDK Customization         | `client.tsp` setup, dependency config                                                          |
| `02package.mdx`               | Common Behavior for Client Packages | `@service`, namespaces, license config, `@clientNamespace`                                     |
| `03client.mdx`                | Clients                             | `@client`, `@operationGroup`, `@clientInitialization`, `@clientLocation`, sub-client hierarchy |
| `04method.mdx`                | Basic methods                       | Protocol/convenience methods, `@protocolAPI`, `@convenientAPI`, visibility                     |
| `05pagingOperations.mdx`      | Paging Operations                   | `@list`, `@pageItems`, `@nextLink`, `@continuationToken`, parameterized next links             |
| `06longRunningOperations.mdx` | Long-Running Operations             | LRO templates, `@pollingOperation`, resource operations                                        |
| `07multipart.mdx`             | Multipart Operations                | `@multipartBody`, `HttpPart`, file handling                                                    |
| `08types.mdx`                 | Generated Types                     | Models, enums, unions, discriminators, `@clientNamespace`                                      |
| `09renaming.mdx`              | Renaming Types                      | `@clientName`, `@encodedName`, language-specific renaming                                      |
| `10versioning.mdx`            | Versioning                          | `@versioned`, `@added`, `@removed`, version selection                                          |
| `11hierarchyBuilding.mdx`     | Multi-Layer Discriminator Hierarchy | `@hierarchyBuilding` (Legacy)                                                                  |
| `12clientOptions.mdx`         | Client Options                      | `@clientOption`, `getClientOptions`                                                            |

All user docs use `<ClientTabs>` with language blocks.

### 9.2 Emitter Developer Docs

- `website/src/content/docs/docs/libraries/typespec-client-generator-core/guideline.md` — TCGC overview, `createSdkContext`, type graph, `SdkPackage`, helper functions

### 9.3 Design Documents (`packages/typespec-client-generator-core/design-docs/`)

- `client.md` — Client type design, `SdkClientType`, `SdkInitializationType`, `InitializedBy`
- `multiple-services.md` — Multi-service support, service arrays

---

## 10. Spector Spec Coverage (`packages/azure-http-specs/specs/client/`)

| Spec Directory                             | Feature Tested            |
| ------------------------------------------ | ------------------------- |
| `client/namespace/`                        | Client namespace handling |
| `client/naming/`                           | Client naming conventions |
| `client/naming/enum-conflict/`             | Enum naming conflicts     |
| `client/overload/`                         | Client overload patterns  |
| `client/structure/default/`                | Default client structure  |
| `client/structure/multi-client/`           | Multi-client generation   |
| `client/structure/client-operation-group/` | Client operation groups   |
| `client/structure/renamed-operation/`      | Renamed operations        |
| `client/structure/two-operation-group/`    | Two operation groups      |

### Potential Spector Coverage Gaps

Features with TCGC decorators/functionality but no corresponding Spector specs:

- `@access` / `@usage` — Access and usage control
- `@alternateType` — Alternate type definitions
- `@clientInitialization` / `@paramAlias` — Client initialization customization
- `@clientLocation` — Operation/parameter relocation
- `@clientDoc` — Client documentation override
- `@clientOption` — Client options passing
- `@scope` — Language scoping
- `@responseAsBool` — HEAD response as boolean
- `@deserializeEmptyStringAsNull` — Empty string deserialization
- `@flattenProperty` — Property flattening (legacy)
- `@markAsLro` / `@markAsPageable` / `@disablePageable` — Legacy LRO/paging
- `@nextLinkVerb` — Next link verb override
- `@clientDefaultValue` — Client default values (legacy)
- `@hierarchyBuilding` — Legacy hierarchy building
- `@override` — Method signature override
- `@convenientAPI` / `@protocolAPI` — Method generation control
- `@clientApiVersions` — Additional API versions
- `@apiVersion` — API version parameter marking

---

## 11. Diagnostics Reference

Key diagnostic codes emitted by TCGC (from `src/lib.ts`):

| Code                               | Severity | When                                                         |
| ---------------------------------- | -------- | ------------------------------------------------------------ |
| `multiple-services`                | warning  | Multiple `@service` namespaces found                         |
| `client-service`                   | warning  | Client not inside service namespace                          |
| `invalid-access`                   | error    | Invalid `@access` value                                      |
| `invalid-usage`                    | error    | Invalid `@usage` value                                       |
| `discriminator-not-constant`       | error    | Non-constant discriminator                                   |
| `duplicate-client-name`            | error    | Duplicate name in same scope                                 |
| `empty-client-name`                | warning  | Empty `@clientName` value                                    |
| `override-parameters-mismatch`     | error    | `@override` params don't match                               |
| `conflict-access-override`         | warning  | Conflicting `@access` overrides                              |
| `duplicate-decorator`              | warning  | Same decorator applied twice with same scope                 |
| `invalid-alternate-type`           | error    | Invalid `@alternateType` (scalar mismatch)                   |
| `invalid-initialized-by`           | error    | Invalid `InitializedBy` value                                |
| `client-location-conflict`         | warning  | `@clientLocation` conflicts with `@client`/`@operationGroup` |
| `non-head-bool-response-decorator` | warning  | `@responseAsBool` on non-HEAD operation                      |
| `external-type-on-model-property`  | warning  | `@alternateType` external on property                        |
| `invalid-mark-as-lro-target`       | warning  | `@markAsLro` on non-model operation                          |
| `mark-as-lro-ineffective`          | warning  | `@markAsLro` on already-LRO operation                        |
| `invalid-mark-as-pageable-target`  | warning  | `@markAsPageable` on incompatible operation                  |
| `mark-as-pageable-ineffective`     | warning  | `@markAsPageable` on already-pageable operation              |
| `client-option`                    | warning  | `@clientOption` experimental warning (must suppress)         |
| `invalid-client-doc-mode`          | error    | Invalid `@clientDoc` mode                                    |
| `missing-scope`                    | warning  | `@scope` without scoped decorator                            |
| `api-version-undefined`            | warning  | Configured API version not in versioning list                |

---

## 12. Default Decorators Allow List

The `decoratorsAllowList` controls which decorators are passed through to the `DecoratedType.decorators` list. Default list (from `src/configs.ts`):

```typescript
[
  "TypeSpec\\.Xml\\..*",
  "Azure\\.Core\\.@useFinalStateVia",
  "Autorest\\.@example",
  "Azure\\.ClientGenerator\\.Core\\.@clientOption",
];
```

Emitters can extend this via `additionalDecorators` in `CreateSdkContextOptions`.
