# Azure Resource Manager Documentation Knowledge Base

## Envelope Property Naming Convention

The spread-able envelope property models all use the `...Property` suffix pattern. The correct names are:

- `...ManagedServiceIdentityProperty` (not `...ManagedServiceIdentity`)
- `...ManagedSystemAssignedIdentityProperty` (not `...ManagedSystemAssignedIdentity`)
- `...ResourceSkuProperty` (not `...ResourceSku`)
- `...EntityTagProperty` (not `...EntityTag`)
- `...ResourcePlanProperty` (not `...ResourcePlan`)
- `...ResourceKindProperty` (not `...ResourceKind`)
- `...ManagedByProperty` (not `...ManagedBy`)
- `...ExtendedLocationProperty`
- `...EncryptionProperty`
- `...AvailabilityZonesProperty`

Source: `packages/typespec-azure-resource-manager/lib/models.tsp`

## Resource Name Parameter Pattern

The idiomatic pattern for resource name parameters uses the `ResourceNameParameter` spread model:

```typespec
model MyResource is TrackedResource<MyProperties> {
  ...ResourceNameParameter<MyResource>;
}
```

This is preferred over manually specifying `@key`, `@segment`, and `@path` individually. The template accepts optional `KeyName`, `SegmentName`, `NamePattern`, and `Type` parameters.

## Doc Comment Patterns in .tsp Files

Several doc comments in the library `.tsp` files have had recurring issues:

1. **Copy-paste errors in `operations.tsp`**: List operation doc comments were incorrectly describing the resource as "being patched" instead of "being listed". Always verify the verb matches the operation type.
2. **Ghost `@param` tags in `decorators.tsp`**: Doc comments sometimes include `@param` entries for parameters that don't exist on the decorator. Check the actual signature.
3. **Typo patterns**: "containign" → "containing", "autoRout" → "autoRoute", "fo" → "of", "and endpoint" → "an endpoint".

## Linting Rules

The ARM linter has 34 registered rules (as of this update), all at `warning` severity. The registration is in `packages/typespec-azure-resource-manager/src/linter.ts`. There is also an unregistered rule file `arm-legacy-operations-discourage.ts` that exists but is not imported into the linter.

## Reference Doc Regeneration

Auto-generated reference docs at `website/src/content/docs/docs/libraries/azure-resource-manager/reference/` must be regenerated after editing `.tsp` doc comments. Run from the ARM package directory:

```bash
pnpm regen-docs
```

This requires Node.js >=22 and a built `tspd` tool. Build with:

```bash
pnpm -r --filter "@azure-tools/typespec-azure-resource-manager..." build
```

## Getting-Started Guide Patterns

- `step05.md` contains the complete example. When fixing patterns in earlier steps, verify consistency with step05.
- `@service()` only accepts `title` (not `version`); versioning is handled by `@versioned`.
- `ResourceListResult<T>` is the ARM paged response type (not `Page<T>`).
- `ErrorResponse` has no template parameter.

## How-To Guide Structure

- `resource-type.md` covers all resource base types and envelope properties — the most comprehensive guide.
- `resource-operations.md` covers all operation templates, response types, interfaces, and update models.
- `arm-rules.md` covers linting rules overview with suppression guidance plus a reference table.
- The private-endpoints, private-links, and network-security-perimeter guides follow a consistent pattern.
