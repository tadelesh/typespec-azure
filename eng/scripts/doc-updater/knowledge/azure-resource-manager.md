# Azure Resource Manager Documentation Knowledge Base

## Envelope Property Naming Convention

All envelope property spread models use the `Property` suffix (e.g., `ManagedServiceIdentityProperty`,
`ResourceSkuProperty`, `EntityTagProperty`). The old short names (e.g., `ManagedServiceIdentity`,
`ResourceSku`) exist as deprecated aliases in `lib/models.tsp`. Documentation examples must use the
`Property` suffix forms.

## ResourceNameParameter Spread Pattern

The canonical way to define ARM resource name parameters is with the `...ResourceNameParameter<Resource>`
spread. Explicit `@key`/`@segment`/`@path` decorators on a `name: string` property are the legacy
approach. The spread auto-generates `@key`, `@segment`, `@path`, `@pattern`, and `@doc` decorators.
Override with `KeyName` and `SegmentName` template parameters when the auto-generated names differ from
the desired ones. Canonical samples in `packages/samples/specs/resource-manager/` all use the spread.

## Rule Reference File Patterns

Rule reference files under `website/src/content/docs/docs/libraries/azure-resource-manager/rules/` must
have their frontmatter `title` match the registered rule name exactly (from `createRule({ name: ... })`
in `src/rules/*.ts`). The full name in the body uses the format
`@azure-tools/typespec-azure-resource-manager/<rule-name>`. Watch for:

- Missing `arm-` prefix on delete/post/put-operation-response-codes and resource-name-pattern rules
- The `no-response-body.md` file previously had the wrong title (`no-empty-model`)
- The `unsupported-type.md` file previously had wrong package namespace (`azure-core` vs
  `azure-resource-manager`) and an extra 's' in the name

## TSP Doc Comment Patterns to Watch

- List operation templates (`ArmListBySubscription`, `ArmResourceListByParent`, `ArmResourceListAtScope`)
  had `@template Resource the resource being patched` — should be `listed`
- `@doc` string interpolation requires closing braces: `{name}` not `{name ` (found in
  private-endpoints.tsp CustomPatchSync)
- The `armProviderNameValue` decorator doc previously referenced a non-existent `@armResourceType`
  decorator name and had a ghost `@param resource` tag
- The `armProviderNamespace` decorator had a ghost `@param libraryNamespaces` tag

## Envelope Properties Requiring Documentation

The full list of non-deprecated envelope property spread models in `lib/models.tsp`:

- `ManagedServiceIdentityProperty` — system + user-assigned managed identity
- `ManagedSystemAssignedIdentityProperty` — system-assigned only
- `EntityTagProperty` — ETag concurrency support
- `ResourceKindProperty` — portal UX kind
- `ResourcePlanProperty` — marketplace billing plan
- `ResourceSkuProperty` — SKU-based service level
- `ManagedByProperty` — managed-by relationship
- `EncryptionProperty` — customer-managed key encryption
- `ExtendedLocationProperty` — Edge Zones, Custom Locations
- `AvailabilityZonesProperty` — availability zones
- `DefaultProvisioningStateProperty` — standard provisioning state (for properties bag, not envelope)

## Build and Regeneration Commands

- Build the ARM package: `pnpm -r --filter "@azure-tools/typespec-azure-resource-manager..." build`
- Regenerate reference docs: `pnpm regen-docs` from `packages/typespec-azure-resource-manager/`
- The build also runs `gen-extern-signature` which updates `generated-defs/` and `README.md`
- Requires Node.js >= 22

## Post-Operation Response Codes Rule

The `post-operation-response-codes.md` rule page previously had examples copied from the delete rule
page. Post operations should show `ArmResourceActionSync`/`ArmResourceActionAsync` templates, not
`ArmResourceDeleteSync`/`ArmResourceDeleteWithoutOkAsync`.
