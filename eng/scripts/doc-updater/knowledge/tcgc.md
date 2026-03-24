# TCGC Documentation Knowledge Base

## Package Info

- **Name:** `@azure-tools/typespec-client-generator-core`
- **TypeSpec entry:** `lib/main.tsp`
- **TypeSpec decorators defined in:** `lib/decorators.tsp`, `lib/legacy.tsp`

## Decorator → Doc Page Mapping

| Decorator               | Howto Page                | Reference Page  | Spector Spec                                         |
| ----------------------- | ------------------------- | --------------- | ---------------------------------------------------- |
| `@access`               | `04method.mdx`            | `decorators.md` | `azure/client-generator-core/access/`                |
| `@alternateType`        | `08types.mdx`             | `decorators.md` | `azure/client-generator-core/alternate-type/`        |
| `@apiVersion`           | `10versioning.mdx`        | `decorators.md` | `azure/client-generator-core/api-version/`           |
| `@client`               | `03client.mdx`            | `decorators.md` | `client/structure/`                                  |
| `@clientApiVersions`    | `10versioning.mdx`        | `decorators.md` | `azure/client-generator-core/client-api-versions/`   |
| `@clientDoc`            | `08types.mdx`             | `decorators.md` | —                                                    |
| `@clientInitialization` | `03client.mdx`            | `decorators.md` | `azure/client-generator-core/client-initialization/` |
| `@clientLocation`       | `03client.mdx`,`04method` | `decorators.md` | `azure/client-generator-core/client-location/`       |
| `@clientName`           | `09renaming.mdx`          | `decorators.md` | `client/naming/`                                     |
| `@clientNamespace`      | `03client.mdx`,`08types`  | `decorators.md` | `client/namespace/`                                  |
| `@clientOption`         | `12clientOptions.mdx`     | `decorators.md` | —                                                    |
| `@convenientAPI`        | `04method.mdx`            | `decorators.md` | (partial in `usage/`)                                |
| `@deserializeEmpty…`    | `08types.mdx`             | `decorators.md` | `azure/client-generator-core/deserialize-empty-…/`   |
| `@operationGroup`       | — (deprecated)            | `decorators.md` | —                                                    |
| `@override`             | `04method.mdx`            | `decorators.md` | `azure/client-generator-core/override/`              |
| `@paramAlias`           | `03client.mdx`            | `decorators.md` | `azure/client-generator-core/client-initialization/` |
| `@protocolAPI`          | `04method.mdx`            | `decorators.md` | (partial in `usage/`)                                |
| `@responseAsBool`       | `04method.mdx`            | `decorators.md` | `azure/client-generator-core/response-as-bool/`      |
| `@scope`                | `04method.mdx`            | `decorators.md` | —                                                    |
| `@usage`                | `04method.mdx`            | `decorators.md` | `azure/client-generator-core/usage/`                 |
| `@useSystemTextJson…`   | — (C#-specific)           | `decorators.md` | —                                                    |

### Legacy Decorators

| Decorator             | Howto Page            | Spector Spec                                        |
| --------------------- | --------------------- | --------------------------------------------------- |
| `@clientDefaultValue` | `08types.mdx`         | `azure/client-generator-core/client-default-value/` |
| `@disablePageable`    | —                     | —                                                   |
| `@flattenProperty`    | —                     | `azure/client-generator-core/flatten-property/`     |
| `@hierarchyBuilding`  | `11hierarchyBuilding` | `azure/client-generator-core/hierarchy-building/`   |
| `@markAsLro`          | —                     | —                                                   |
| `@markAsPageable`     | —                     | —                                                   |
| `@nextLinkVerb`       | —                     | `azure/client-generator-core/next-link-verb/`       |

## Key Public Types (guideline.md)

- **SdkClientType**: kind, name, namespace, doc, summary, crossLanguageDefinitionId, clientInitialization, methods, apiVersions, parent, children
- **SdkServiceMethod** variants: SdkBasicServiceMethod, SdkPagingServiceMethod, SdkLroServiceMethod, SdkLroPagingServiceMethod
- **InitializedByFlags**: Default (0), Individually (1), Parent (2), CustomizeCode (4)

## Doc Conventions

- Howto pages use `<ClientTabs>` with inline code blocks (no `<ClientTabItem>` wrappers in newer sections)
- Language order: typespec, python, csharp, typescript, java, go
- Unsupported languages use `// NOT_SUPPORTED` or `# NOT_SUPPORTED`
- TypeSpec code blocks use `title="main.tsp"` / `title="client.tsp"` attributes
- Augment decorators (`@@decorator`) go in `client.tsp`; service definitions in `main.tsp`
- Legacy decorators should be referenced with full path: `@Azure.ClientGenerator.Core.Legacy.decoratorName`
