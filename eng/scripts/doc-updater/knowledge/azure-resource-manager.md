# Azure Resource Manager Documentation Knowledge Base

## Build & Regen Requirements

- Node.js >=22 is required for building and regenerating docs.
- To regen docs: first build with `pnpm -r --filter "@azure-tools/typespec-azure-resource-manager..." build`, then run `pnpm regen-docs` from the package directory.
- The build also generates `README.md` and `generated-defs/Azure.ResourceManager.ts` from doc comments in `lib/decorators.tsp`.

## Common Copy-Paste Errors in `lib/operations.tsp`

- LIST operation templates (`ArmListBySubscription`, `ArmResourceListByParent`, `ArmResourceListAtScope`) and their legacy counterparts (`ArmListSinglePageBySubscription`, `ArmListSinglePageByParent`) often have `@template Resource the resource being patched` copied from PATCH templates. The correct text for list operations is `the resource being listed`.
- PATCH operation templates correctly use `the resource being patched` — do not change those.

## Common Copy-Paste Errors in `lib/responses.tsp`

- `ArmResourceCreatedResponse` and `ArmResourceCreatedSyncResponse` often copy `The resource being updated` from `ArmResourceUpdatedResponse`. The correct text for create responses is `The resource being created`.

## Deprecated Aliases in `lib/models.tsp`

All original short-name aliases are deprecated. The current names use the `*Property` suffix:

| Deprecated Alias                | Current Name                            |
| ------------------------------- | --------------------------------------- |
| `ManagedServiceIdentity`        | `ManagedServiceIdentityProperty`        |
| `ManagedSystemAssignedIdentity` | `ManagedSystemAssignedIdentityProperty` |
| `EntityTag`                     | `EntityTagProperty`                     |
| `ResourceKind`                  | `ResourceKindProperty`                  |
| `ResourcePlan`                  | `ResourcePlanProperty`                  |
| `ResourceSku`                   | `ResourceSkuProperty`                   |
| `ManagedBy`                     | `ManagedByProperty`                     |
| `Encryption`                    | `EncryptionProperty`                    |

## Deprecated Operation Templates

| Deprecated                       | Replacement                       |
| -------------------------------- | --------------------------------- |
| `ArmResourceCreateOrUpdateSync`  | `ArmResourceCreateOrReplaceSync`  |
| `ArmResourceDeleteAsync`         | `ArmResourceDeleteWithoutOkAsync` |
| `ResourceOperations` (interface) | `TrackedResourceOperations`       |

## Rule Documentation Patterns

- Rule documentation files live under `website/src/content/docs/docs/libraries/azure-resource-manager/rules/`.
- The frontmatter `title` must exactly match the rule `name` string in the source `.ts` file under `src/rules/`.
- The "Full name" code block must use `@azure-tools/typespec-azure-resource-manager/<rule-name>`.
- Common errors: missing `arm-` prefix in title/full-name, wrong package namespace (e.g., `azure-core` instead of `azure-resource-manager`), plural vs singular mismatch.
- Filenames do NOT need the `arm-` prefix (the auto-generated `linter.md` links to files by their current names).

## Resource Name Patterns

- The canonical way to define a resource name is via `...ResourceNameParameter<Resource>` spread, not manual `@key`/`@segment`/`@path` decorators.
- `ResourceNameParameter` accepts optional template parameters: `KeyName`, `SegmentName`, `NamePattern`.
- Getting-started and how-to examples should consistently use the spread pattern.

## Envelope Properties

The complete set of non-deprecated envelope properties in `lib/models.tsp`:

- `ManagedServiceIdentityProperty` — both system and user-assigned managed identity
- `ManagedSystemAssignedIdentityProperty` — system-assigned only
- `EntityTagProperty` — ETag support
- `ResourceKindProperty` — portal UX kind
- `ResourcePlanProperty` — marketplace billing
- `ResourceSkuProperty` — SKU/tier
- `ManagedByProperty` — managed-by relationship
- `ExtendedLocationProperty` — extended locations (Edge Zones)
- `EncryptionProperty` — customer-managed key encryption
- `AvailabilityZonesProperty` — availability zones
