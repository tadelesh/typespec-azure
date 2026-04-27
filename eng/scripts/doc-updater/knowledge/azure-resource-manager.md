# Azure Resource Manager Documentation Knowledge Base

## Library Structure

- TSP library declarations are in `packages/typespec-azure-resource-manager/lib/` with subdirectories: `common-types/`, `extension/`, `foundations/`, `legacy-types/`
- TypeScript implementation is in `packages/typespec-azure-resource-manager/src/`
- Linting rules are in `src/rules/` and registered in `src/linter.ts`
- Reference docs are auto-generated via `pnpm regen-docs` from `packages/typespec-azure-resource-manager/`; rule docs under `rules/` are manually maintained
- Samples are in `packages/samples/specs/resource-manager/`

## Build and Regeneration

- Build: `pnpm -r --filter "@azure-tools/typespec-azure-resource-manager..." build`
- Regenerate reference docs: `pnpm regen-docs` from the ARM package directory
- The regen-docs command outputs to `website/src/content/docs/docs/libraries/azure-resource-manager/reference/`
- Rule docs under `rules/` are NOT auto-generated; edit them directly
- Format: `pnpm format` from repo root

## Common Patterns and Pitfalls

### Deprecated Envelope Property Aliases

The following aliases in `lib/models.tsp` are deprecated. Always use the `Property`-suffixed versions:

| Deprecated                      | Current                                 |
| ------------------------------- | --------------------------------------- |
| `ManagedServiceIdentity`        | `ManagedServiceIdentityProperty`        |
| `ManagedSystemAssignedIdentity` | `ManagedSystemAssignedIdentityProperty` |
| `ResourceSku`                   | `ResourceSkuProperty`                   |
| `EntityTag`                     | `EntityTagProperty`                     |
| `ResourcePlan`                  | `ResourcePlanProperty`                  |
| `ResourceKind`                  | `ResourceKindProperty`                  |
| `ManagedBy`                     | `ManagedByProperty`                     |

### All Envelope Properties

The complete set of spreadable envelope properties is:

1. `ManagedServiceIdentityProperty` — system + user-assigned identity
2. `ManagedSystemAssignedIdentityProperty` — system-assigned only
3. `EntityTagProperty` — eTag
4. `ResourceSkuProperty` — SKU
5. `ResourcePlanProperty` — marketplace plan
6. `ResourceKindProperty` — resource kind
7. `ManagedByProperty` — managedBy
8. `ExtendedLocationProperty` — edge zones/extended locations
9. `AvailabilityZonesProperty` — availability zones
10. `EncryptionProperty` — CMK encryption

### ResourceNameParameter

Always use `...ResourceNameParameter<T>` spread instead of manual `@key`/`@segment`/`@path` decorators. It auto-generates camelCase key and pluralized segment names. Custom names: `ResourceNameParameter<T, KeyName = "customKey", SegmentName = "customSegment">`.

### `@dev` Comments

The `@dev` tag in TSP doc comments prevents the description from becoming the default description of template instantiations. Never convert `@dev` to regular `/** */` or remove it.

### Linter Rules

There are 34 actively registered rules in `src/linter.ts`. The rule `arm-legacy-operations-discourage` exists as a source file but is NOT registered in the linter — do not create docs for it.

### Autorest Import

`@azure-tools/typespec-autorest` should NOT be imported in TypeSpec source files. It's only used as an emitter via tspconfig.yaml or `--emit` flag.

## Recurring Doc Comment Issues

- TSP files tend to accumulate ghost `@template` tags when template parameters are refactored
- The word "documentary" appears in several description template params and should just be "description"
- Legacy operation templates have typos with "form" instead of "from"

## Rule Doc Format

Rule reference files in `rules/` use frontmatter with `title:` matching the rule name (without package prefix). The "Full name" code block should use format ` ```text title="Full name" ` and contain `@azure-tools/typespec-azure-resource-manager/<rule-name>`.
