# Azure Resource Manager Documentation Knowledge Base

## Rule Documentation

- Rule doc files under `website/src/content/docs/docs/libraries/azure-resource-manager/rules/` are manually maintained (not auto-generated). The frontmatter `title` must match the actual rule name string from the source code. The full qualified name must use the `@azure-tools/typespec-azure-resource-manager/` namespace prefix.
- Several rules have an `arm-` prefix in their actual name but the doc files were originally created without it. Always check the actual rule name in `packages/typespec-azure-resource-manager/src/rules/*.ts` against the `name:` field.
- The `arm-legacy-operations-discourage` rule exists in source but is NOT registered in `linter.ts`, so it is dead code and should not be documented.
- The `post-operation-response-codes.md` file had copy-paste errors showing delete operation examples instead of post operations.
- The `no-response-body.md` file had its title set to `no-empty-model` (copy-paste from a different rule).
- The `unsupported-type.md` file had its full name pointing to `@azure-tools/typespec-azure-core` instead of `@azure-tools/typespec-azure-resource-manager`.

## TSP Doc Comment Patterns

- LIST operation templates in `operations.tsp` are prone to copy-paste errors from PATCH templates. The `@template Resource` description should say "listed" not "patched".
- `decorators.tsp` has had ghost `@param` tags for parameters that don't exist in the decorator signature. Always verify `@param` tags match the actual parameter names in the decorator/function signature.
- `private-endpoints.tsp` and `private-links.tsp` use `@dev` comments on template interfaces — these are intentional and must not be converted to regular doc comments.
- Grammar pattern "GET the a" appears in private-endpoints.tsp and private-links.tsp @dev comments — should be "Get a".
- `legacy-types/operations.tsp` has a recurring typo "form" instead of "from" in @template ErrorType descriptions.

## Getting Started Guides

- `step03.md` should use `...ResourceNameParameter<Resource, KeyName = "...", SegmentName = "...">` spread pattern instead of manual `@key`/`@segment`/`name` property definitions for child resources. This is the idiomatic pattern demonstrated in `models.tsp` and other samples.
- Child resource properties models should include `provisioningState?: ResourceProvisioningState` for consistency with ARM best practices.

## How-to Guides

- `resource-type.md` has a "Subscription-based Resource" section that was incorrectly described as "Tenant resources" (copy-paste from the Tenant section).
- `versioning.md` documents `@added`, `@removed`, `@madeOptional`, `@madeRequired`, and `@renamedFrom` but was missing `@typeChangedFrom`, which is used in the ARM library's own common-types (e.g., `types.tsp`).

## Build and Regeneration

- Use `pnpm regen-docs` from `packages/typespec-azure-resource-manager/` to regenerate reference docs after fixing TSP doc comments.
- The `regen-docs` command also updates `README.md` and files under `generated-defs/`.
- Building requires Node.js >= 22. Use `pnpm -r --filter "@azure-tools/typespec-azure-resource-manager..." build` before `pnpm regen-docs`.
- The `reference/linter.md`, `reference/decorators.md`, `reference/interfaces.md`, and `reference/data-types.md` files are auto-generated — do NOT edit them directly.
