# Azure Resource Manager Documentation Knowledge Base

## Library Structure

- The TSP library source files are in `packages/typespec-azure-resource-manager/lib/`.
- The core files are: `decorators.tsp`, `operations.tsp`, `interfaces.tsp`, `models.tsp`, `responses.tsp`, `parameters.tsp`.
- Extension resource operations are in `lib/extension/operations.tsp` (a separate namespace `Extension`).
- Common types are in `lib/common-types/`.
- Legacy types are in `lib/legacy-types/`.

## Deprecated Property Aliases

The library defines deprecated aliases for envelope property spread models. Always use the `Property`-suffixed names:

| Deprecated Name                 | Current Name                            |
| ------------------------------- | --------------------------------------- |
| `ManagedServiceIdentity`        | `ManagedServiceIdentityProperty`        |
| `ManagedSystemAssignedIdentity` | `ManagedSystemAssignedIdentityProperty` |
| `EntityTag`                     | `EntityTagProperty`                     |
| `ResourceKind`                  | `ResourceKindProperty`                  |
| `ResourcePlan`                  | `ResourcePlanProperty`                  |
| `ResourceSku`                   | `ResourceSkuProperty`                   |
| `ManagedBy`                     | `ManagedByProperty`                     |
| `Encryption`                    | `EncryptionProperty`                    |

## Envelope Properties (Complete List)

All ARM envelope properties that can be spread into resource definitions:

1. `ManagedServiceIdentityProperty` — full managed identity (System + User)
2. `ManagedSystemAssignedIdentityProperty` — system-assigned identity only
3. `EntityTagProperty` — ETag support
4. `ResourceKindProperty` — resource kind for portal UX
5. `ResourcePlanProperty` — marketplace billing plan
6. `ResourceSkuProperty` — SKU-based service tier
7. `ManagedByProperty` — managed-by relationship
8. `ExtendedLocationProperty` — Azure Stack HCI / edge
9. `EncryptionProperty` — customer-managed key encryption (goes in properties model)
10. `AvailabilityZonesProperty` — availability zone support
11. `DefaultProvisioningStateProperty` — default provisioningState property

## Resource Name Pattern

Always use `...ResourceNameParameter<Resource>` spread pattern for resource name fields, not manual `@key/@segment/@path`. The spread pattern includes `@path`, `@key`, `@segment`, and a default `@pattern`.

Custom parameters: `...ResourceNameParameter<Resource, KeyName = "myName", SegmentName = "mySegment">`.

## Provisioning State

The `provisioningState` property must have `@visibility(Lifecycle.Read)`. When using a custom union, mark it with `@lroStatus` and include `ResourceProvisioningState`.

## Doc Comment Conventions

- `@dev` comments on template interfaces are intentional — they prevent the description from becoming the default description of template instantiations. Never convert to regular doc comments.
- `@template` tags document template parameters in doc comments for models.
- `@param` tags must match actual parameters — check for ghost tags.

## Rule Reference Files

Each rule in `website/src/content/docs/docs/libraries/azure-resource-manager/rules/` must have:

- `title:` matching the exact rule name (not plural, not a different rule)
- Full name in the code block matching `@azure-tools/typespec-azure-resource-manager/<rule-name>`

Common mistakes found and fixed:

- `no-response-body.md` had title `no-empty-model` (wrong rule)
- `unsupported-type.md` had title `unsupported-types` (plural) and namespace `@azure-tools/typespec-azure-core` (wrong package)

## Regenerating Docs

After fixing `.tsp` doc comments, run from `packages/typespec-azure-resource-manager/`:

```bash
pnpm regen-docs
```

This updates reference files in `website/src/content/docs/docs/libraries/azure-resource-manager/reference/`. It also updates the package README.md and generated-defs. Run `pnpm gen-extern-signature` as well for TypeScript defs.

## Build Commands

```bash
pnpm -r --filter "@azure-tools/typespec-azure-resource-manager..." build
```

Requires Node.js >= 22.

## Linting Rules

There are 35 linting rules defined in `src/rules/`. The rule `arm-legacy-operations-discourage` exists as a source file but may not be registered in the linter. All other rules are registered in `src/linter.ts`.

## Extension Operations

The `lib/extension/operations.tsp` file defines a full set of extension resource operations under the `Extension` namespace: `ListByTarget`, `Read`, `CheckExistence`, `CreateOrUpdateAsync`, `CreateOrReplaceSync`, `CreateOrReplaceAsync`, `PatchAsync`, `PatchSync`, `DeleteAsync`, `DeleteWithoutOkAsync`, `DeleteSync`, `ActionAsync`, `ActionSync`, `ActionNoContentAsync`, `ActionNoContentSync`. These are not yet fully covered in the how-to guide `resource-operations.md`.

## Samples Location

ARM library samples are at `packages/samples/specs/resource-manager/`. Key subdirectories:

- `resource-types/tracked/`, `proxy/`, `extension/`, `tenant/`, `singleton/`, `location/`, `virtual-resource/`, `specific-extension/`
- `resource-common-properties/managed-identity/`, `encryption/`, `common-properties/`, `private-links/`
- `operations/operation-status/`
