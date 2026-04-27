# Azure Resource Manager Documentation Knowledge Base

## Envelope Properties

The current (non-deprecated) envelope property models in `lib/models.tsp` use the `Property` suffix:

- `ManagedServiceIdentityProperty` (not `ManagedServiceIdentity`)
- `ManagedSystemAssignedIdentityProperty` (not `ManagedSystemAssignedIdentity`)
- `ResourceSkuProperty` (not `ResourceSku`)
- `EntityTagProperty` (not `EntityTag`)
- `ResourcePlanProperty` (not `ResourcePlan`)
- `ResourceKindProperty` (not `ResourceKind`)
- `ManagedByProperty` (not `ManagedBy`)
- `ExtendedLocationProperty`
- `EncryptionProperty`
- `AvailabilityZonesProperty`
- `DefaultProvisioningStateProperty`

The old names without the `Property` suffix are deprecated aliases that still compile but should not be used in documentation.

## Resource Name Pattern

The recommended pattern for defining ARM resource names is `...ResourceNameParameter<Resource>` with optional `KeyName` and `SegmentName` overrides. Never use explicit `@key` / `@segment` / `@path` decorators in documentation examples when `ResourceNameParameter` can be used instead.

## Rule Reference Doc Conventions

- Rule doc frontmatter `title` must exactly match the registered rule name from `src/rules/*.ts`
- Many rules have an `arm-` prefix (e.g., `arm-delete-operation-response-codes`), while others do not (e.g., `beyond-nesting-levels`, `resource-name`)
- The full name in the doc body must use the correct package namespace: `@azure-tools/typespec-azure-resource-manager/<rule-name>`
- The `unsupported-type` rule belongs to the ARM package, not `@azure-tools/typespec-azure-core`

## Deprecated Operation Templates

- `ArmResourceCreateOrUpdateSync` → use `ArmResourceCreateOrReplaceSync`
- `ArmResourceCreateOrUpdateAsync` → use `ArmResourceCreateOrReplaceAsync`
- `ArmResourceDeleteAsync` → use `ArmResourceDeleteWithoutOkAsync`
- `ResourceOperations` → use `TrackedResourceOperations`

## Common Typos Found in Source

Watch for these recurring typos in `.tsp` doc comments:

- "Metching" → "Matching" (in suppress directives)
- "containign" → "containing"
- "compatability" → "compatibility"
- Missing closing parentheses in `@template` doc tags
- Malformed `@doc` template strings like `{name SomeText}` instead of `{name} SomeText`

## Build and Regen Commands

- `pnpm regen-docs` must be run from `packages/typespec-azure-resource-manager/` after editing any `.tsp` doc comment in `lib/`
- The project requires Node.js >= 22; use `/opt/hostedtoolcache/node/22.22.2/x64/bin` on GitHub Actions runners
- Build the ARM package first: `pnpm -r --filter "@azure-tools/typespec-azure-resource-manager..." build`
- Build tspd first if needed: `pnpm -r --filter "@typespec/tspd..." build`
