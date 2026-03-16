# TCGC Documentation Knowledge Base

## Package Info

- **Package**: `@azure-tools/typespec-client-generator-core`
- **Version**: 0.66.2
- **Decorator definitions**: `lib/decorators.tsp` (main), `lib/legacy.tsp` (legacy)
- **Public types**: `src/interfaces.ts`

## Decorator → Doc Page Mapping

| Decorator                       | Howto Doc Page                | Section                                          |
| ------------------------------- | ----------------------------- | ------------------------------------------------ |
| `@clientName`                   | `09renaming.mdx`              | Main content                                     |
| `@convenientAPI`                | `04method.mdx`                | Convenience and protocol methods                 |
| `@protocolAPI`                  | `04method.mdx`                | Convenience and protocol methods                 |
| `@client`                       | `03client.mdx`                | Client hierarchy                                 |
| `@operationGroup`               | `03client.mdx`                | Client hierarchy                                 |
| `@usage`                        | `08types.mdx`                 | (referenced in multiple places)                  |
| `@access`                       | `08types.mdx`                 | (referenced in multiple places)                  |
| `@override`                     | `04method.mdx`                | (referenced in client customization)             |
| `@clientInitialization`         | `03client.mdx`                | Client initialization section                    |
| `@paramAlias`                   | `03client.mdx`                | Client initialization section                    |
| `@clientNamespace`              | `02package.mdx`               | Namespace customization                          |
| `@alternateType`                | `08types.mdx`                 | Using @alternateType to Reference External Types |
| `@clientLocation`               | `03client.mdx`                | Client hierarchy customization                   |
| `@clientLocation` (params)      | `04method.mdx`                | Using @clientLocation to control parameter       |
| `@clientDoc`                    | `08types.mdx`                 | Client Documentation                             |
| `@clientOption`                 | `12clientOptions.mdx`         | Main content                                     |
| `@apiVersion`                   | `10versioning.mdx`            | Overriding the Client Api Version Parameter      |
| `@clientApiVersions`            | `10versioning.mdx`            | Extending Client API Versions                    |
| `@scope`                        | `04method.mdx`                | Using @scope to control language applicability   |
| `@responseAsBool`               | `04method.mdx`                | Using @responseAsBool for HEAD operations        |
| `@deserializeEmptyStringAsNull` | `08types.mdx`                 | Deserializing Empty Strings as Null              |
| `@hierarchyBuilding`            | `08types.mdx`                 | Multi-Level Inheritance (Legacy)                 |
| `@hierarchyBuilding`            | `11hierarchyBuilding.mdx`     | Main content                                     |
| `@flattenProperty`              | `08types.mdx`                 | Flattening                                       |
| `@clientDefaultValue`           | `08types.mdx`                 | Client Default Values (Legacy)                   |
| `@markAsLro`                    | `06longRunningOperations.mdx` | Forcing an Operation to Be LRO (Legacy)          |
| `@markAsPageable`               | `05pagingOperations.mdx`      | Legacy Paging Decorators                         |
| `@disablePageable`              | `05pagingOperations.mdx`      | Legacy Paging Decorators                         |
| `@nextLinkVerb`                 | `05pagingOperations.mdx`      | Legacy Paging Decorators                         |

## Decorator → Spector Spec Mapping

| Decorator                       | Spec Directory                                                  |
| ------------------------------- | --------------------------------------------------------------- |
| `@access`                       | `azure/client-generator-core/access/`                           |
| `@usage`                        | `azure/client-generator-core/usage/`                            |
| `@flattenProperty`              | `azure/client-generator-core/flatten-property/`                 |
| `@clientName`                   | `client/naming/`                                                |
| `@clientNamespace`              | `client/namespace/`                                             |
| `@clientInitialization`         | `azure/client-generator-core/client-initialization/`            |
| `@clientLocation`               | `azure/client-generator-core/client-location/`                  |
| `@clientDefaultValue`           | `azure/client-generator-core/client-default-value/`             |
| `@override`                     | `azure/client-generator-core/override/`                         |
| `@alternateType`                | `azure/client-generator-core/alternate-type/`                   |
| `@hierarchyBuilding`            | `azure/client-generator-core/hierarchy-building/`               |
| `@nextLinkVerb`                 | `azure/client-generator-core/next-link-verb/`                   |
| `@deserializeEmptyStringAsNull` | `azure/client-generator-core/deserialize-empty-string-as-null/` |
| `@responseAsBool`               | `azure/client-generator-core/response-as-bool/`                 |
| `@scope`                        | `azure/client-generator-core/scope/`                            |
| `@clientApiVersions`            | `azure/client-generator-core/client-api-versions/`              |

## Key Type Names (current as of v0.66.2)

| Type Name                     | Location        | Notes                                  |
| ----------------------------- | --------------- | -------------------------------------- |
| `SdkClientType`               | `interfaces.ts` | Has `children` (not `subClients`)      |
| `SdkClientInitializationType` | `interfaces.ts` | Was previously `SdkInitializationType` |
| `SdkPackage`                  | `interfaces.ts` | Root package structure                 |
| `SdkServiceMethod`            | `interfaces.ts` | Method on a client                     |
| `SdkHttpOperation`            | `interfaces.ts` | HTTP operation details                 |

## Per-Language Decorator Support

Some decorators are not supported by all language emitters. When a language does not support a decorator, its `<ClientTabItem>` tab must show a single code comment (in that language's comment style) stating the decorator is not supported. **Do not show generated model/client code** for unsupported decorator–language pairs — even if the doc-example-generator skill produces output for that language.

| Decorator                       | Unsupported Languages | Note                             |
| ------------------------------- | --------------------- | -------------------------------- |
| `@deserializeEmptyStringAsNull` | Go                    | Go emitter does not support this |

**Format for unsupported tabs:**

- Go: `// Go does not support @decoratorName`
- Python: `# Python does not support @decoratorName`
- C#: `// C# does not support @decoratorName`
- TypeScript: `// TypeScript does not support @decoratorName`
- Java: `// Java does not support @decoratorName`

## Doc Conventions

- Howto docs use `.mdx` with Astro imports: `import { ClientTabs, ClientTabItem } from "@components/client-tabs"`
- Each `<ClientTabs>` block has 6 language tabs: typespec, python, csharp, typescript, java, go
- Legacy decorators use `:::caution` admonitions with warning text
- Legacy decorators require `#suppress "@azure-tools/typespec-azure-core/no-legacy-usage"` in examples
- Design docs are plain markdown in `design-docs/` directory
- `@scope` parameter pattern: single (`"python"`), multi (`"python, java"`), negation (`"!csharp"`, `"!(java, python)"`)
- When a language does not support a decorator, do **not** show generated code — use a single-line comment in that language's style (see "Per-Language Decorator Support" above)
- The doc-example-generator skill may produce code for languages that don't actually support a decorator; always cross-check against the "Per-Language Decorator Support" table and override the skill output when needed
