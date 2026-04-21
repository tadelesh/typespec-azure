# Azure Resource Manager Documentation — Knowledge Base

## Doc Comment Patterns

- `.tsp` files under `lib/` use `@dev` comments on template interfaces to prevent descriptions leaking
  into instantiations. Never convert `@dev` to regular `/** */` comments; only fix content _within_ them.
- Ghost `@param` / `@template` tags are common — always verify param names against the actual signature
  before trusting doc comments.
- The `@doc("…{name}…", ParentResource)` pattern uses `{name}` as a placeholder resolved at compile
  time. Ensure `{name}` is followed by a space, not merged with adjacent words
  (e.g., `{name} PrivateEndpointConnection`, not `{name PrivateEndpointConnection}`).

## Idiomatic Patterns

- Resource name parameters should always use `...ResourceNameParameter<Resource>` (or with explicit
  `KeyName`/`SegmentName` when auto-derivation doesn't match). Never use manual
  `@key`/`@segment`/`@path` in documentation examples.
- Envelope property spread models use the `*Property` suffix:
  `ManagedServiceIdentityProperty`, `ManagedSystemAssignedIdentityProperty`, `ResourceSkuProperty`,
  `EntityTagProperty`, `ResourcePlanProperty`, `ResourceKindProperty`, `ManagedByProperty`,
  `ExtendedLocationProperty`, `EncryptionProperty`, `AvailabilityZonesProperty`.
  Older aliases without the suffix (e.g., `ManagedServiceIdentity`, `ResourceSku`) are deprecated.
- The `DefaultProvisioningStateProperty` spread adds a standard read-only `provisioningState`.

## Versioning

- ARM specs must use `@versioned(Versions)` on the namespace with an `enum Versions` whose members
  carry `@armCommonTypesVersion(...)` and optionally `@previewVersion`.
- `@armCommonTypesVersion` belongs on the **version enum member**, not the namespace.
- `@service` accepts only `title`; the `version` property does not exist.

## Operation Templates

- `ActionAsync` (returns only `ArmAcceptedLroResponse`) is distinct from `ArmResourceActionAsync`
  (returns both `Response` and `ArmAcceptedLroResponse`). Both must be documented.
- `ArmResourceDeleteWithoutOkAsync` is the recommended async delete (no 200); the older
  `ArmResourceDeleteAsync` (with 200) is deprecated.
- `ProxyResourceOperations` includes Read, Create, Delete, ListByParent — but **not** Patch/Update.
- Operation status scopes: `TenantActionScope`, `SubscriptionActionScope`,
  `TenantLocationActionScope`, `SubscriptionLocationActionScope`,
  `ExtensionResourceActionScope`, `ExtensionActionScope`.

## Linting Rules

- There are 35 rules. Four rule reference files have mismatched names (missing `arm-` prefix):
  `delete-operation-response-codes` → `arm-delete-operation-response-codes`,
  `post-operation-response-codes` → `arm-post-operation-response-codes`,
  `put-operation-response-codes` → `arm-put-operation-response-codes`,
  `resource-name-pattern` → `arm-resource-name-pattern`.
  These are auto-generated; running `pnpm regen-docs` should fix them.
- The rule `arm-legacy-operations-discourage` exists in source but has no reference doc file yet.

## Sample Locations

- Samples live under `packages/samples/specs/resource-manager/`. The directory structure was
  reorganized: old paths like `dynatrace/`, `tenantResource/`, `arm-scenarios/singleton/` no longer
  exist. Current paths use `resource-types/tracked/`, `resource-types/tenant/`,
  `resource-types/singleton/`, etc.

## Environment Notes

- Building and `pnpm regen-docs` require Node.js ≥ 22. If the CI environment only has Node 20,
  the reference docs cannot be regenerated. Fix `.tsp` source and note that regen-docs is needed.
- The `baseTypeIt` parameter name in `@resourceBaseType` is a typo (should be `baseType`) but
  renaming it requires changes to `generated-defs/` and `README.md` (outside allowed doc paths)
  plus the TypeScript implementation. Leave this for a dedicated code change.

## Common Mistakes in Previous Runs

- Confusing `@armResourceOperations` (which accepts `ResourceOperationOptions`) with its
  usage on shorthand interfaces where a resource model argument is passed.
- Describing list operations as "the resource being patched" — copy-paste errors from PATCH
  template docs.
- Saying "synchronous" when the interface is actually async (e.g., `ResourceDeleteWithoutOkAsync`).
