# Azure Resource Manager Documentation Knowledge Base

## Envelope Property Naming

The envelope property models in `lib/models.tsp` use the `*Property` suffix (e.g., `ManagedServiceIdentityProperty`, `EntityTagProperty`, `ResourceSkuProperty`). There are deprecated aliases without the suffix (`ManagedServiceIdentity`, `EntityTag`, `ResourceSku`, etc.) — always use the `*Property` form in documentation examples.

## Action Operations and @segment

ARM resource action operations (using templates like `ArmResourceActionNoContentSync`, `ArmResourceActionAsync`, etc.) should NOT use `@segment(...)` on the operation. The template auto-derives the action name from the operation name. Using `@segment` alongside action templates triggers the `arm-resource-action-no-segment` lint rule because the template internally applies `@armResourceAction`. Samples in `packages/samples/specs/resource-manager/` confirm this pattern (e.g., `move is ActionAsync<Employee, MoveRequest, MoveResponse>` with no `@segment`).

## ResourceNameParameter Pattern

Child resources should use `...ResourceNameParameter<Resource, KeyName = "...", SegmentName = "...">` instead of inline `@key("...") @segment("...") name: string`. The `ResourceNameParameter` model automatically provides `@path` and the name pattern constraint.

## Doc Comment Conventions in .tsp Files

- `@template Resource` descriptions in list operations should say "the resource being listed", not "the resource being patched".
- `@dev` comments are intentional — they prevent descriptions from becoming defaults on template instantiations. Never remove or convert them.
- The `@doc("{name} ...", Resource)` pattern requires proper brace closure: `{name}` not `{name `.

## Auto-Generated Files

When editing `.tsp` doc comments under `lib/`, run `pnpm regen-docs` from the package root. This regenerates:

- `website/src/content/docs/docs/libraries/azure-resource-manager/reference/` (allowed path)
- `packages/typespec-azure-resource-manager/README.md` (generated side-effect)
- `packages/typespec-azure-resource-manager/generated-defs/Azure.ResourceManager.ts` (generated side-effect)

The `reference/linter.md` is auto-generated from registered rules in `src/linter.ts`. Do NOT manually edit it.

## Rule Documentation

Rule doc files in `rules/` must have:

- `title` in frontmatter matching the registered rule name exactly (e.g., `no-response-body`, not `no-empty-model`)
- Full name using the correct package namespace: `@azure-tools/typespec-azure-resource-manager/rule-name`

The `arm-legacy-operations-discourage` rule exists in `src/rules/` but is NOT registered in `src/linter.ts`, so it's inactive and should not be documented.

## Build Commands

- Build: `pnpm -r --filter "@azure-tools/typespec-azure-resource-manager..." build`
- Regen docs: `pnpm regen-docs` (from packages/typespec-azure-resource-manager/)
- Format: `pnpm format` (from repo root)

## Response Type Names

- ARM pagination response: `ResourceListResult<T>` (not `Page<T>` which is Azure.Core)
- Error response: `ErrorResponse` (no type parameter)
