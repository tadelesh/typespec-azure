# TCGC Documentation Knowledge Base

## Decorator Inventory

TCGC defines 21 core decorators in `lib/decorators.tsp` and 7 legacy decorators in `lib/legacy.tsp`.

### Core decorators

| Decorator                       | Target                                                            | Key parameters                                          |
| ------------------------------- | ----------------------------------------------------------------- | ------------------------------------------------------- |
| `@clientName`                   | any type                                                          | `rename: string`, `scope?`                              |
| `@convenientAPI`                | Operation \| Namespace \| Interface                               | `flag?: boolean`, `scope?`                              |
| `@protocolAPI`                  | Operation \| Namespace \| Interface                               | `flag?: boolean`, `scope?`                              |
| `@client`                       | Namespace \| Interface                                            | `options?: ClientOptions`                               |
| `@operationGroup` (deprecated)  | Namespace \| Interface                                            | `scope?`                                                |
| `@usage`                        | Model \| Enum \| Union \| Namespace                               | `value: Usage flags`, `scope?`                          |
| `@access`                       | ModelProperty \| Model \| Operation \| Enum \| Union \| Namespace | `value: Access`, `scope?`                               |
| `@override`                     | Operation                                                         | `override: Operation`, `scope?`                         |
| `@useSystemTextJsonConverter`   | Model                                                             | `scope?`                                                |
| `@clientInitialization`         | Namespace \| Interface                                            | `options: ClientInitializationOptions`                  |
| `@paramAlias`                   | ModelProperty                                                     | `paramAlias: string`, `scope?`                          |
| `@clientNamespace`              | Namespace \| Interface \| Model \| Enum \| Union                  | `rename: string`, `scope?`                              |
| `@alternateType`                | ModelProperty \| Scalar \| Model \| Enum \| Union                 | `alternate: type \| ExternalType`                       |
| `@scope`                        | Operation \| ModelProperty                                        | `scope?`                                                |
| `@apiVersion`                   | ModelProperty                                                     | `value?: boolean`, `scope?`                             |
| `@clientApiVersions`            | Namespace                                                         | `value: Enum`, `scope?`                                 |
| `@deserializeEmptyStringAsNull` | ModelProperty                                                     | `scope?`                                                |
| `@responseAsBool`               | Operation (HEAD only)                                             | `scope?`                                                |
| `@clientLocation`               | Operation \| ModelProperty                                        | `target: Interface \| Namespace \| Operation \| string` |
| `@clientDoc`                    | any type                                                          | `documentation: string`, `mode: DocumentationMode`      |
| `@clientOption`                 | any type                                                          | `name: string`, `value: unknown`                        |

### Legacy decorators (`Azure.ClientGenerator.Core.Legacy`)

| Decorator             | Target        | Notes                                 |
| --------------------- | ------------- | ------------------------------------- |
| `@hierarchyBuilding`  | Model         | Multi-level discriminator inheritance |
| `@flattenProperty`    | ModelProperty | Not recommended for new services      |
| `@markAsLro`          | Operation     | Force LRO treatment                   |
| `@markAsPageable`     | Operation     | Force paging treatment                |
| `@disablePageable`    | Operation     | Prevent paging treatment              |
| `@nextLinkVerb`       | Operation     | GET or POST for next link             |
| `@clientDefaultValue` | ModelProperty | Backward-compat default values        |

## Doc Comment Conventions

- All decorator doc comments live in `lib/decorators.tsp` and `lib/legacy.tsp`.
- The `scope` parameter description follows a standard template with supported language identifiers and valid patterns section.
- Reference docs at `website/…/reference/` are auto-generated; run `pnpm regen-docs` from `packages/typespec-client-generator-core/` to regenerate.
- Never edit files under `reference/` directly.

## User Documentation Structure

User-facing howto pages are at `website/src/content/docs/docs/howtos/Generate client libraries/`:

