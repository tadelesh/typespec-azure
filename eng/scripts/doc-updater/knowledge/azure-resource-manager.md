# Azure Resource Manager Documentation Knowledge Base

## Envelope Property Names

The library uses a consistent `XxxProperty` naming convention for envelope spread models. The old short
names (`ManagedServiceIdentity`, `EntityTag`, `ResourceSku`, `ResourcePlan`, `ResourceKind`, `ManagedBy`,
`Encryption`) are deprecated aliases. Always use the `Property` suffixed names in documentation:

- `ManagedServiceIdentityProperty` (not `ManagedServiceIdentity`)
- `ManagedSystemAssignedIdentityProperty` (not `ManagedSystemAssignedIdentity`)
- `EntityTagProperty` (not `EntityTag`)
- `ResourceSkuProperty` (not `ResourceSku`)
- `ResourcePlanProperty` (not `ResourcePlan`)
- `ResourceKindProperty` (not `ResourceKind`)
- `ManagedByProperty` (not `ManagedBy`)
- `EncryptionProperty` (not `Encryption`)
- `ExtendedLocationProperty`
- `AvailabilityZonesProperty`

## Resource Name Pattern

Always use `...ResourceNameParameter<Resource>` spread pattern in code examples, never manual
`@key/@segment/@path` decorators. The `ResourceNameParameter` model auto-derives key name, segment,
path, and pattern from the resource name.

## Operation Template Names

- `ArmResourceActionNoContentAsync` is **deprecated**. Use `ArmResourceActionNoResponseContentAsync`.
- The non-deprecated templates are: `ArmResourceActionNoContentSync`, `ArmResourceActionSync`,
  `ArmResourceActionAsync`, `ArmResourceActionNoResponseContentAsync`.

## Rule Documentation Format

Rule doc files in `rules/` must have:

- `title` in frontmatter matching the exact rule name from source (e.g., `arm-delete-operation-response-codes`,
  not `delete-operation-response-codes`)
- Full name using `@azure-tools/typespec-azure-resource-manager/<rule-name>`
- Code block title: `title="Full name"` (not `title=- Full name-`)

Known pitfalls:

- `unsupported-type` (singular, not plural `unsupported-types`) belongs to
  `typespec-azure-resource-manager` (not `typespec-azure-core`)
- `no-response-body.md` title was previously wrong (`no-empty-model`)
- Response code rules have `arm-` prefix: `arm-delete-operation-response-codes`,
  `arm-post-operation-response-codes`, `arm-put-operation-response-codes`
- `resource-name-pattern` has `arm-` prefix: `arm-resource-name-pattern`

## Doc Comment Patterns in .tsp Files

- `@dev` comments are **intentional** on template interfaces — never convert them to regular
  doc comments.
- Ghost `@param` tags (referencing non-existent parameters) are a recurring issue in `decorators.tsp`.
- List operation templates (`ArmListBySubscription`, `ArmResourceListByParent`, `ArmResourceListAtScope`)
  had doc comments incorrectly saying "resource being patched" — the correct text is "resource being listed".
- `checkGlobalNameAvailability` and `checkLocalNameAvailability` had "exposes and endpoint" (should be "an").

## Build and Regen

- `pnpm regen-docs` from `packages/typespec-azure-resource-manager/` regenerates reference docs
  at `website/src/content/docs/docs/libraries/azure-resource-manager/reference/`.
- Node 22+ is required. If the environment has Node 20, install Node 22 via `n` package with
  `N_PREFIX=$HOME/.n`.
- Must build the package first (`pnpm -r --filter "@azure-tools/typespec-azure-resource-manager..." build`)
  before regen-docs works.

## Linting Rules

There are 34 registered linting rules in `linter.ts`. An additional unregistered rule
`arm-legacy-operations-discourage` exists in source but is not active and should not be documented.

## Subscription Section Description

The "Subscription-based Resource" section in `resource-type.md` previously incorrectly started with
"Tenant resources use..." — the correct text is "Subscription-based resources use...".
