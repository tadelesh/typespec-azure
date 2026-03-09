# TCGC (TypeSpec Client Generator Core) — Package Knowledge Base

> **Auto-generated** — do not edit manually. See `knowledge/README.md`.

---

## 1. Package Overview

**npm package:** `@azure-tools/typespec-client-generator-core`

TCGC is a TypeSpec library that transforms TypeSpec API specifications into a language-agnostic client SDK type graph. Emitters (Python, Java, C#, TypeScript, Go) consume this type graph to generate idiomatic client code without directly interacting with the TypeSpec compiler API.

**Namespace:** `Azure.ClientGenerator.Core` (main), `Azure.ClientGenerator.Core.Legacy` (deprecated decorators)

---

## 2. Decorators

All decorators live in the `Azure.ClientGenerator.Core` namespace unless noted as legacy.

### 2.1 Core Decorators

#### `@clientName`

- **Target:** `unknown` (any type)
- **Signature:** `extern dec clientName(target: unknown, rename: valueof string, scope?: valueof string)`
- **Description:** Overrides the generated name for client SDK elements (clients, methods, parameters, unions, models, enums, properties). Takes precedence over all other naming mechanisms including `@client({name: ...})`.
- **Scope:** Supports language-specific scoping (e.g., `"java"`, `"python"`, `"csharp"`, `"javascript"`, `"go"`) and negation (e.g., `"!csharp"`).

#### `@convenientAPI`

- **Target:** `Operation | Namespace | Interface`
- **Signature:** `extern dec convenientAPI(target: Operation | Namespace | Interface, flag?: valueof boolean, scope?: valueof string)`
- **Description:** Controls whether an operation generates a convenience method. When applied to namespace/interface, affects all child operations unless overridden. Default: `true`.

#### `@protocolAPI`

- **Target:** `Operation | Namespace | Interface`
- **Signature:** `extern dec protocolAPI(target: Operation | Namespace | Interface, flag?: valueof boolean, scope?: valueof string)`
- **Description:** Controls whether an operation generates a protocol (low-level) method. When applied to namespace/interface, affects all child operations unless overridden. Default: `true`.

#### `@client`

- **Target:** `Namespace | Interface`
- **Signature:** `extern dec client(target: Namespace | Interface, options?: ClientOptions, scope?: valueof string)`
- **Description:** Defines a root client in the generated SDK. Cannot be used with `@clientLocation`. Cannot be used as augmentation.
- **`ClientOptions` model:**
  ```typespec
  model ClientOptions {
    service?: Namespace | Namespace[]; // service(s) this client represents
    name?: string; // override client name (default: <Name>Client)
  }
  ```

#### `@operationGroup`

- **Target:** `Namespace | Interface`
- **Signature:** `extern dec operationGroup(target: Namespace | Interface, scope?: valueof string)`
- **Description:** Defines a sub-client (operation group) in the SDK hierarchy. Cannot be used with `@clientLocation`. Cannot be used as augmentation.

#### `@usage`

- **Target:** `Model | Enum | Union | Namespace`
- **Signature:** `extern dec usage(target: Model | Enum | Union | Namespace, value: EnumMember | Union, scope?: valueof string)`
- **Description:** Adds usage information to models/enums/unions. By default, usage is calculated from operations. This decorator adds additional flags. Usage propagates to properties, parent models, and discriminated sub-models.

#### `@access`

- **Target:** `ModelProperty | Model | Operation | Enum | Union | Namespace`
- **Signature:** `extern dec access(target: ModelProperty | Model | Operation | Enum | Union | Namespace, value: EnumMember, scope?: valueof string)`
- **Description:** Overrides access level (public/internal) for operations, models, and enums. Propagates to child types.

#### `@override`

- **Target:** `Operation`
- **Signature:** `extern dec override(target: Operation, override: Operation, scope?: valueof string)`
- **Description:** Customizes a method's parameter signature in the generated client SDK. Used as augmentation: `@@override(MyService.myOperation, myCustomSignature)`.

#### `@useSystemTextJsonConverter`

- **Target:** `Model`
- **Signature:** `extern dec useSystemTextJsonConverter(target: Model, scope?: valueof string)`
- **Description:** Indicates a model needs a custom JSON converter. Used for backward compatibility in C#.

#### `@clientInitialization`

- **Target:** `Namespace | Interface`
- **Signature:** `extern dec clientInitialization(target: Namespace | Interface, options: ClientInitializationOptions, scope?: valueof string)`
- **Description:** Customizes client initialization — can elevate operation-level parameters to the client constructor and control how sub-clients are instantiated.
- **`ClientInitializationOptions` model:**
  ```typespec
  model ClientInitializationOptions {
    parameters?: Model; // model whose properties become constructor params
    initializedBy?: EnumMember | Union; // InitializedBy enum flags
  }
  ```

#### `@paramAlias`

- **Target:** `ModelProperty`
- **Signature:** `extern dec paramAlias(target: ModelProperty, paramAlias: valueof string, scope?: valueof string)`
- **Description:** Aliases a client parameter name. Allows a parameter elevated to the client to use a different name than on the operation.

#### `@clientNamespace`

- **Target:** `Namespace | Interface | Model | Enum | Union`
- **Signature:** `extern dec clientNamespace(target: Namespace | Interface | Model | Enum | Union, rename: valueof string, scope?: valueof string)`
- **Description:** Changes the namespace of a client, model, enum, or union in the generated SDK.

#### `@alternateType`

- **Target:** `ModelProperty | Scalar | Model | Enum | Union`
- **Signature:** `extern dec alternateType(target: ModelProperty | Scalar | Model | Enum | Union, alternate: unknown | ExternalType, scope?: valueof string)`
- **Description:** Sets an alternate type for a property/scalar/model/enum/union. For scalars, must be scalar-to-scalar. Overrides `@encode`. External types can only be applied to type definitions, not properties.
- **`ExternalType` model:**
  ```typespec
  model ExternalType {
    identity: string; // e.g., "pystac.Collection"
    package?: string; // e.g., "pystac"
    minVersion?: string; // e.g., "1.13.0"
  }
  ```

#### `@scope`

- **Target:** `Operation | ModelProperty`
- **Signature:** `extern dec scope(target: Operation | ModelProperty, scope?: valueof string)`
- **Description:** Limits an operation or model property to specific language emitters. Supports negation with `"!"` prefix.

#### `@apiVersion`

- **Target:** `ModelProperty`
- **Signature:** `extern dec apiVersion(target: ModelProperty, value?: valueof boolean, scope?: valueof string)`
- **Description:** Explicitly marks a parameter as (or not as) the API version parameter. API version parameters are elevated to the client level. Default: `true`.

#### `@clientApiVersions`

- **Target:** `Namespace`
- **Signature:** `extern dec clientApiVersions(target: Namespace, value: Enum, scope?: valueof string)`
- **Description:** Specifies additional API versions the client can support beyond those defined by the service's `@versioned` configuration.

#### `@deserializeEmptyStringAsNull`

- **Target:** `ModelProperty`
- **Signature:** `extern dec deserializeEmptyStringAsNull(target: ModelProperty, scope?: valueof string)`
- **Description:** Indicates that a string property should be deserialized as `null` when the wire value is an empty string `""`.

#### `@responseAsBool`

- **Target:** `Operation`
- **Signature:** `extern dec responseAsBool(target: Operation, scope?: valueof string)`
- **Description:** Converts a HEAD operation's response to `boolean`. 2xx → `true`, 404 → `false`, other codes → error.

#### `@clientLocation`

- **Target:** `Operation | ModelProperty`
- **Signature:** `extern dec clientLocation(source: Operation | ModelProperty, target: Interface | Namespace | Operation | valueof string, scope?: valueof string)`
- **Description:** Moves an operation to a different client/sub-client, or moves a method parameter to client initialization. When targeting an operation (for a ModelProperty), keeps the parameter at operation level. Cannot be combined with `@client`/`@operationGroup` for operations.

#### `@clientDoc`

- **Target:** `unknown` (any type)
- **Signature:** `extern dec clientDoc(target: unknown, documentation: valueof string, mode: EnumMember, scope?: valueof string)`
- **Description:** Overrides documentation for client libraries. Supports `DocumentationMode.append` (appends to existing doc) and `DocumentationMode.replace` (replaces existing doc).

#### `@clientOption`

- **Target:** `unknown` (any type)
- **Signature:** `extern dec clientOption(target: unknown, name: valueof string, value: valueof unknown, scope?: valueof string)`
- **Description:** Passes experimental flags to emitters without TCGC changes. Always emits a suppressible warning. Requires suppression via `#suppress "@azure-tools/typespec-client-generator-core/client-option"`.
- **Retrieval function:** `getClientOptions(type, key)` returns the value for a given option name.

### 2.2 Legacy Decorators (Azure.ClientGenerator.Core.Legacy)

All legacy decorators are deprecated and should not be used for new services.

#### `@hierarchyBuilding` ⚠️ LEGACY

- **Target:** `Model`
- **Signature:** `extern dec hierarchyBuilding(target: Model, value: Model, scope?: valueof string)`
- **Description:** Enables multi-level discriminator inheritance for client code. Controlled by the `enableLegacyHierarchyBuilding` context option.

#### `@flattenProperty` ⚠️ LEGACY

- **Target:** `ModelProperty`
- **Signature:** `extern dec flattenProperty(target: ModelProperty, scope?: valueof string)`
- **Description:** Flattens a nested model property into the parent model in generated client code.

#### `@markAsLro` ⚠️ LEGACY

- **Target:** `Operation`
- **Signature:** `extern dec markAsLro(target: Operation, scope?: valueof string)`
- **Description:** Forces an operation to be treated as a Long-Running Operation.

#### `@markAsPageable` ⚠️ LEGACY

- **Target:** `Operation`
- **Signature:** `extern dec markAsPageable(target: Operation, scope?: valueof string)`
- **Description:** Forces an operation to be treated as pageable.

#### `@disablePageable` ⚠️ LEGACY

- **Target:** `Operation`
- **Signature:** `extern dec disablePageable(target: Operation, scope?: valueof string)`
- **Description:** Prevents an operation from being treated as pageable, even if it matches paging patterns.

#### `@nextLinkVerb` ⚠️ LEGACY

- **Target:** `Operation`
- **Signature:** `extern dec nextLinkVerb(target: Operation, verb: "GET" | "POST", scope?: valueof string)`
- **Description:** Specifies the HTTP verb for the next link operation in paging.

#### `@clientDefaultValue` ⚠️ LEGACY

- **Target:** `ModelProperty`
- **Signature:** `extern dec clientDefaultValue(target: ModelProperty, value: valueof string | boolean | numeric, scope?: valueof string)`
- **Description:** Sets a client-level default value for a model property or operation parameter.

### 2.3 Enums Defined in TypeSpec Library

```typespec
enum Usage {
  input: 2, // Used in request body
  output: 4, // Used in response body
  json: 256, // Used with JSON content type
  xml: 512, // Used with XML content type
}

enum Access {
  public: "public",
  internal: "internal",
}

enum InitializedBy {
  individually: 1, // Sub-client can be created independently
  parent: 2, // Sub-client is created by parent client
  customizeCode: 4, // Initialization is manually implemented
}

enum DocumentationMode {
  append: "append", // Append to existing documentation
  replace: "replace", // Replace existing documentation
}
```

### 2.4 Scope Parameter Semantics

All decorators with a `scope` parameter support:

- **Language-specific:** `scope: "java"` — apply only to Java
- **Multiple languages:** `scope: "java, csharp"` — apply to Java and C#
- **Exclusion (negation):** `scope: "!csharp"` — apply to all except C#
- **Multiple exclusions:** `scope: "!java, !python"` — exclude Java and Python
- **Default (no scope):** Apply to all language emitters

Valid language scope identifiers: `"dotnet"` (or `"csharp"`), `"java"`, `"python"`, `"javascript"`, `"go"`.

---

## 3. Public Types (Client Type Graph)

The TCGC type graph is the output consumed by language emitters. All types are defined in `packages/typespec-client-generator-core/src/interfaces.ts`.

### 3.1 Top-Level Package

#### `SdkPackage<TServiceOperation>`

- `clients: SdkClientType<TServiceOperation>[]` — root-level clients
- `models: SdkModelType[]` — all models (flattened across namespaces)
- `enums: SdkEnumType[]` — all enums
- `unions: (SdkUnionType | SdkNullableType)[]` — all unions/nullable types
- `crossLanguagePackageId: string`
- `namespaces: SdkNamespace<TServiceOperation>[]` — namespace hierarchy
- `licenseInfo?: LicenseInfo`
- `metadata: { apiVersion?: string; apiVersions?: Map<string, string> }`

#### `SdkHttpPackage`

Type alias: `SdkPackage<SdkHttpOperation>`

#### `SdkNamespace<TServiceOperation>`

- `__raw?: Namespace`
- `name: string` — simple name
- `fullName: string` — fully qualified name
- `clients: SdkClientType<TServiceOperation>[]`
- `models: SdkModelType[]`
- `enums: SdkEnumType[]`
- `unions: (SdkUnionType | SdkNullableType)[]`
- `namespaces: SdkNamespace<TServiceOperation>[]` — nested namespaces
- Extends: `DecoratedType`

#### `LicenseInfo`

- `name: string`, `company: string`, `link: string`, `header: string`, `description: string`

### 3.2 Client Types

#### `SdkClientType<TServiceOperation>` (extends `DecoratedType`)

- `__raw: SdkClient | SdkOperationGroup`
- `kind: "client"`
- `name: string`
- `namespace: string`
- `doc?: string`, `summary?: string`
- `clientInitialization: SdkClientInitializationType`
- `methods: SdkMethod<TServiceOperation>[]`
- `apiVersions: string[]`
- `crossLanguageDefinitionId: string`
- `parent?: SdkClientType<TServiceOperation>`
- `children?: SdkClientType<TServiceOperation>[]`

#### `SdkClientInitializationType` (extends `SdkTypeBase`)

- `kind: "clientinitialization"`
- `name: string`, `isGeneratedName: boolean`
- `parameters: (SdkEndpointParameter | SdkCredentialParameter | SdkMethodParameter)[]`
- `initializedBy: InitializedByFlags`

#### `InitializedByFlags` (enum)

- `Default = 0`
- `Individually = 1 << 0` (1) — sub-client can be created independently
- `Parent = 1 << 1` (2) — sub-client is created from parent
- `CustomizeCode = 1 << 2` (4) — manually implemented

### 3.3 Method Types

#### `SdkServiceMethod<TServiceOperation>` (union)

```
SdkBasicServiceMethod | SdkPagingServiceMethod | SdkLroServiceMethod | SdkLroPagingServiceMethod
```

#### `SdkMethod<TServiceOperation>` (union)

Currently an alias for `SdkServiceMethod<TServiceOperation>`.

#### Common base: `SdkServiceMethodBase<TServiceOperation>` (extends `DecoratedType`)

- `__raw?: Operation`
- `name: string`
- `access: AccessFlags`
- `apiVersions: string[]`
- `doc?: string`, `summary?: string`
- `crossLanguageDefinitionId: string`
- `operation: TServiceOperation`
- `parameters: SdkMethodParameter[]`
- `response: SdkMethodResponse`
- `exception?: SdkMethodResponse`
- `generateConvenient: boolean`
- `generateProtocol: boolean`
- `isOverride: boolean`

#### `SdkBasicServiceMethod` — `kind: "basic"`

#### `SdkPagingServiceMethod` — `kind: "paging"`

- `pagingMetadata: SdkPagingServiceMetadata<TServiceOperation>`

#### `SdkLroServiceMethod` — `kind: "lro"`

- `lroMetadata: SdkLroServiceMetadata`

#### `SdkLroPagingServiceMethod` — `kind: "lropaging"`

- Both `pagingMetadata` and `lroMetadata`

#### `SdkPagingServiceMetadata<TServiceOperation>`

- `__raw?: PagingOperation`
- `nextLinkSegments?: (SdkServiceResponseHeader | SdkModelPropertyType)[]`
- `nextLinkOperation?: SdkServiceMethod<TServiceOperation>`
- `nextLinkVerb?: "GET" | "POST"`
- `nextLinkReInjectedParametersSegments?: (SdkMethodParameter | SdkModelPropertyType)[][]`
- `continuationTokenParameterSegments?: (SdkMethodParameter | SdkModelPropertyType)[]`
- `continuationTokenResponseSegments?: (SdkServiceResponseHeader | SdkModelPropertyType)[]`
- `pageItemsSegments?: SdkModelPropertyType[]`
- `pageSizeParameterSegments?: (SdkMethodParameter | SdkModelPropertyType)[]`

#### `SdkLroServiceMetadata`

- `__raw: LroMetadata`
- `finalStateVia: FinalStateValue`
- `pollingStep: SdkLroServicePollingStep`
- `finalStep?: SdkLroServiceFinalStep`
- `finalResponse?: SdkLroServiceFinalResponse`
- `operation: SdkServiceOperation`
- `logicalResult: SdkModelType`
- `statusMonitorStep?: SdkNextOperationLink | SdkNextOperationReference`
- `pollingInfo: SdkPollingOperationStep`
- `envelopeResult: SdkModelType`
- `logicalPath?: string`
- `finalResult?: SdkModelType | SdkArrayType | SdkBuiltInType<"unknown"> | "void"`
- `finalEnvelopeResult?: SdkModelType | SdkArrayType | SdkBuiltInType<"unknown"> | "void"`
- `finalResultPath?: string`

#### `SdkMethodResponse`

- `kind: "method"`
- `type?: SdkType`
- `resultSegments?: SdkModelPropertyType[]`
- `optional?: boolean`
- `streamMetadata?: SdkStreamMetadata`

### 3.4 HTTP Operation Types

#### `SdkHttpOperation` (extends `SdkServiceOperationBase`)

- `__raw: HttpOperation`
- `kind: "http"`
- `path: string`
- `uriTemplate: string`
- `verb: HttpVerb`
- `parameters: (SdkPathParameter | SdkQueryParameter | SdkHeaderParameter | SdkCookieParameter)[]`
- `bodyParam?: SdkBodyParameter`
- `responses: SdkHttpResponse[]`
- `exceptions: SdkHttpErrorResponse[]`
- `examples?: SdkHttpOperationExample[]`

#### `SdkServiceOperation` (union)

Currently just: `SdkHttpOperation`

#### `SdkHttpResponse`

- `__raw: HttpOperationResponse`
- `kind: "http"`
- `statusCodes: number | HttpStatusCodeRange`
- `type?: SdkType`
- `headers: SdkServiceResponseHeader[]`
- `apiVersions: string[]`
- `contentTypes?: string[]`
- `defaultContentType?: string`
- `description?: string`
- `streamMetadata?: SdkStreamMetadata`

#### `SdkHttpErrorResponse`

Same as `SdkHttpResponse` but `statusCodes` can also be `"*"`.

### 3.5 Parameter Types

All parameter types extend `SdkModelPropertyTypeBase<TType>`.

**Common base properties (`SdkModelPropertyTypeBase`):**

- `__raw?: ModelProperty`
- `type: TType` — the parameter's SDK type
- `name: string`, `isGeneratedName: boolean`
- `doc?: string`, `summary?: string`
- `apiVersions: string[]`
- `onClient: boolean` — whether this is a client-level param
- `clientDefaultValue?: unknown`
- `isApiVersionParam: boolean`
- `optional: boolean`
- `crossLanguageDefinitionId: string`
- `visibility?: Visibility[]`
- `access: AccessFlags`
- `flatten: boolean`
- `encode?: ArrayKnownEncoding`
- Extends: `DecoratedType`

#### `SdkMethodParameter` — `kind: "method"`

#### `SdkEndpointParameter` — `kind: "endpoint"`, `urlEncode: boolean`, `onClient: true`

#### `SdkCredentialParameter` — `kind: "credential"`, `onClient: true`

#### `SdkHeaderParameter` — `kind: "header"`, `serializedName: string`, `collectionFormat?: CollectionFormat`, `methodParameterSegments: (SdkMethodParameter | SdkModelPropertyType)[][]`

#### `SdkQueryParameter` — `kind: "query"`, `serializedName: string`, `collectionFormat?: CollectionFormat`, `explode: boolean`, `methodParameterSegments: ...`

#### `SdkPathParameter` — `kind: "path"`, `serializedName: string`, `explode: boolean`, `style: "simple" | "label" | "matrix" | "fragment" | "path"`, `allowReserved: boolean`, `methodParameterSegments: ...`

#### `SdkCookieParameter` — `kind: "cookie"`, `serializedName: string`, `methodParameterSegments: ...`

#### `SdkBodyParameter` — `kind: "body"`, `serializedName: string`, `contentTypes: string[]`, `defaultContentType: string`, `streamMetadata?: SdkStreamMetadata`, `methodParameterSegments: ...`

#### `SdkServiceResponseHeader` — `kind: "responseheader"`, `serializedName: string`

#### `SdkModelPropertyType` — `kind: "property"`, `discriminator: boolean`, `serializationOptions: SerializationOptions`, `serializedName: string` (deprecated)

**`ArrayKnownEncoding`:** `"pipeDelimited" | "spaceDelimited" | "commaDelimited" | "newlineDelimited"`

**`CollectionFormat`:** `"multi" | "csv" | "ssv" | "tsv" | "pipes" | "simple" | "form"`

### 3.6 SDK Types

#### `SdkType` (union)

```
SdkBuiltInType | SdkDateTimeType | SdkDurationType | SdkArrayType | SdkTupleType |
SdkDictionaryType | SdkNullableType | SdkEnumType | SdkEnumValueType | SdkConstantType |
SdkUnionType | SdkModelType | SdkCredentialType | SdkEndpointType
```

All types extend `SdkTypeBase`:

- `__raw?: Type`
- `kind: string`
- `deprecation?: string`
- `doc?: string`, `summary?: string`
- Extends: `DecoratedType`, `ExternalType`

#### `SdkBuiltInType<TKind>`

- `kind: TKind` (see `SdkBuiltInKinds`)
- `encode?: string`, `name: string`, `baseType?: SdkBuiltInType<TKind>`
- `crossLanguageDefinitionId: string`

**`SdkBuiltInKinds`:** `"numeric" | "integer" | "safeint" | "int8" | "int16" | "int32" | "int64" | "uint8" | "uint16" | "uint32" | "uint64" | "float" | "float32" | "float64" | "decimal" | "decimal128" | "string" | "url" | "bytes" | "boolean" | "plainDate" | "plainTime" | "unknown"`

#### `SdkDateTimeType` (union: `SdkUtcDateTimeType | SdkOffsetDateTimeType`)

- `kind: "utcDateTime" | "offsetDateTime"`
- `name: string`, `encode: DateTimeKnownEncoding | string`, `wireType: SdkBuiltInType`, `crossLanguageDefinitionId: string`

#### `SdkDurationType`

- `kind: "duration"`, `name: string`, `encode: DurationKnownEncoding | string`, `wireType: SdkBuiltInType`

#### `SdkArrayType`

- `kind: "array"`, `name: string`, `valueType: SdkType`, `crossLanguageDefinitionId: string`

#### `SdkTupleType`

- `kind: "tuple"`, `valueTypes: SdkType[]`

#### `SdkDictionaryType`

- `kind: "dict"`, `keyType: SdkType`, `valueType: SdkType`

#### `SdkNullableType`

- `kind: "nullable"`, `name: string`, `isGeneratedName: boolean`, `type: SdkType`
- `usage: UsageFlags`, `access: AccessFlags`, `namespace: string`, `crossLanguageDefinitionId: string`

#### `SdkEnumType`

- `kind: "enum"`, `name: string`, `isGeneratedName: boolean`, `namespace: string`
- `valueType: SdkBuiltInType`, `values: SdkEnumValueType[]`
- `isFixed: boolean` — closed enum (no unknown values), `isFlags: boolean`
- `usage: UsageFlags`, `access: AccessFlags`, `apiVersions: string[]`
- `isUnionAsEnum: boolean`, `crossLanguageDefinitionId: string`

#### `SdkEnumValueType`

- `kind: "enumvalue"`, `name: string`, `value: string | number`
- `enumType: SdkEnumType`, `valueType: TValueType`, `crossLanguageDefinitionId: string`

#### `SdkConstantType`

- `kind: "constant"`, `value: string | number | boolean`
- `valueType: SdkBuiltInType`, `name: string`, `isGeneratedName: boolean`

#### `SdkUnionType<TValueType>`

- `kind: "union"`, `name: string`, `isGeneratedName: boolean`, `namespace: string`
- `variantTypes: TValueType[]`, `usage: UsageFlags`, `access: AccessFlags`
- `discriminatedOptions?: DiscriminatedOptions`, `crossLanguageDefinitionId: string`

#### `DiscriminatedOptions`

- `envelope: "object" | "none"` — serialization format
- `discriminatorPropertyName: string`
- `envelopePropertyName?: string`

#### `SdkModelType`

- `kind: "model"`, `name: string`, `isGeneratedName: boolean`, `namespace: string`
- `properties: SdkModelPropertyType[]`
- `access: AccessFlags`, `usage: UsageFlags`
- `additionalProperties?: SdkType`
- `discriminatorValue?: string`, `discriminatedSubtypes?: Record<string, SdkModelType>`
- `discriminatorProperty?: SdkModelPropertyType`
- `baseModel?: SdkModelType`
- `crossLanguageDefinitionId: string`, `apiVersions: string[]`
- `serializationOptions: SerializationOptions`

#### `SdkCredentialType`

- `kind: "credential"`, `scheme: HttpAuth`

#### `SdkEndpointType`

- `kind: "endpoint"`, `serverUrl: string`, `templateArguments: SdkPathParameter[]`

### 3.7 Serialization Options

#### `SerializationOptions`

- `json?: JsonSerializationOptions`
- `xml?: XmlSerializationOptions`
- `multipart?: MultipartOptions`
- `binary?: BinarySerializationOptions`

#### `JsonSerializationOptions`

- `name: string` — JSON property name

#### `XmlSerializationOptions`

- `name: string`, `attribute?: boolean`, `ns?: { namespace: string; prefix: string }`
- `unwrapped?: boolean`, `itemsName?: string`, `itemsNs?: { namespace: string; prefix: string }`

#### `BinarySerializationOptions`

- `isFile: boolean`, `isText?: boolean`, `contentTypes?: string[]`, `filename?: ModelProperty`

#### `MultipartOptions`

- `name: string`, `isFilePart: boolean`, `isMulti: boolean`
- `filename?: SdkModelPropertyType`, `contentType?: SdkModelPropertyType`
- `defaultContentTypes: string[]`, `headers: SdkHeaderParameter[]`

### 3.8 Stream Metadata

#### `SdkStreamMetadata`

- `bodyType: SdkType` — original body type
- `originalType: SdkType` — stream model type
- `streamType: SdkType` — payload type
- `contentTypes: string[]`

### 3.9 Example Types

#### `SdkHttpOperationExample`

- `kind: "http"`, `name: string`, `doc: string`, `filePath: string`, `rawExample: any`
- `parameters: SdkHttpParameterExampleValue[]`, `responses: SdkHttpResponseExampleValue[]`

#### `SdkExampleValue` (union)

```
SdkStringExampleValue | SdkNumberExampleValue | SdkBooleanExampleValue |
SdkNullExampleValue | SdkUnknownExampleValue | SdkArrayExampleValue |
SdkDictionaryExampleValue | SdkUnionExampleValue | SdkModelExampleValue
```

### 3.10 Common Base Types

#### `DecoratedType`

- `decorators: DecoratorInfo[]`

#### `DecoratorInfo`

- `name: string` — fully qualified (e.g., `TypeSpec.@encode`)
- `arguments: Record<string, any>`

#### `ExternalTypeInfo`

- `kind: "externalTypeInfo"`, `identity: string`, `package?: string`, `minVersion?: string`

#### `UsageFlags` (enum, bitmask)

- `None = 0`
- `Input = 1 << 1` (2)
- `Output = 1 << 2` (4)
- `ApiVersionEnum = 1 << 3` (8)
- `JsonMergePatch = 1 << 4` (16)
- `MultipartFormData = 1 << 5` (32)
- `Spread = 1 << 6` (64)
- `Json = 1 << 8` (256)
- `Xml = 1 << 9` (512)
- `Exception = 1 << 10` (1024)
- `LroInitial = 1 << 11` (2048)
- `LroPolling = 1 << 12` (4096)
- `LroFinalEnvelope = 1 << 13` (8192)
- `External = 1 << 14` (16384)

#### `AccessFlags`

Union type: `"internal" | "public"`

#### `LanguageScopes`

Union type: `"dotnet" | "java" | "python" | "javascript" | "go" | string`

### 3.11 Raw Client Discovery Types

These types are used by TCGC internally and exposed for inspection via `listClients()` etc.

#### `SdkClient`

- `kind: "SdkClient"`, `name: string`, `services: Namespace[]`, `type: Namespace | Interface`
- `subOperationGroups: SdkOperationGroup[]`

#### `SdkOperationGroup`

- `kind: "SdkOperationGroup"`, `type?: Namespace | Interface`
- `subOperationGroups: SdkOperationGroup[]`, `groupPath: string`
- `services: Namespace[]`, `parent?: SdkClient | SdkOperationGroup`

---

## 4. Public API Functions

### 4.1 Context Creation

| Function            | Signature                                                                                                              | Description                                                                   |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| `createTCGCContext` | `(program: Program, emitterName?: string, options?: CreateTCGCContextOptions): TCGCContext`                            | Creates lightweight context for validation/introspection without full package |
| `createSdkContext`  | `async (context: EmitContext<TOptions>, emitterName?: string, options?: CreateSdkContextOptions): Promise<SdkContext>` | Creates full SDK context with resolved package, clients, and types            |

### 4.2 Client & Operation Discovery

| Function                         | Signature                                                                    | Description                                  |
| -------------------------------- | ---------------------------------------------------------------------------- | -------------------------------------------- |
| `listClients`                    | `(context: TCGCContext): SdkClient[]`                                        | Returns all root clients defined in the spec |
| `listOperationGroups`            | `(context: TCGCContext, client: SdkClient): SdkOperationGroup[]`             | Returns sub-clients of a client              |
| `listOperationsInOperationGroup` | `(context: TCGCContext, group: SdkClient \| SdkOperationGroup): Operation[]` | Returns operations in a client/group         |

### 4.3 Decorator Query Functions

| Function                   | Signature                                                  | Description                                          |
| -------------------------- | ---------------------------------------------------------- | ---------------------------------------------------- |
| `shouldGenerateProtocol`   | `(context: TCGCContext, operation: Operation): boolean`    | Checks if protocol method should be generated        |
| `shouldGenerateConvenient` | `(context: TCGCContext, operation: Operation): boolean`    | Checks if convenience method should be generated     |
| `shouldFlattenProperty`    | `(context: TCGCContext, property: ModelProperty): boolean` | Checks if a property should be flattened             |
| `getClientOptions`         | `(type: DecoratedType, key: string): unknown`              | Gets client option value by key from `@clientOption` |

### 4.4 Naming Utilities

| Function                       | Signature                                                                                               | Description                                                   |
| ------------------------------ | ------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| `getLibraryName`               | `(context: TCGCContext, type: Type & { name?: string \| symbol }, scope?: string \| AllScopes): string` | Gets client name respecting `@clientName` and `@friendlyName` |
| `getWireName`                  | `(context: TCGCContext, type: Type & { name: string }): string`                                         | Gets serialized name from `@encodedName` or type name         |
| `getPropertyNames`             | `(context: TCGCContext, property: ModelProperty): [string, string]`                                     | Returns `[libraryName, wireName]` tuple                       |
| `getGeneratedName`             | `(context: TCGCContext, type: Model \| Union \| TspLiteralType, operation?: Operation): string`         | Creates a name for anonymous models                           |
| `getCrossLanguageDefinitionId` | `(context: TCGCContext, type: ..., operation?: Operation, appendNamespace?: boolean): string`           | Returns cross-language definition ID                          |
| `getCrossLanguagePackageId`    | `(context: TCGCContext): [string, readonly Diagnostic[]]`                                               | Returns cross-language package ID                             |

### 4.5 Type Utilities

| Function                  | Signature                                                             | Description                                              |
| ------------------------- | --------------------------------------------------------------------- | -------------------------------------------------------- |
| `getEffectivePayloadType` | `(context: TCGCContext, type: Model, visibility?: Visibility): Model` | Returns named model with same shape for anonymous models |
| `isApiVersion`            | `(context: TCGCContext, type: ModelProperty): boolean`                | Checks if parameter is an API version parameter          |
| `isAzureCoreModel`        | `(t: SdkType): boolean`                                               | Checks if type is from Azure Core library                |
| `isPagedResultModel`      | `(context: TCGCContext, t: SdkType): boolean`                         | Checks if type is a paged result model                   |
| `isHttpMetadata`          | `(context: TCGCContext, property: SdkModelPropertyType): boolean`     | Checks if property is HTTP metadata                      |

### 4.6 HTTP Utilities

| Function                                       | Signature                                                                     | Description                                              |
| ---------------------------------------------- | ----------------------------------------------------------------------------- | -------------------------------------------------------- |
| `getHttpOperationWithCache`                    | `(context: TCGCContext, operation: Operation): HttpOperation`                 | Gets HTTP operation details with caching                 |
| `getHttpOperationExamples`                     | `(context: TCGCContext, operation: HttpOperation): SdkHttpOperationExample[]` | Returns examples for an HTTP operation                   |
| `getHttpOperationParameter`                    | `(method: SdkServiceMethod, param: ...): SdkHttpParameter \| ...`             | Finds HTTP parameter corresponding to a method parameter |
| `getHttpOperationParametersForClientParameter` | `(client: SdkClientType, param: ...): SdkHttpParameter[]`                     | Finds all HTTP parameters for a client-level parameter   |

### 4.7 Other Utilities

| Function                   | Signature                                                                             | Description                  |
| -------------------------- | ------------------------------------------------------------------------------------- | ---------------------------- |
| `listAllServiceNamespaces` | `(context: TCGCContext): Namespace[]`                                                 | Lists all service namespaces |
| `resolveOperationId`       | `(context: TCGCContext, operation: Operation, honorRenaming?: boolean): string`       | Calculates operation ID      |
| `getNamespaceFromType`     | `(type: Type \| SdkClient \| SdkOperationGroup \| undefined): Namespace \| undefined` | Extracts namespace from type |

---

## 5. Emitter Configuration Options

### 5.1 Options in tspconfig.yaml

#### Unbranded Options (`UnbrandedSdkEmitterOptionsInterface`)

| Option                         | Type      | Default | Description                                                                      |
| ------------------------------ | --------- | ------- | -------------------------------------------------------------------------------- |
| `generate-protocol-methods`    | `boolean` | `true`  | Generate low-level protocol methods                                              |
| `generate-convenience-methods` | `boolean` | `true`  | Generate high-level convenience methods                                          |
| `api-version`                  | `string`  | Latest  | Target API version, or `"all"` for all versions                                  |
| `license.name`                 | `string`  | —       | License name (MIT License, Apache 2.0, BSD 3-Clause, MPL 2.0, GPL-3.0, LGPL-3.0) |
| `license.company`              | `string`  | —       | Company name for license header                                                  |
| `license.link`                 | `string`  | —       | URL to license text                                                              |
| `license.header`               | `string`  | —       | Custom license header text                                                       |
| `license.description`          | `string`  | —       | Full license description                                                         |

#### Branded Options (extends Unbranded — `BrandedSdkEmitterOptionsInterface`)

| Option         | Type     | Default      | Description                             |
| -------------- | -------- | ------------ | --------------------------------------- |
| `examples-dir` | `string` | `./examples` | Directory containing example JSON files |
| `namespace`    | `string` | —            | Override namespace for generated code   |

#### TCGC-only Option (`TCGCEmitterOptions`)

| Option         | Type     | Description                                            |
| -------------- | -------- | ------------------------------------------------------ |
| `emitter-name` | `string` | Name of the emitter (e.g., `@typespec/python-emitter`) |

### 5.2 Context Options (`CreateSdkContextOptions`)

| Option                                | Type       | Default       | Description                                                                       |
| ------------------------------------- | ---------- | ------------- | --------------------------------------------------------------------------------- |
| `versioning?.previewStringRegex`      | `RegExp`   | `/-preview$/` | Regex to identify preview API versions                                            |
| `additionalDecorators`                | `string[]` | `[]`          | Additional decorator patterns to preserve in output                               |
| `disableUsageAccessPropagationToBase` | `boolean`  | `false`       | Disable usage/access propagation to base models (for composition-based languages) |
| `exportTCGCoutput`                    | `boolean`  | `false`       | Export TCGC output as `tcgc-output.yaml`                                          |
| `flattenUnionAsEnum`                  | `boolean`  | `true`        | Convert unions to enums when possible                                             |
| `enableLegacyHierarchyBuilding`       | `boolean`  | `true`        | Respect `@hierarchyBuilding` decorator                                            |

### 5.3 Default Decorator Allow List

TCGC preserves these decorator patterns in output by default:

- `TypeSpec\\.Xml\\..*`
- `Azure\\.Core\\.@useFinalStateVia`
- `Autorest\\.@example`
- `Azure\\.ClientGenerator\\.Core\\.@clientOption`

Additional patterns can be added via `additionalDecorators` in `CreateSdkContextOptions`.

---

## 6. Linter Rules

### 6.1 `require-client-suffix`

- **ID:** `@azure-tools/typespec-client-generator-core/require-client-suffix`
- **Severity:** Warning
- **Description:** Client names must end with `Client`.
- **Applies to:** `@client` decorated namespaces/interfaces.
- **Fix:** Use `@client({name: "...Client"})`.
- **Example violation:** `@client @service namespace MyService;` → Error: `Client name "MyService" must end with Client.`

### 6.2 `property-name-conflict`

- **ID:** `@azure-tools/typespec-client-generator-core/property-name-conflict`
- **Severity:** Warning
- **Description:** Avoid property names that match their enclosing model name (case-insensitive). Primarily affects C#.
- **Checks:** Directly defined properties, spread properties, `is` inherited properties. Does NOT check `extends` inherited properties.
- **Fix:** Rename the property or use `@clientName("newName", "csharp")`.
- **Rule Set:** Included in `best-practices:csharp`.

### 6.3 `no-unnamed-types`

- **ID:** `@azure-tools/typespec-client-generator-core/no-unnamed-types`
- **Severity:** Warning
- **Description:** Types should be named explicitly rather than defined inline/anonymously.
- **Checks:** Anonymous models and unions that receive auto-generated names.
- **Exemptions:** Empty models (`{}`), LRO-only models, multipart models, nullable scalars/enums/models (`Foo | null`), unions of only scalars (`string | int32`).
- **Fix:** Extract the anonymous type to a named model or union.

### 6.4 Rule Sets

```
"best-practices:csharp": {
  enable: { "property-name-conflict": true }
}
```

---

## 7. Processing Flow

### High-Level Pipeline

```
TypeSpec Spec
      ↓
createSdkContext(emitContext)
      ↓
createTCGCContext(program) → Initialize caches, parse emitter name
      ↓
createSdkPackage(context)
      ├→ populateApiVersionInformation()
      ├→ handleAllTypes() → Process models/enums/unions
      ├→ listClients() → Find @client/@operationGroup decorators
      └→ createSdkClientType() for each client
             ├→ createSdkMethods() for each operation
             │    ├→ getSdkServiceOperation() → HTTP details
             │    ├→ getSdkMethodParameter() → parameter conversion
             │    └→ Detect LRO/paging metadata
             ├→ addDefaultClientParameters() → endpoint, credentials, apiVersion, subscriptionId
             └→ Recursively process operation groups (sub-clients)
      ↓
SdkPackage → emitter-specific code generation
```

### Client Discovery

1. Scans namespaces/interfaces for `@client` and `@operationGroup` decorators
2. Builds parent-child client hierarchy
3. Resolves client names (override via `@clientName`)
4. Determines namespace and API versions
5. Creates initialization parameters (endpoint, credentials, API version, subscriptionId for ARM)

### Method Categorization

- **Basic:** Standard request/response
- **LRO:** Detects `@pollingOperation`, polling metadata
- **Paging:** Detects `@list`, `@pageItems`, `@nextLink`, `@continuationToken`
- **LRO + Paging:** Both patterns combined
- Protocol vs. convenience controlled by `@protocolAPI` / `@convenientAPI`

### Type Conversion

- Scalars → `SdkBuiltInType`, `SdkDateTimeType`, `SdkDurationType`
- Models → `SdkModelType` with properties and discriminators
- Enums → `SdkEnumType` with values
- Unions → `SdkUnionType` (or flattened to enum if `flattenUnionAsEnum`)
- Arrays/Dicts → `SdkArrayType` / `SdkDictionaryType`
- Nullable → `SdkNullableType`

---

## 8. Feature Areas

This section maps TCGC features to their documentation, Spector specs, and test files.

### 8.1 Client Structure

| Aspect        | Location                                                                 |
| ------------- | ------------------------------------------------------------------------ |
| User docs     | `website/.../howtos/Generate client libraries/03client.mdx`              |
| Spector specs | `packages/azure-http-specs/specs/client/structure/`                      |
| Unit tests    | `packages/typespec-client-generator-core/test/clients/structure.test.ts` |
| Design doc    | `packages/typespec-client-generator-core/design-docs/client.md`          |

Covers: single client, operation groups, multi-layer hierarchy, client splitting, `@client`, `@operationGroup`, `@clientLocation` (moving operations).

### 8.2 Client Initialization

| Aspect        | Location                                                                                                               |
| ------------- | ---------------------------------------------------------------------------------------------------------------------- |
| User docs     | `website/.../howtos/Generate client libraries/03client.mdx` (Client Initialization Parameters section)                 |
| Spector specs | `packages/azure-http-specs/specs/azure/client-generator-core/client-initialization/`                                   |
| Unit tests    | `packages/typespec-client-generator-core/test/decorators/client-initialization.test.ts`, `test/clients/params.test.ts` |
| Design doc    | `packages/typespec-client-generator-core/design-docs/client.md`                                                        |

Covers: `@clientInitialization`, `InitializedBy` flags (individually, parent, customizeCode), `@paramAlias`, parameter elevation.

### 8.3 Client Location (Move Operations/Parameters)

| Aspect        | Location                                                                          |
| ------------- | --------------------------------------------------------------------------------- |
| User docs     | `website/.../howtos/Generate client libraries/03client.mdx`, `04method.mdx`       |
| Spector specs | `packages/azure-http-specs/specs/azure/client-generator-core/client-location/`    |
| Unit tests    | `packages/typespec-client-generator-core/test/decorators/client-location.test.ts` |

Covers: Move operation to existing sub-client, new sub-client, root client; move method parameter to client level.

### 8.4 Methods

| Aspect     | Location                                                                                                                     |
| ---------- | ---------------------------------------------------------------------------------------------------------------------------- |
| User docs  | `website/.../howtos/Generate client libraries/04method.mdx`                                                                  |
| Unit tests | `packages/typespec-client-generator-core/test/methods/` (lro, paged-operation, parameters, responses, streams, file, spread) |

Covers: `@protocolAPI`, `@convenientAPI`, `@access(Access.internal)`, `@responseAsBool`, `@scope`, spread parameters, `@sharedRoute`.

### 8.5 Paging Operations

| Aspect     | Location                                                                       |
| ---------- | ------------------------------------------------------------------------------ |
| User docs  | `website/.../howtos/Generate client libraries/05pagingOperations.mdx`          |
| Unit tests | `packages/typespec-client-generator-core/test/methods/paged-operation.test.ts` |

Covers: `@list`, `@pageItems`/`@items`, `@nextLink`, `@continuationToken`, `@markAsPageable` (legacy), `@disablePageable` (legacy), `@nextLinkVerb` (legacy).

### 8.6 Long-Running Operations

| Aspect     | Location                                                                   |
| ---------- | -------------------------------------------------------------------------- |
| User docs  | `website/.../howtos/Generate client libraries/06longRunningOperations.mdx` |
| Unit tests | `packages/typespec-client-generator-core/test/methods/lro.test.ts`         |

Covers: Resource create/replace/delete, resource action, `@pollingOperation`, `@markAsLro` (legacy).

### 8.7 Multipart Operations

| Aspect     | Location                                                               |
| ---------- | ---------------------------------------------------------------------- |
| User docs  | `website/.../howtos/Generate client libraries/07multipart.mdx`         |
| Unit tests | `packages/typespec-client-generator-core/test/types/multipart.test.ts` |

Covers: `@multipartBody`, `HttpPart`, file handling.

### 8.8 Types

| Aspect     | Location                                                                                                                                                   |
| ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| User docs  | `website/.../howtos/Generate client libraries/08types.mdx`                                                                                                 |
| Unit tests | `packages/typespec-client-generator-core/test/types/` (model, enum, union, bytes, constant, array, dictionary, tuple, date-time, duration, built-in, etc.) |

Covers: Models (discriminators, additional properties, flattening), enums (fixed/extensible), unions, scalars, `@clientNamespace`, `@alternateType`, `@flattenProperty` (legacy), `@hierarchyBuilding` (legacy), nullability, `@deserializeEmptyStringAsNull`.

### 8.9 Renaming

| Aspect        | Location                                                                                                          |
| ------------- | ----------------------------------------------------------------------------------------------------------------- |
| User docs     | `website/.../howtos/Generate client libraries/09renaming.mdx`                                                     |
| Spector specs | `packages/azure-http-specs/specs/client/naming/`                                                                  |
| Unit tests    | `packages/typespec-client-generator-core/test/decorators/client-name.test.ts`, `test/decorators/override.test.ts` |

Covers: `@clientName`, `@encodedName`, language-specific renaming.

### 8.10 Versioning

| Aspect        | Location                                                                                                                                                        |
| ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| User docs     | `website/.../howtos/Generate client libraries/10versioning.mdx`                                                                                                 |
| Spector specs | `packages/azure-http-specs/specs/azure/versioning/`                                                                                                             |
| Unit tests    | `packages/typespec-client-generator-core/test/package/versioning.test.ts`, `test/decorators/api-version.test.ts`, `test/decorators/client-api-versions.test.ts` |

Covers: `@versioned`, single/multiple API versions, `@apiVersion`, `@clientApiVersions`, version-specific models/operations.

### 8.11 Hierarchy Building (Legacy)

| Aspect        | Location                                                                                    |
| ------------- | ------------------------------------------------------------------------------------------- |
| User docs     | `website/.../howtos/Generate client libraries/11hierarchyBuilding.mdx`                      |
| Spector specs | `packages/azure-http-specs/specs/azure/client-generator-core/hierarchy-building/`           |
| Unit tests    | `packages/typespec-client-generator-core/test/decorators/legacy-hierarchy-building.test.ts` |

### 8.12 Client Options

| Aspect     | Location                                                                        |
| ---------- | ------------------------------------------------------------------------------- |
| User docs  | `website/.../howtos/Generate client libraries/12clientOptions.mdx`              |
| Unit tests | `packages/typespec-client-generator-core/test/decorators/client-option.test.ts` |

### 8.13 Package & Namespace

| Aspect     | Location                                                                                                                                                        |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| User docs  | `website/.../howtos/Generate client libraries/02package.mdx`                                                                                                    |
| Unit tests | `packages/typespec-client-generator-core/test/package/` (azure-widget-service, vanilla-widget-service, namespaces, models-only, license, api-versions-metadata) |

### 8.14 Access & Usage

| Aspect        | Location                                                                                                            |
| ------------- | ------------------------------------------------------------------------------------------------------------------- |
| Spector specs | `packages/azure-http-specs/specs/azure/client-generator-core/access/`, `usage/`                                     |
| Unit tests    | `packages/typespec-client-generator-core/test/decorators/access.test.ts`, `usage.test.ts`, `usage-extended.test.ts` |

### 8.15 Alternate Type

| Aspect        | Location                                                                         |
| ------------- | -------------------------------------------------------------------------------- |
| Spector specs | `packages/azure-http-specs/specs/azure/client-generator-core/alternate-type/`    |
| Unit tests    | `packages/typespec-client-generator-core/test/decorators/alternate-type.test.ts` |

### 8.16 Client Doc

| Aspect        | Location                                                                     |
| ------------- | ---------------------------------------------------------------------------- |
| Spector specs | `packages/azure-http-specs/specs/azure/client-generator-core/client-doc/`    |
| Unit tests    | `packages/typespec-client-generator-core/test/decorators/client-doc.test.ts` |

### 8.17 Client Default Value (Legacy)

| Aspect        | Location                                                                               |
| ------------- | -------------------------------------------------------------------------------------- |
| Spector specs | `packages/azure-http-specs/specs/azure/client-generator-core/client-default-value/`    |
| Unit tests    | `packages/typespec-client-generator-core/test/decorators/client-default-value.test.ts` |

### 8.18 Deserialize Empty String as Null

| Aspect        | Location                                                                                           |
| ------------- | -------------------------------------------------------------------------------------------------- |
| Spector specs | `packages/azure-http-specs/specs/azure/client-generator-core/deserialize-empty-string-as-null/`    |
| Unit tests    | `packages/typespec-client-generator-core/test/decorators/deserialize-empty-string-as-null.test.ts` |

### 8.19 Flatten Property (Legacy)

| Aspect        | Location                                                                           |
| ------------- | ---------------------------------------------------------------------------------- |
| Spector specs | `packages/azure-http-specs/specs/azure/client-generator-core/flatten-property/`    |
| Unit tests    | `packages/typespec-client-generator-core/test/decorators/flatten-property.test.ts` |

### 8.20 Override

| Aspect        | Location                                                                   |
| ------------- | -------------------------------------------------------------------------- |
| Spector specs | `packages/azure-http-specs/specs/azure/client-generator-core/override/`    |
| Unit tests    | `packages/typespec-client-generator-core/test/decorators/override.test.ts` |

### 8.21 Response as Bool

| Aspect        | Location                                                                           |
| ------------- | ---------------------------------------------------------------------------------- |
| Spector specs | `packages/azure-http-specs/specs/azure/client-generator-core/response-as-bool/`    |
| Unit tests    | `packages/typespec-client-generator-core/test/decorators/response-as-bool.test.ts` |

### 8.22 Next Link Verb (Legacy)

| Aspect        | Location                                                                         |
| ------------- | -------------------------------------------------------------------------------- |
| Spector specs | `packages/azure-http-specs/specs/azure/client-generator-core/next-link-verb/`    |
| Unit tests    | `packages/typespec-client-generator-core/test/decorators/next-link-verb.test.ts` |

### 8.23 API Version

| Aspect        | Location                                                                                                   |
| ------------- | ---------------------------------------------------------------------------------------------------------- |
| Spector specs | `packages/azure-http-specs/specs/azure/client-generator-core/api-version/` (header, path, query sub-specs) |
| Unit tests    | `packages/typespec-client-generator-core/test/decorators/api-version.test.ts`                              |

### 8.24 Multiple Services

| Aspect        | Location                                                                   |
| ------------- | -------------------------------------------------------------------------- |
| Spector specs | `packages/azure-http-specs/specs/service/multi-service/`                   |
| Design doc    | `packages/typespec-client-generator-core/design-docs/multiple-services.md` |

### 8.25 License

| Aspect     | Location                                                                       |
| ---------- | ------------------------------------------------------------------------------ |
| User docs  | `website/.../howtos/Generate client libraries/02package.mdx` (License section) |
| Unit tests | `packages/typespec-client-generator-core/test/package/license.test.ts`         |

Supported preset licenses: MIT License, Apache License 2.0, BSD 3-Clause, MPL 2.0, GPL-3.0, LGPL-3.0. Custom licenses supported.

---

## 9. Existing Documentation Inventory

### 9.1 User Documentation (`website/.../howtos/Generate client libraries/`)

| File                          | Title                            | Key Topics                                                                                                                                                   |
| ----------------------------- | -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `00howtogen.mdx`              | How to Generate Client Libraries | Overview, setup, multi-language                                                                                                                              |
| `01setup.mdx`                 | Setup for SDK Customization      | Import TCGC, client.tsp pattern                                                                                                                              |
| `02package.mdx`               | Common Package Behavior          | `@service`, `@clientNamespace`, license                                                                                                                      |
| `03client.mdx`                | Client Structure                 | `@client`, `@operationGroup`, `@clientLocation`, `@clientInitialization`, `@scope`, multi-service                                                            |
| `04method.mdx`                | Method Generation                | `@protocolAPI`, `@convenientAPI`, `@access`, `@responseAsBool`, `@scope`, `@clientLocation` for params, spread                                               |
| `05pagingOperations.mdx`      | Paging Operations                | `@list`, `@pageItems`, `@nextLink`, `@continuationToken`, legacy paging decorators                                                                           |
| `06longRunningOperations.mdx` | Long-Running Operations          | Resource CRUD, `@pollingOperation`, `@markAsLro` (legacy)                                                                                                    |
| `07multipart.mdx`             | Multipart Operations             | `@multipartBody`, `HttpPart`, files                                                                                                                          |
| `08types.mdx`                 | Types & Models                   | Namespace, docs, `@alternateType`, default values, models, unions, enums, scalars, `@flattenProperty`, `@hierarchyBuilding`, `@deserializeEmptyStringAsNull` |
| `09renaming.mdx`              | Renaming                         | `@clientName`, `@encodedName`, language-specific                                                                                                             |
| `10versioning.mdx`            | Versioning                       | `@versioned`, API versions, `@apiVersion`, `@clientApiVersions`                                                                                              |
| `11hierarchyBuilding.mdx`     | Multi-Layer Hierarchy (Legacy)   | `@hierarchyBuilding`                                                                                                                                         |
| `12clientOptions.mdx`         | Client Options                   | `@clientOption`, `getClientOptions()`                                                                                                                        |

### 9.2 Emitter Developer Documentation

| File                                                                | Key Topics                                                                                                                                    |
| ------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| `website/.../libraries/typespec-client-generator-core/guideline.md` | `createSdkContext()`, type graph walkthrough, `SdkPackage` → `SdkClientType` → `SdkServiceMethod` → `SdkHttpOperation` → types, example types |

### 9.3 Design Documents (`packages/typespec-client-generator-core/design-docs/`)

| File                   | Topic                                                                    |
| ---------------------- | ------------------------------------------------------------------------ |
| `client.md`            | Client types, decorators, initialization, `InitializedBy`                |
| `multiple-services.md` | Multi-service clients, `@client({service: [A, B]})`, API version merging |

---

## 10. Spector Spec Coverage Map

### Features WITH Spector specs:

| Feature                           | Spec Path                                                                                                                                                  |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Access                            | `azure/client-generator-core/access/`                                                                                                                      |
| Alternate Type                    | `azure/client-generator-core/alternate-type/`                                                                                                              |
| API Version (header, path, query) | `azure/client-generator-core/api-version/`                                                                                                                 |
| Client Default Value              | `azure/client-generator-core/client-default-value/`                                                                                                        |
| Client Doc                        | `azure/client-generator-core/client-doc/`                                                                                                                  |
| Client Initialization             | `azure/client-generator-core/client-initialization/` (default, individually, individuallyParent)                                                           |
| Client Location                   | `azure/client-generator-core/client-location/` (move-method-parameter-to-client, move-to-existing-sub-client, move-to-new-sub-client, move-to-root-client) |
| Deserialize Empty String as Null  | `azure/client-generator-core/deserialize-empty-string-as-null/`                                                                                            |
| Flatten Property                  | `azure/client-generator-core/flatten-property/`                                                                                                            |
| Hierarchy Building                | `azure/client-generator-core/hierarchy-building/`                                                                                                          |
| Next Link Verb                    | `azure/client-generator-core/next-link-verb/`                                                                                                              |
| Override                          | `azure/client-generator-core/override/`                                                                                                                    |
| Response as Bool                  | `azure/client-generator-core/response-as-bool/`                                                                                                            |
| Usage                             | `azure/client-generator-core/usage/`                                                                                                                       |
| Client Structure                  | `client/structure/`                                                                                                                                        |
| Client Naming                     | `client/naming/`                                                                                                                                           |
| Client Namespace                  | `client/namespace/`                                                                                                                                        |
| Multi-Service                     | `service/multi-service/`                                                                                                                                   |

### Features WITHOUT dedicated Spector specs:

| Feature                                      | Has Unit Tests?                                                        | Notes                                                           |
| -------------------------------------------- | ---------------------------------------------------------------------- | --------------------------------------------------------------- |
| `@clientName` (renaming)                     | Yes (`test/decorators/client-name.test.ts`)                            | Covered by `client/naming/` indirectly                          |
| `@convenientAPI` / `@protocolAPI`            | Yes (`test/decorators/convenient-api.test.ts`, `protocol-api.test.ts`) | —                                                               |
| `@scope`                                     | Yes (`test/decorators/scope.test.ts`)                                  | —                                                               |
| `@clientNamespace`                           | Yes (`test/decorators/client-namespace.test.ts`)                       | Covered by `client/namespace/`                                  |
| `@paramAlias`                                | Yes (`test/decorators/param-alias.test.ts`)                            | —                                                               |
| `@clientInitialization` with `customizeCode` | Yes (unit tests)                                                       | Only `default`, `individually`, `individuallyParent` in Spector |
| `@clientApiVersions`                         | Yes (`test/decorators/client-api-versions.test.ts`)                    | —                                                               |
| `@apiVersion(false)` (opt-out)               | Yes (unit tests)                                                       | —                                                               |
| `@clientOption`                              | Yes (`test/decorators/client-option.test.ts`)                          | —                                                               |
| `@clientDoc` with `DocumentationMode.append` | Partial                                                                | Spec exists but may not test both modes                         |
| `@markAsLro` (legacy)                        | Yes (`test/decorators/mark-as-lro.test.ts`)                            | —                                                               |
| `@markAsPageable` (legacy)                   | Yes (`test/decorators/mark-as-pageable.test.ts`)                       | —                                                               |
| `@disablePageable` (legacy)                  | Yes (`test/decorators/disable-pageable.test.ts`)                       | —                                                               |
| `@useSystemTextJsonConverter`                | Limited                                                                | —                                                               |
| License configuration                        | Yes (`test/package/license.test.ts`)                                   | —                                                               |
| Multipart                                    | Yes (`test/types/multipart.test.ts`)                                   | Covered by `azure/payload/`                                     |

---

## 11. Test File Index

### Unit Tests (`packages/typespec-client-generator-core/test/`)

| Directory       | Files                                       | Features Tested                                                                                                                                                                                              |
| --------------- | ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `clients/`      | `structure.test.ts`, `params.test.ts`       | Client hierarchy, initialization parameters                                                                                                                                                                  |
| `decorators/`   | 30 files (see below)                        | All decorators                                                                                                                                                                                               |
| `types/`        | 17 files                                    | Model, enum, union, bytes, constant, array, dict, tuple, datetime, duration, built-in, multipart, encode-merge-patch, body-model-property, doc-summary, serialization-options, usage-flags                   |
| `methods/`      | 7 files                                     | LRO, paging, parameters, responses, streams, file, spread                                                                                                                                                    |
| `http/`         | 3 files                                     | Body params, path params, method parameter segments                                                                                                                                                          |
| `package/`      | 7 files                                     | Azure/vanilla widget service, API version metadata, namespaces, models-only, license, versioning                                                                                                             |
| `public-utils/` | 10+ files                                   | getGeneratedName, getLibraryName, getCrossLanguageDefinitionId, getEffectivePayloadType, getHttpOperationParameter, getPropertyNames, isApiVersion, isHttpMetadata, isPagedResultModel, getDefaultApiVersion |
| `rules/`        | 3 files                                     | require-client-suffix, no-unnamed-types, property-name-conflict                                                                                                                                              |
| `examples/`     | 4 files                                     | HTTP operation examples, loading, helpers, types                                                                                                                                                             |
| `validations/`  | 2 files                                     | Cross-namespace duplicate names, package validations                                                                                                                                                         |
| Root            | `context.test.ts`, `internal-utils.test.ts` | SDK context initialization, internal utilities                                                                                                                                                               |

#### Decorator Test Files (`test/decorators/`):

`access.test.ts`, `alternate-type.test.ts`, `api-version.test.ts`, `client.test.ts`, `client-api-versions.test.ts`, `client-default-value.test.ts`, `client-doc.test.ts`, `client-initialization.test.ts`, `client-location.test.ts`, `client-name.test.ts`, `client-namespace.test.ts`, `client-option.test.ts`, `convenient-api.test.ts`, `deserialize-empty-string-as-null.test.ts`, `disable-pageable.test.ts`, `flatten-property.test.ts`, `general-list.test.ts`, `legacy-hierarchy-building.test.ts`, `mark-as-lro.test.ts`, `mark-as-pageable.test.ts`, `next-link-verb.test.ts`, `override.test.ts`, `param-alias.test.ts`, `protocol-api.test.ts`, `response-as-bool.test.ts`, `scope.test.ts`, `usage.test.ts`, `usage-extended.test.ts`

---

## 12. Type Hierarchy Summary

```
DecoratedType
├── SdkTypeBase
│   ├── SdkBuiltInType<TKind>
│   ├── SdkUtcDateTimeType / SdkOffsetDateTimeType
│   ├── SdkDurationType
│   ├── SdkArrayType
│   ├── SdkTupleType
│   ├── SdkDictionaryType
│   ├── SdkNullableType
│   ├── SdkEnumType
│   ├── SdkEnumValueType
│   ├── SdkConstantType
│   ├── SdkUnionType
│   ├── SdkModelType
│   ├── SdkClientInitializationType
│   ├── SdkCredentialType
│   └── SdkEndpointType
├── SdkClientType<TServiceOperation>
├── SdkModelPropertyTypeBase<TType>
│   ├── SdkEndpointParameter
│   ├── SdkCredentialParameter
│   ├── SdkModelPropertyType
│   ├── SdkHeaderParameter
│   ├── SdkQueryParameter
│   ├── SdkPathParameter
│   ├── SdkCookieParameter
│   ├── SdkBodyParameter
│   ├── SdkMethodParameter
│   └── SdkServiceResponseHeader
├── SdkServiceMethodBase<TServiceOperation>
│   ├── SdkBasicServiceMethod  (kind: "basic")
│   ├── SdkPagingServiceMethod  (kind: "paging")
│   ├── SdkLroServiceMethod  (kind: "lro")
│   └── SdkLroPagingServiceMethod  (kind: "lropaging")
├── SdkNamespace<TServiceOperation>
└── SdkHttpOperation (kind: "http")
```
