# TCGC Documentation Knowledge Base

## API Signatures and Behaviors

### Core Decorators (Azure.ClientGenerator.Core namespace)

- **@clientName**(target: unknown, rename: valueof string, scope?: valueof string) — Overrides generated names. Target can be any TypeSpec type.
- **@convenientAPI**(target: Operation | Namespace | Interface, flag?: valueof boolean, scope?: valueof string) — Default: true. Inherits to operations in scope.
- **@protocolAPI**(target: Operation | Namespace | Interface, flag?: valueof boolean, scope?: valueof string) — Default: true. Inherits to operations in scope.
- **@client**(target: Namespace | Interface, options?: ClientOptions, scope?: valueof string) — ClientOptions has: service (Namespace | Namespace[]), name (string), autoMergeService (boolean).
- **@operationGroup**(target: Namespace | Interface, scope?: valueof string) — **DEPRECATED**, use @client instead.
- **@usage**(target: Model | Enum | Union | Namespace, value: EnumMember | Union, scope?: valueof string) — Additive (bitwise OR). Usage enum: input=2, output=4, json=256, xml=512.
- **@access**(target: ModelProperty | Model | Operation | Enum | Union | Namespace, value: EnumMember, scope?: valueof string) — Access enum: public, internal. Propagates to parent/sub models.
- **@override**(target: Operation, override: Operation, scope?: valueof string) — Validates parameter compatibility (sorted lexicographically).
- **@useSystemTextJsonConverter**(target: Model, scope?: valueof string) — C# backward compatibility only.
- **@clientInitialization**(target: Namespace | Interface, options: ClientInitializationOptions, scope?: valueof string) — options.parameters is a Model; options.initializedBy is InitializedBy enum (individually=1, parent=2, customizeCode=4). customizeCode cannot be combined with other values.
- **@paramAlias**(target: ModelProperty, paramAlias: valueof string, scope?: valueof string) — Aliases parameter name in client initialization.
- **@clientNamespace**(target: Namespace | Interface | Model | Enum | Union, rename: valueof string, scope?: valueof string)
- **@alternateType**(target: ModelProperty | Scalar | Model | Enum | Union, alternate: unknown | ExternalType, scope?: valueof string) — ExternalType model uses property `identity` (NOT `fullyQualifiedName`). External types (with identity) CANNOT be applied to model properties, only type definitions.
- **@scope**(target: Operation | ModelProperty, scope?: valueof string) — Limits element to specific languages. Supports negation: "!csharp", "!(java, python)".
- **@apiVersion**(target: ModelProperty, value?: valueof boolean, scope?: valueof string) — Default: true. Auto-elevates to client level.
- **@clientApiVersions**(target: Namespace, value: Enum, scope?: valueof string) — Extends API version enum.
- **@deserializeEmptyStringAsNull**(target: ModelProperty, scope?: valueof string) — Target must be string or string-derived scalar.
- **@responseAsBool**(target: Operation, scope?: valueof string) — Only works with @head operations. 2xx→true, 404→false, others→error.
- **@clientLocation**(source: Operation | ModelProperty, target: Interface | Namespace | Operation | valueof string, scope?: valueof string) — Move operations between clients or parameters between operation/client. Cannot use string target for ModelProperty.
- **@clientDoc**(target: unknown, documentation: valueof string, mode: EnumMember, scope?: valueof string) — DocumentationMode: append, replace.
- **@clientOption**(target: unknown, name: valueof string, value: valueof unknown, scope?: valueof string) — Always emits warning, requires suppression.

### Legacy Decorators (Azure.ClientGenerator.Core.Legacy namespace)

- **@hierarchyBuilding**(target: Model, value: Model, scope?: valueof string) — Multi-level discriminated model inheritance.
- **@flattenProperty**(target: ModelProperty, scope?: valueof string) — Cannot be applied to discriminator properties. Not recommended for greenfield.
- **@markAsLro**(target: Operation, scope?: valueof string) — Forces LRO treatment. Must return a model. Creates synthetic LRO metadata with finalStateVia: location.
- **@markAsPageable**(target: Operation, scope?: valueof string) — Forces paging. Needs @pageItems or "value" property in response. Cannot already have @list.
- **@disablePageable**(target: Operation, scope?: valueof string) — Prevents paging even if @list is present.
- **@nextLinkVerb**(target: Operation, verb: "GET" | "POST", scope?: valueof string) — Default: "GET".
- **@clientDefaultValue**(target: ModelProperty, value: valueof string | boolean | numeric, scope?: valueof string)

