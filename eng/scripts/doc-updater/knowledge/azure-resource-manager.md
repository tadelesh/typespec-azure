# Azure Resource Manager Documentation Knowledge Base

## Envelope Property Naming Convention

The ARM library uses `*Property` suffixed model names for envelope property spread models.
The old un-suffixed aliases are deprecated with `#deprecated` directives in `models.tsp`:

| Current (correct) name                  | Deprecated alias                |
| --------------------------------------- | ------------------------------- |
| `ManagedServiceIdentityProperty`        | `ManagedServiceIdentity`        |
| `ManagedSystemAssignedIdentityProperty` | `ManagedSystemAssignedIdentity` |
| `ResourceSkuProperty`                   | `ResourceSku`                   |
| `EntityTagProperty`                     | `EntityTag`                     |
| `ResourcePlanProperty`                  | `ResourcePlan`                  |
| `ResourceKindProperty`                  | `ResourceKind`                  |
| `ManagedByProperty`                     | `ManagedBy`                     |
| `EncryptionProperty`                    | `Encryption`                    |

Additional envelope properties (no deprecated aliases):

- `ExtendedLocationProperty`
- `AvailabilityZonesProperty`
- `DefaultProvisioningStateProperty`

## Resource Name Parameter Pattern

The idiomatic way to define resource names is `...ResourceNameParameter<Resource>`.
The old manual pattern using `@key`, `@segment`, `@visibility`, `@path` is outdated.
`ResourceNameParameter` is defined in `models.tsp` with template parameters:
`Resource`, `KeyName`, `SegmentName`, `NamePattern`, `Type`.

## ARM Path Conventions in Doc Comments

ARM REST API paths use plural forms:

- `/providers/` (not `/provider/`)
- `/subscriptions/` (not `/subscription/`)

These were incorrectly singular in several `decorators.tsp` doc comments.

## Rule Documentation Pitfalls

- Rule doc file `unsupported-type.md` had wrong namespace (`azure-core` instead of `azure-resource-manager`) and wrong rule name (plural `unsupported-types` instead of singular `unsupported-type`).
- Rule doc file `no-response-body.md` had wrong frontmatter title (`no-empty-model` instead of `no-response-body`).
- The `arm-rules.md` how-to referenced a non-existent rule name `arm-resource-operation-missing-decorator`; the actual rule is `arm-resource-operation`.

## Doc Comment Patterns to Watch

- `@dev` comments in `.tsp` files are intentional — they prevent descriptions from becoming default descriptions of template instantiations. Never remove or convert them to regular doc comments.
- Ghost `@param` tags (documenting parameters that don't exist in the signature) are a recurring issue in `decorators.tsp`.
- The `ArmResourceCreatedResponse` and `ArmResourceCreatedSyncResponse` `@template Resource` descriptions incorrectly said "being updated" instead of "being created".
- List operations (`ArmListBySubscription`, `ArmResourceListByParent`, `ArmResourceListAtScope`) already correctly say "resource being listed" — do not confuse with patch operations which correctly say "resource being patched".

## Response Types Coverage

The response types table in `resource-operations.md` should include:

- `ArmDeleteAcceptedLroResponse` (202)
- `ArmDeletedNoContentResponse` (204)
- `ArmAcceptedLroResponse` (202)
- `ArmResourceExistsResponse` (204)
- `ArmResourceNotFoundResponse` (404)
- `ArmResourceActionNoContentAsync` (202 | 204) — distinct from `ArmResourceActionNoResponseContentAsync` (202 only)

## Build and Regeneration

- Use Node.js >= 22.0.0 (required by core packages)
- Build: `pnpm -r --filter "@azure-tools/typespec-azure-resource-manager..." build`
- Regenerate reference docs: `pnpm regen-docs` from `packages/typespec-azure-resource-manager/`
- Regenerate extern signatures: `pnpm run gen-extern-signature` from `packages/typespec-azure-resource-manager/`
- Both `generated-defs/Azure.ResourceManager.ts` and `README.md` are auto-generated and change when `.tsp` doc comments change

## @service Decorator

The `@service` decorator no longer accepts a `version` parameter. Versioning should be done via `@versioned(Versions)` with a version enum. Each enum member should have `@armCommonTypesVersion` applied.
