# TCGC Documentation Knowledge Base

## Package Info

- **Name:** `@azure-tools/typespec-client-generator-core`
- **TSP namespace:** `Azure.ClientGenerator.Core` (current), `Azure.ClientGenerator.Core.Legacy` (legacy)

## Decorators → Doc Page Mapping

| Decorator                     | Doc Page (howto)               | Section                                  |
| ----------------------------- | ------------------------------ | ---------------------------------------- |
| @client                       | 03client.mdx                   | Default / Customizations                 |
| @operationGroup (deprecated)  | 03client.mdx                   | Customizations                           |
| @clientInitialization         | 03client.mdx                   | Customizations                           |
| @clientLocation               | 04method.mdx                   | Using @clientLocation …                  |
| @paramAlias                   | 03client.mdx                   | Customizations                           |
| @clientName                   | 09renaming.mdx                 | All sections                             |
| @clientNamespace              | 08types.mdx / 03client.mdx     | Namespace                                |
| @convenientAPI                | 04method.mdx                   | Convenience and protocol methods         |
| @protocolAPI                  | 04method.mdx                   | Convenience and protocol methods         |
| @access                       | 04method.mdx                   | Make methods private/internal            |
| @usage                        | 04method.mdx                   | Decide the usage of a model              |
| @override                     | 04method.mdx                   | One path for multiple input/output       |
| @scope                        | 04method.mdx                   | Scoping operations to specific languages |
| @responseAsBool               | 04method.mdx                   | Modeling HEAD operations as boolean      |
| @clientDoc                    | 08types.mdx                    | Client Documentation                     |
| @alternateType                | 08types.mdx                    | Using @alternateType …                   |
| @deserializeEmptyStringAsNull | 08types.mdx                    | Deserializing Empty Strings as Null      |
| @apiVersion                   | 10versioning.mdx               | Overriding the Client Api Version Param  |
| @clientApiVersions            | 10versioning.mdx               | Extending the Client Api Version Enum    |
| @clientOption                 | 12clientOptions.mdx            | All sections                             |
| @hierarchyBuilding (legacy)   | 11hierarchyBuilding.mdx        | All sections                             |
| @flattenProperty (legacy)     | 08types.mdx                    | Flattening                               |
| @clientDefaultValue (legacy)  | 08types.mdx                    | Client Default Values (Legacy)           |
| @markAsPageable (legacy)      | 05pagingOperations.mdx         | Legacy Paging Decorators                 |
| @disablePageable (legacy)     | 05pagingOperations.mdx         | Legacy Paging Decorators                 |
| @nextLinkVerb (legacy)        | 05pagingOperations.mdx         | Legacy Paging Decorators                 |
| @markAsLro (legacy)           | 06longRunningOperations.mdx    | Legacy: Force LRO with @markAsLro        |
| @useSystemTextJsonConverter   | (not documented — C#-specific) | —                                        |

## Decorators → Spector Spec Mapping

| Decorator                     | Spector Spec Path                                             |
| ----------------------------- | ------------------------------------------------------------- |
| @client                       | client/structure/\*                                           |
| @clientName                   | client/naming/\*                                              |
| @clientNamespace              | client/namespace/                                             |
| @access                       | azure/client-generator-core/access/                           |
| @usage                        | azure/client-generator-core/usage/                            |
| @override                     | azure/client-generator-core/override/                         |
| @clientInitialization         | azure/client-generator-core/client-initialization/\*          |
| @alternateType                | azure/client-generator-core/alternate-type/                   |
| @apiVersion                   | azure/client-generator-core/api-version/\*                    |
| @clientLocation               | azure/client-generator-core/client-location/\*                |
| @flattenProperty              | azure/client-generator-core/flatten-property/                 |
| @hierarchyBuilding            | azure/client-generator-core/hierarchy-building/               |
| @nextLinkVerb                 | azure/client-generator-core/next-link-verb/                   |
| @clientDefaultValue           | azure/client-generator-core/client-default-value/             |
| @deserializeEmptyStringAsNull | azure/client-generator-core/deserialize-empty-string-as-null/ |
| @responseAsBool               | azure/client-generator-core/response-as-bool/                 |
| @protocolAPI / @convenientAPI | azure/client-generator-core/protocol-api/                     |
| @clientDoc                    | azure/client-generator-core/client-doc/                       |
| @clientApiVersions            | azure/client-generator-core/client-api-versions/              |

## Decorator Signatures (TSP)

All decorators accept an optional `scope?: valueof string` parameter for language targeting.

Scope patterns: `"python"`, `"python, java"`, `"!csharp"`, `"!(java, python)"`.

Language identifiers: `csharp`, `python`, `java`, `javascript`, `go`.

### Current Decorators

```
@clientName(target: unknown, rename: valueof string, scope?)
@convenientAPI(target: Operation | Namespace | Interface, flag?: valueof boolean, scope?)
@protocolAPI(target: Operation | Namespace | Interface, flag?: valueof boolean, scope?)
@client(target: Namespace | Interface, options?: ClientOptions, scope?)
  ClientOptions { service?: Namespace | Namespace[], name?: string, autoMergeService?: boolean }
@usage(target: Model | Enum | Union | Namespace, value: EnumMember | Union, scope?)
  Usage { input: 2, output: 4, json: 256, xml: 512 }
@access(target: ModelProperty | Model | Operation | Enum | Union | Namespace, value: EnumMember, scope?)
  Access { public, internal }
@override(target: Operation, override: Operation, scope?)
@clientInitialization(target: Namespace | Interface, options: ClientInitializationOptions, scope?)
  ClientInitializationOptions { parameters?: Model, initializedBy?: EnumMember | Union }
  InitializedBy { individually: 1, parent: 2 }
@paramAlias(target: ModelProperty, paramAlias: valueof string, scope?)
@clientNamespace(target: Namespace | Interface | Model | Enum | Union, rename: valueof string, scope?)
@alternateType(target: ModelProperty | Scalar | Model | Enum | Union, alternate: unknown | ExternalType, scope?)
  ExternalType { identity: string, package?: string, minVersion?: string }
@scope(target: Operation | ModelProperty, scope?: valueof string)
@apiVersion(target: ModelProperty, value?: valueof boolean, scope?)
@clientApiVersions(target: Namespace, value: Enum, scope?)
@deserializeEmptyStringAsNull(target: ModelProperty, scope?)
@responseAsBool(target: Operation, scope?)
@clientLocation(source: Operation | ModelProperty, target: Interface | Namespace | Operation | valueof string, scope?)
@clientDoc(target: unknown, documentation: valueof string, mode: EnumMember, scope?)
  DocumentationMode { append, replace }
@clientOption(target: unknown, name: valueof string, value: valueof unknown, scope?)
@useSystemTextJsonConverter(target: Model, scope?)
```

### Legacy Decorators (Azure.ClientGenerator.Core.Legacy)

```
@hierarchyBuilding(target: Model, value: Model, scope?)
@flattenProperty(target: ModelProperty, scope?)
@markAsLro(target: Operation, scope?)
@markAsPageable(target: Operation, scope?)
@disablePageable(target: Operation, scope?)
@nextLinkVerb(target: Operation, verb: "GET" | "POST", scope?)
@clientDefaultValue(target: ModelProperty, value: valueof string | boolean | numeric, scope?)
```

## Doc Conventions

- **Howto docs** use `<ClientTabs>` with 6 language blocks: typespec, python, csharp, typescript, java, go
- Use `// NOT_SUPPORTED` when a language doesn't support a feature
- Legacy decorators get `:::caution` admonitions
- TypeSpec examples use `title=main.tsp` / `title=client.tsp` attributes
- Files are numbered sequentially: 00-12
- Guideline.md is for emitter developers (references JS types like `SdkClientType`, `SdkPackage`)
- Design docs reference TSP types (`InitializedBy`, not `InitializedByFlags`)

## Key Type Names

- TSP enum: `InitializedBy` (individually, parent)
- JS interface: `InitializedByFlags` (Individually=1, Parent=2, CustomizeCode=4)
- Raw type: `SdkClient` with `subClients` property
- Type graph: `SdkClientType` with `children` property
- Method kinds: `SdkBasicServiceMethod`, `SdkPagingServiceMethod`, `SdkLroServiceMethod`, `SdkLroPagingServiceMethod`

## Test Files

Decorator tests: `packages/typespec-client-generator-core/test/decorators/`
Type tests: `packages/typespec-client-generator-core/test/types/`
Method tests: `packages/typespec-client-generator-core/test/methods/`
Package tests: `packages/typespec-client-generator-core/test/package/`