### Extern Functions

- **replaceParameter**(operation, selector: string | ModelProperty, replacement: ModelProperty): Operation
- **removeParameter**(operation, selector: string | ModelProperty): Operation — Only optional params with @@override.
- **addParameter**(operation, parameter: ModelProperty): Operation
- **reorderParameters**(operation, order: string[]): Operation — All parameters must be included.

## Feature-to-Doc Mapping

| Feature                             | User Doc                   | Reference Doc | Spector Spec                      |
| ----------------------------------- | -------------------------- | ------------- | --------------------------------- |
| @clientName                         | 09renaming.mdx             | decorators.md | client/naming/                    |
| @convenientAPI / @protocolAPI       | 03client.mdx, 04method.mdx | decorators.md | usage/                            |
| @client / @operationGroup           | 03client.mdx               | decorators.md | client/structure/                 |
| @usage                              | 08types.mdx                | decorators.md | usage/                            |
| @access                             | 08types.mdx                | decorators.md | access/                           |
| @override                           | 04method.mdx               | decorators.md | override/                         |
| @clientInitialization / @paramAlias | 03client.mdx               | decorators.md | client-initialization/            |
| @clientNamespace                    | 02package.mdx              | decorators.md | client/namespace/                 |
| @alternateType                      | 08types.mdx                | decorators.md | alternate-type/                   |
| @scope                              | 04method.mdx, 08types.mdx  | decorators.md | scope/                            |
| @apiVersion / @clientApiVersions    | 10versioning.mdx           | decorators.md | api-version/                      |
| @deserializeEmptyStringAsNull       | —                          | decorators.md | deserialize-empty-string-as-null/ |
| @responseAsBool                     | —                          | decorators.md | response-as-bool/                 |
| @clientLocation                     | 03client.mdx, 04method.mdx | decorators.md | client-location/                  |
| @clientDoc                          | 08types.mdx                | decorators.md | client-doc/                       |
| @clientOption                       | 12clientOptions.mdx        | decorators.md | —                                 |
| @hierarchyBuilding                  | 11hierarchyBuilding.mdx    | decorators.md | hierarchy-building/               |
| @flattenProperty                    | 08types.mdx                | decorators.md | flatten-property/                 |
| @markAsLro                          | —                          | decorators.md | —                                 |
| @markAsPageable                     | —                          | decorators.md | —                                 |
| @disablePageable                    | —                          | decorators.md | —                                 |
| @nextLinkVerb                       | —                          | decorators.md | next-link-verb/                   |
| @clientDefaultValue                 | 08types.mdx                | decorators.md | client-default-value/             |

## Doc Conventions

- User docs in `website/src/content/docs/docs/howtos/Generate client libraries/` use numbered prefix filenames (00-12).
- Each user doc file uses `.mdx` extension and frontmatter with `title` and `sidebar.order`.
- Code examples in user docs use `<ClientTabs>` component with tabs for typespec, python, csharp, typescript, java, go.
- All `<ClientTabs>` blocks must be generated by the @doc-example-generator skill.
- Reference docs are auto-generated from TSP doc comments — never edit `reference/` files directly.
- Run `pnpm regen-docs` from `packages/typespec-client-generator-core/` after changing TSP doc comments.
- Legacy decorators should be documented with `:::caution` blocks noting they are legacy/not recommended.
- Emitter developer docs (guideline.md) use `SdkServiceMethodBase.exception` (singular) for error responses, `SdkHttpOperation.exceptions` (plural) for HTTP-level errors.

## Cross-References

- ExternalType model property is `identity` (not `fullyQualifiedName`).
- @paramAlias example in decorators.tsp requires `{parameters: Model}` wrapper for @@clientInitialization.
- InitializedBy.customizeCode (value 4) cannot be combined with other InitializedBy values.
- @scope decorator affects both operations (removing them from SDK) and model properties (removing them from models).
- When @scope removes a required parameter, a diagnostic warning is emitted: `required-parameter-scoped-out`.

## Corrections Applied (2026-03-31)

- Fixed ExternalType property name: `fullyQualifiedName` → `identity` in 08types.mdx.
- Fixed method error response property: `SdkBasicServiceMethod.exceptions` → `SdkBasicServiceMethod.exception` in guideline.md.
- Fixed @paramAlias example: `@@clientInitialization(MyService, MyServiceClientOptions)` → `@@clientInitialization(MyService, {parameters: MyServiceClientOptions})` in decorators.tsp.
- Added Spector specs for: @responseAsBool, @scope, @clientDoc.
