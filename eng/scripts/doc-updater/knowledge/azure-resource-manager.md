# Azure Resource Manager Documentation Knowledge Base

## Library Structure

- TSP library declarations are in `packages/typespec-azure-resource-manager/lib/` (49 files)
- TypeScript source (decorators, rules) in `packages/typespec-azure-resource-manager/src/`
- Samples in `packages/samples/specs/resource-manager/`
- Getting-started docs in `website/src/content/docs/docs/getstarted/azure-resource-manager/`
- How-to guides in `website/src/content/docs/docs/howtos/ARM/`
- Auto-generated reference docs in `website/src/content/docs/docs/libraries/azure-resource-manager/`

## Build and Regeneration Commands

- Build the package: `pnpm -r --filter "@azure-tools/typespec-azure-resource-manager..." build`
- Regenerate reference docs: `pnpm regen-docs` from `packages/typespec-azure-resource-manager/`
- Both require Node.js >= 22.0.0 (use nvm to switch if needed)
- `regen-docs` also regenerates the README.md and is driven by `tspd doc`
- `gen-extern-signature` (run during build) regenerates `generated-defs/Azure.ResourceManager.ts`

## Key Documentation Patterns

### ResourceNameParameter Spread Pattern

All resource models should use `...ResourceNameParameter<Resource>` instead of manual `@key`/`@segment`/`@path` decorators. When replacing manual patterns, always pass explicit `KeyName` and `SegmentName`:

```typespec
// Correct:
model Employee is TrackedResource<EmployeeProperties> {
  ...ResourceNameParameter<Employee, KeyName = "employeeName", SegmentName = "employees">;
}

// Wrong (manual pattern):
model Employee is TrackedResource<EmployeeProperties> {
  @key("employeeName")
  @segment("employees")
  @visibility(Lifecycle.Read)
  @path
  name: string;
}
```

### Action Templates

- `ArmResourceActionNoContentSync` — NOT deprecated, still current
- `ArmResourceActionNoContentAsync` — DEPRECATED, replaced by `ArmResourceActionNoResponseContentAsync`
- There is no `ArmResourceActionNoResponseContentSync` (only the async variant was renamed)
- `@segment` should NOT be used with ARM action templates (rule: `arm-resource-action-no-segment`)

### Deprecated Operation Templates

| Deprecated                        | Replacement                               |
| --------------------------------- | ----------------------------------------- |
| `ArmResourceCreateOrUpdateAsync`  | `ArmResourceCreateOrReplaceAsync`         |
| `ArmResourceCreateOrUpdateSync`   | `ArmResourceCreateOrReplaceSync`          |
| `ArmResourceDeleteAsync`          | `ArmResourceDeleteWithoutOkAsync`         |
| `ArmResourceActionNoContentAsync` | `ArmResourceActionNoResponseContentAsync` |
| `ResourceOperations`              | `TrackedResourceOperations`               |

## Linting Rules

- 34 active rules registered in `src/linter.ts` (35 rule files exist, but `arm-legacy-operations-discourage` is not registered)
- All rules have severity `"warning"`
- Rule doc files are in `website/src/content/docs/docs/libraries/azure-resource-manager/rules/`
- The `reference/linter.md` is auto-generated — do NOT edit directly

## Common Mistakes Found and Fixed

### Doc Comment Issues in .tsp Files

- `decorators.tsp` had ghost `@param` tags for parameters that don't exist on the actual decorator
  - `@param libraryNamespaces` on `armProviderNamespace` (only has `providerNamespace`)
  - `@param resource` on `armProviderNameValue` (has no params)
  - `@param propertiesType` on `armVirtualResource` (only has `provider`)
- `operations.tsp` had copy-paste errors describing list operations as "the resource being patched"
- `private-endpoints.tsp` and `private-links.tsp` had grammar issues ("GET the a" → "GET a")
- `foundations/arm.foundations.tsp` had ghost `@template RequestBody` on `ArmUpdateOperation`
- `interfaces.tsp` described `ResourceDeleteWithoutOkAsync` as synchronous when it's asynchronous

### Rule Documentation File Issues

- Several rule files had incorrect titles missing the `arm-` prefix:
  - `resource-name-pattern.md` → `arm-resource-name-pattern`
  - `delete-operation-response-codes.md` → `arm-delete-operation-response-codes`
  - `post-operation-response-codes.md` → `arm-post-operation-response-codes`
  - `put-operation-response-codes.md` → `arm-put-operation-response-codes`
- `no-response-body.md` had the title `no-empty-model` (copy-paste error)
- `unsupported-type.md` had wrong namespace (`azure-core` instead of `azure-resource-manager`)

### Getting-Started Guide Issues

- `step05.md` User model had doc comment "Address name" for the name property
- `step04.md` action template table referenced deprecated `ArmResourceActionNoContentAsync`
- `step04.md` `ErrorResponse<T>` should be just `ErrorResponse` (no type parameter)
- `@segment` was used on action operations in examples (conflicts with `arm-resource-action-no-segment`)

## Reference Information

### ErrorResponse

`ErrorResponse` is defined as a simple alias with no type parameter:

```
alias ErrorResponse = CommonTypes.ErrorResponse;
```

### Parameter Naming

- Library exports `ResourceGroupParameter` as an alias for `CommonTypes.ResourceGroupNameParameter`
- `@dev` comments on template interfaces are intentional — they prevent descriptions from becoming defaults on instantiations
