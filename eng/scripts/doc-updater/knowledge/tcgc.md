# TCGC Documentation Knowledge Base

## Package Overview

**Package**: `@azure-tools/typespec-client-generator-core` (TCGC)
**Source**: `packages/typespec-client-generator-core/`
**Lib files**: `packages/typespec-client-generator-core/lib/`
**TypeSpec namespace**: `Azure.ClientGenerator.Core` (modern) and `Azure.ClientGenerator.Core.Legacy` (legacy)

TCGC introduces a client type graph and provides helper functions for client emitters. It translates TypeSpec specs into an SDK-oriented type graph via `SdkPackage`.

---

## Decorators

### Modern Decorators (namespace: `Azure.ClientGenerator.Core`)

All modern decorators support an optional `scope` parameter (last parameter) with these patterns:

- Single language: `"python"`
- Multiple languages: `"python, java"`
- Negation: `"!csharp"` or `"!(java, python)"`
- Supported scopes: `csharp`, `python`, `java`, `javascript`, `go`

#### `@clientName`

```
extern dec clientName(target: unknown, rename: valueof string, scope?: valueof string)
```

Overrides the generated name for any client SDK element (clients, methods, parameters, unions, models, enums, model properties). Takes precedence over all other naming mechanisms. Augment syntax `@@clientName` is used from `client.tsp`.

**Doc location**: `09renaming.mdx`
**Test file**: `test/decorators/client-name.test.ts`

#### `@convenientAPI`

```
extern dec convenientAPI(target: Operation | Namespace | Interface, flag?: valueof boolean, scope?: valueof string)
```

Controls whether a convenient (high-level) method is generated. Default is `true`. When applied to a namespace or interface, affects all operations within that scope unless explicitly overridden.

**Doc location**: `04method.mdx` (Convenience and protocol methods section)
**Test file**: `test/decorators/convenient-api.test.ts`

#### `@protocolAPI`

```
extern dec protocolAPI(target: Operation | Namespace | Interface, flag?: valueof boolean, scope?: valueof string)
```

Controls whether a protocol (low-level) method is generated. Default is `true`. When applied to a namespace or interface, affects all operations within that scope unless explicitly overridden.

**Doc location**: `04method.mdx` (Convenience and protocol methods section)
**Test file**: `test/decorators/protocol-api.test.ts`

#### `@client`

```
extern dec client(target: Namespace | Interface, options?: ClientOptions, scope?: valueof string)
```

Defines a root client. Cannot be used as augmentation. Cannot be used with `@clientLocation`.

```
model ClientOptions {
  service?: Namespace | Namespace[];  // single or multiple services
  name?: string;                       // defaults to "<TargetName>Client"
  autoMergeService?: boolean;
}
```

**Doc location**: `03client.mdx`
**Test file**: `test/decorators/client.test.ts`

#### `@operationGroup` (**DEPRECATED** — use `@client` instead)

```
extern dec operationGroup(target: Namespace | Interface, scope?: valueof string)
```

Defines a sub client. Deprecated — use `@client` for sub clients instead.

**Doc location**: `03client.mdx` (should be marked with `:::caution`)

#### `@usage`

```
extern dec usage(target: Model | Enum | Union | Namespace, value: EnumMember | Union, scope?: valueof string)
```

Adds usage flags (`Usage.input`, `Usage.output`, `Usage.json`, `Usage.xml`) to models/enums. Usage is propagated to parent models, discriminated sub models, and model properties.

```
enum Usage {
  input: 2,
  output: 4,
  json: 256,
  xml: 512,
}
```

**Doc location**: `04method.mdx` (Decide the usage of a model section)
**Test file**: `test/decorators/usage.test.ts`, `test/decorators/usage-extended.test.ts`

#### `@access`

```
extern dec access(target: Model | Enum | Operation | Union | Namespace, value: EnumMember, scope?: valueof string)
```