| File                          | Covers                                                                                 |
| ----------------------------- | -------------------------------------------------------------------------------------- |
| `00howtogen.mdx`              | Overview                                                                               |
| `01setup.mdx`                 | Setup for SDK customization                                                            |
| `02package.mdx`               | `@service`, `@clientNamespace`, license config                                         |
| `03client.mdx`                | Client hierarchy, `@client`, `@clientInitialization`, `@clientLocation`, `@paramAlias` |
| `04method.mdx`                | `@convenientAPI`, `@protocolAPI`, `@access`, `@usage`, `@override`                     |
| `05pagingOperations.mdx`      | Paging patterns                                                                        |
| `06longRunningOperations.mdx` | LRO patterns                                                                           |
| `07multipart.mdx`             | Multipart operations                                                                   |
| `08types.mdx`                 | Types, `@clientNamespace`, `@alternateType`, `@clientDoc`                              |
| `09renaming.mdx`              | `@clientName`                                                                          |
| `10versioning.mdx`            | Versioning, `@apiVersion`                                                              |
| `11hierarchyBuilding.mdx`     | `@hierarchyBuilding` (legacy)                                                          |
| `12clientOptions.mdx`         | `@clientOption`                                                                        |

## Spector Spec Coverage

Specs live under `packages/azure-http-specs/specs/azure/client-generator-core/`. Coverage:

| Decorator                       | Spec directory                      |
| ------------------------------- | ----------------------------------- |
| `@access`                       | `access/`                           |
| `@alternateType`                | `alternate-type/`                   |
| `@apiVersion`                   | `api-version/`                      |
| `@clientDefaultValue`           | `client-default-value/`             |
| `@clientInitialization`         | `client-initialization/`            |
| `@clientLocation`               | `client-location/`                  |
| `@deserializeEmptyStringAsNull` | `deserialize-empty-string-as-null/` |
| `@flattenProperty`              | `flatten-property/`                 |
| `@hierarchyBuilding`            | `hierarchy-building/`               |
| `@nextLinkVerb`                 | `next-link-verb/`                   |
| `@override`                     | `override/`                         |
| `@usage`                        | `usage/`                            |
| `@clientName`                   | `../../../client/naming/`           |
| `@client`                       | `../../../client/structure/`        |
| `@clientNamespace`              | `../../../client/namespace/`        |
| `@scope`                        | `scope/`                            |
| `@responseAsBool`               | `response-as-bool/`                 |

### Still missing dedicated specs

- `@clientDoc`, `@clientApiVersions`, `@protocolAPI`/`@convenientAPI`, `@clientOption`
- Legacy: `@markAsLro`, `@markAsPageable`, `@disablePageable`

## Common Pitfalls

- `@operationGroup` is deprecated — always use `@client` instead.
- The `@paramAlias` example in `decorators.tsp` must pass `{parameters: Model}` to `@@clientInitialization`, not a raw Model.
- Design doc `client.md` had a typo `intializedBy` (fixed to `initializedBy`).
- In the `legacy.tsp` doc for `@markAsLro`, "operatio" was a typo (fixed to "operation").
- `@responseAsBool` only works on `@head` operations; other HTTP verbs emit a diagnostic error.
- External types in `@alternateType` cannot be applied to `ModelProperty` — only to type definitions (Scalar, Model, Enum, Union).
- Spector specs must use `using global.Azure.ClientGenerator.Core;` (with `global.` prefix) in `main.tsp`.

## Cross-references

- `@clientInitialization` and `@paramAlias` are commonly used together (03client.mdx).
- `@clientLocation` can move operations between clients AND move parameters between operations and clients (03client.mdx).
- `@access` propagates through model hierarchies — setting it on an operation affects models used by that operation (04method.mdx).
- `@usage` is additive with bitwise OR — decorator adds to existing usage, never removes (04method.mdx).
- `@scope` uses negation patterns (`!csharp`, `!(java, python)`) that are shared by the `scope` parameter on all other decorators.