Sets the access level (`Access.public` or `Access.internal`) for generated types.

```
enum Access {
  public: "public",
  internal: "internal",
}
```

**Doc location**: `04method.mdx` (Make methods private/internal section)
**Test file**: `test/decorators/access.test.ts`

#### `@override`

```
extern dec override(target: Operation, override: Operation, scope?: valueof string)
```

Replaces the method signature for an operation. Supports transformation functions (`replaceParameter`, `removeParameter`, `addParameter`, `reorderParameters`) as experimental features.

**Doc location**: `04method.mdx` (Customizing method signatures with `@override` section)
**Test file**: `test/decorators/override.test.ts`

#### `@useSystemTextJsonConverter` (C# legacy only)

```
extern dec useSystemTextJsonConverter(target: Model, scope?: valueof string)
```

Forces a model to use the custom JSON converter in C#. Only relevant for backward compatibility in C#. Not recommended for new services.

**Not documented in howto docs** (intentional — very niche, C#-only legacy feature)
**Test file**: implied in types tests

#### `@clientInitialization`

```
extern dec clientInitialization(target: Namespace | Interface, options: ClientInitializationOptions, scope?: valueof string)

model ClientInitializationOptions {
  parameters?: Model;           // model properties to add to client initialization
  initializedBy?: EnumMember | Union;  // InitializedBy.individually | InitializedBy.parent
}

enum InitializedBy {
  individually,
  parent,
}
```

Customizes client initialization parameters and how clients can be initialized (individually and/or by parent).

**Doc location**: `03client.mdx`
**Test file**: `test/decorators/client-initialization.test.ts`

#### `@paramAlias`

```
extern dec paramAlias(target: ModelProperty, paramAlias: valueof string, scope?: valueof string)
```

Aliases the name of a client parameter. Used when elevating a parameter to the client level with `@clientInitialization` and wanting a different client-level name.

**Doc location**: `03client.mdx` (mentioned in client initialization section)
**Test file**: `test/decorators/param-alias.test.ts`

#### `@clientNamespace`

```
extern dec clientNamespace(target: Namespace | Interface | Model | Enum | Union | Operation | Scalar, value: valueof string, scope?: valueof string)
```

Overrides the SDK namespace for a type. Used to move a type to a different namespace in generated SDKs.

**Doc location**: `08types.mdx` (Namespace section)
**Test file**: `test/decorators/client-namespace.test.ts`

#### `@alternateType`

```
extern dec alternateType(target: ModelProperty | Scalar | Model | Enum | Union, alternate: unknown | ExternalType, scope?: valueof string)

model ExternalType {
  identity: string;      // fully qualified type name, e.g. "pystac.Collection"
  package?: string;      // package name, e.g. "pystac"
  minVersion?: string;   // minimum package version, e.g. "1.13.0"
}
```

Sets an alternate emitted type. When the source type is `Scalar`, the alternate must be `Scalar`. `@encode` from the source is overridden by the alternate type's encoding.

**⚠️ Known doc bug**: The `08types.mdx` example incorrectly uses `fullyQualifiedName` — the correct field is `identity`.

**Doc location**: `08types.mdx` (Using `@alternateType` section)
**Test file**: `test/decorators/alternate-type.test.ts`

#### `@scope`

```
extern dec scope(target: Operation | ModelProperty, scope?: valueof string)
```

Limits an operation or model property to specific language emitters. Used to include or exclude elements from certain languages.

**Doc location**: Partially mentioned in `04method.mdx` and `01setup.mdx` (scope parameter on other decorators). No dedicated section.
**Test file**: `test/decorators/scope.test.ts`

#### `@apiVersion`

```
extern dec apiVersion(target: ModelProperty, value?: valueof boolean, scope?: valueof string)
```

Explicitly marks or un-marks a parameter as an API version parameter. By default, parameters named `api-version` or `apiversion`, or referencing the `@versioned` enum, are auto-detected. Default value is `true`.

**Doc location**: `10versioning.mdx` (Overriding the Client Api Version Parameter section)
**Test file**: `test/decorators/api-version.test.ts`

#### `@clientApiVersions`

```
extern dec clientApiVersions(target: Namespace, value: Enum, scope?: valueof string)
```

Specifies additional API versions that the client can support. Useful for extending the API version enum exposed by the client beyond what the versioning decorators provide.

**Doc location**: `10versioning.mdx` (partially mentioned)
**Test file**: `test/decorators/client-api-versions.test.ts`

#### `@deserializeEmptyStringAsNull`

```
extern dec deserializeEmptyStringAsNull(target: ModelProperty, scope?: valueof string)
```

Makes a `string` (or `string`-based scalar) model property deserialize an empty string `""` as `null`. Used for brownfield services that return empty strings to indicate null values.

**Not documented in howto docs** — gap
**Test file**: `test/decorators/deserialize-empty-string-as-null.test.ts`
**Spector spec**: `packages/azure-http-specs/specs/azure/client-generator-core/deserialize-empty-string-as-null/`

#### `@responseAsBool`

```
extern dec responseAsBool(target: Operation, scope?: valueof string)
```

Marks a HEAD operation to return `bool` instead of void/response. `404` returns `false`, `2xx` returns `true`, other status codes still raise errors.

**Not documented in howto docs** — gap
**Test file**: `test/decorators/response-as-bool.test.ts`
**Spector spec**: none (gap)

#### `@clientDoc`

```
extern dec clientDoc(target: unknown, documentation: valueof string, mode: EnumMember, scope?: valueof string)

enum DocumentationMode {
  append: "append",
  replace: "replace",
}
```

Overrides or appends to the documentation generated for a type in client libraries. Can be applied to everything `@doc` can be applied to.

- `DocumentationMode.replace`: replaces `@doc` completely
- `DocumentationMode.append`: appended onto `@doc`

**Doc location**: `08types.mdx` (Client Documentation section)
**Test file**: `test/decorators/client-doc.test.ts`

#### `@clientLocation`

```
extern dec clientLocation(source: Operation | ModelProperty, target: Interface | Namespace | Operation | (valueof string), scope?: valueof string)
```

Moves an operation to a different client, or moves a parameter between operation-level and client-level. Cannot be used with `@client` or `@operationGroup`. Cannot be used on parameters defined in `@clientInitialization`.

**Doc location**: `04method.mdx` (Using `@clientLocation` to control parameter placement section)
**Test file**: `test/decorators/client-location.test.ts`

#### `@clientOption`

```
extern dec clientOption(target: unknown, name: valueof string, value: valueof unknown, scope?: valueof string)
```

Passes experimental flags or emitter-specific options. Always emits a warning (must be suppressed). Also emits a warning if no `scope` is provided. Use standard TCGC decorators when possible.

**Doc location**: `12clientOptions.mdx`
**Test file**: `test/decorators/client-option.test.ts`

---

### Legacy Decorators (namespace: `Azure.ClientGenerator.Core.Legacy`)

Legacy decorators are in `packages/typespec-client-generator-core/lib/legacy.tsp`. All should be documented with `:::caution` admonitions.

#### `@Legacy.hierarchyBuilding`

```
extern dec hierarchyBuilding(target: Model, value: Model, scope?: valueof string)
```

Enables multi-level inheritance for discriminated models. Only for scenarios requiring multi-layer discriminator hierarchies explicitly permitted by SDK architects.

**Doc location**: `11hierarchyBuilding.mdx`
**Test file**: `test/decorators/legacy-hierarchy-building.test.ts`

#### `@Legacy.flattenProperty`

```
extern dec flattenProperty(target: ModelProperty, scope?: valueof string)
```

Flattens a model property (inlines the nested model's properties). Not recommended for new services.

**Doc location**: `08types.mdx` (Flattening section)
**Test file**: `test/decorators/flatten-property.test.ts`

#### `@Legacy.markAsLro`

```
extern dec markAsLro(target: Operation, scope?: valueof string)
```

Forces an operation to be treated as a Long Running Operation even when it isn't service-side. Risk of errors — requires testing.

**Not documented in howto docs** — gap
**Test file**: `test/decorators/mark-as-lro.test.ts`

#### `@Legacy.markAsPageable`

```
extern dec markAsPageable(target: Operation, scope?: valueof string)
```

Forces an operation to be treated as a pageable operation even when it doesn't follow standard paging patterns.

**Not documented in howto docs** — gap
**Test file**: `test/decorators/mark-as-pageable.test.ts`

#### `@Legacy.disablePageable`

```
extern dec disablePageable(target: Operation, scope?: valueof string)
```

Prevents an operation from being treated as pageable even when it follows standard paging patterns (e.g., decorated with `@list`).

**Not documented in howto docs** — gap
**Test file**: `test/decorators/disable-pageable.test.ts`

#### `@Legacy.nextLinkVerb`

```
extern dec nextLinkVerb(target: Operation, verb: "GET" | "POST", scope?: valueof string)
```

Specifies the HTTP verb for the next link operation in a paging scenario. Only `"POST"` and `"GET"` are supported. Default is `"GET"`.

**Not documented in howto docs** — gap
**Spector spec**: `packages/azure-http-specs/specs/azure/client-generator-core/next-link-verb/`
**Test file**: `test/decorators/next-link-verb.test.ts`

#### `@Legacy.clientDefaultValue`

```
extern dec clientDefaultValue(target: ModelProperty | ModelProperty, value: valueof string | number | boolean, scope?: valueof string)
```

Sets a client-level default value. Only for maintaining backward compatibility for brownfield services.

**Doc location**: `08types.mdx` (Client Default Values (Legacy) section)
**Test file**: `test/decorators/client-default-value.test.ts`

---

## Feature Areas

| Feature | Howto Doc | Spector Spec |
|---------|-----------|--------------|
| Client structure | `03client.mdx` | `specs/client/structure/` |
| Method generation | `04method.mdx` | `specs/client/` |
| Paging | `05pagingOperations.mdx` | `specs/client/` |
| LRO | `06longRunningOperations.mdx` | `specs/azure/core/` |
| Multipart | `07multipart.mdx` | `specs/payload/multipart/` |
| Types | `08types.mdx` | various |
| Renaming | `09renaming.mdx` | `specs/client/naming/` |
| Versioning | `10versioning.mdx` | `specs/versioning/` |
| Client options | `12clientOptions.mdx` | none |
| `@access` | `04method.mdx` | `specs/azure/client-generator-core/access/` |
| `@usage` | `04method.mdx` | `specs/azure/client-generator-core/usage/` |
| `@alternateType` | `08types.mdx` | `specs/azure/client-generator-core/alternate-type/` |
| `@clientDoc` | `08types.mdx` | none |
| `@clientInitialization` | `03client.mdx` | `specs/azure/client-generator-core/client-initialization/` |
| `@clientLocation` | `04method.mdx` | `specs/azure/client-generator-core/client-location/` |
| `@clientApiVersions` | `10versioning.mdx` (partial) | none |
| `@deserializeEmptyStringAsNull` | not documented | `specs/azure/client-generator-core/deserialize-empty-string-as-null/` |
| `@responseAsBool` | not documented | none |
| `@flattenProperty` | `08types.mdx` | `specs/azure/client-generator-core/flatten-property/` |
| `@hierarchyBuilding` | `11hierarchyBuilding.mdx` | `specs/azure/client-generator-core/hierarchy-building/` |
| `@nextLinkVerb` | not documented | `specs/azure/client-generator-core/next-link-verb/` |
| `@markAsLro` | not documented | none |
| `@markAsPageable` | not documented | none |
| `@disablePageable` | not documented | none |
| `@clientDefaultValue` | `08types.mdx` | `specs/azure/client-generator-core/client-default-value/` |
| `@override` | `04method.mdx` | `specs/azure/client-generator-core/override/` |

---

## Public Types (SdkPackage type graph)

Key types exposed via the TCGC type graph (`SdkPackage`):

- **`SdkPackage`**: Root package with `clients`, `enums`, `models`, `unions`, `namespaces`
- **`SdkClientType`**: Represents a client or sub-client, with `subClients`, `methods`, `initialization`
- **`SdkClientInitializationType`**: Client initialization parameters
- **`SdkMethodType`**: Operations (basic, paging, LRO, overload)
- **`SdkModelType`**: Model types
- **`SdkEnumType`** / **`SdkEnumValueType`**: Enum and enum values
- **`SdkUnionType`**: Union types
- **`SdkBuiltInType`**: Primitive types (string, int, etc.)
- **`SdkArrayType`**, **`SdkDictionaryType`**, **`SdkNullableType`**, **`SdkTupleType`**: Collection types
- **`SdkModelPropertyType`**: Model properties
- **`SdkHttpParameter`**: HTTP parameters (header, query, path, body, cookie)
- **`AccessFlags`**: `"public"` | `"internal"`
- **`UsageFlags`**: Bitmap: `input=2`, `output=4`, `json=256`, `xml=512`
- **`InitializedByFlags`**: Controls if client can be initialized individually, by parent, or both

---

## Doc Conventions

### User-facing howto docs (`website/src/content/docs/docs/howtos/Generate client libraries/`)

- All `<ClientTabs>` blocks must be produced by `@doc-example-generator` skill
- Six-language tabs: `typespec`, `python`, `csharp`, `typescript`, `java`, `go`
- Legacy decorators marked with `:::caution` admonitions
- Augment decorator syntax `@@decoratorName(Target, ...)` used in `client.tsp` examples
- Import pattern: `import "@azure-tools/typespec-client-generator-core"; using Azure.ClientGenerator.Core;`
- Legacy import: `using Azure.ClientGenerator.Core.Legacy;`
- File split: service spec in `main.tsp`, customizations in `client.tsp`

### Design docs (`packages/typespec-client-generator-core/design-docs/`)

- Internal design documentation with pseudocode and Python-like pseudocode examples
- Focused on user scenarios and architecture decisions

---

## Known Documentation Issues

1. **`@alternateType` uses wrong field name**: `08types.mdx` example uses `fullyQualifiedName` but the correct field in `ExternalType` model is `identity`. Fix needed.

2. **`@responseAsBool` undocumented**: No howto doc section. Should be added to `04method.mdx` or a new section.

3. **`@deserializeEmptyStringAsNull` undocumented**: No howto doc section. Should be added to `08types.mdx`.

4. **Legacy LRO/paging decorators undocumented**: `@markAsLro`, `@markAsPageable`, `@disablePageable`, `@nextLinkVerb` have no howto doc sections.

5. **`@responseAsBool` has no Spector spec**: Gap in coverage.

---

## Test File Paths

- Decorator tests: `packages/typespec-client-generator-core/test/decorators/`
- Type tests: `packages/typespec-client-generator-core/test/types/`
- Method tests: `packages/typespec-client-generator-core/test/methods/`
- HTTP tests: `packages/typespec-client-generator-core/test/http/`
- Client tests: `packages/typespec-client-generator-core/test/decorators/client.test.ts`

---

## Source File Paths

- Main entry: `packages/typespec-client-generator-core/src/index.ts`
- Decorators impl: `packages/typespec-client-generator-core/src/decorators.ts`
- Interfaces (types): `packages/typespec-client-generator-core/src/interfaces.ts`
- Lib decorators: `packages/typespec-client-generator-core/lib/decorators.tsp`
- Lib legacy: `packages/typespec-client-generator-core/lib/legacy.tsp`
