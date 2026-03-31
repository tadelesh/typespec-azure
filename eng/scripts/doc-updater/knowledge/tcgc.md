# TCGC Documentation Knowledge Base

## Decorator Doc Comment Patterns

### @clientApiVersions param description

The `@param value` doc for `@clientApiVersions` in `decorators.tsp` was originally a copy-paste
from `@apiVersion` (which takes a boolean). The correct description should reference that it takes
an `Enum`, not a boolean. Always verify `@param` descriptions match the actual TypeScript signature
in `generated-defs/`.

### @responseAsBool HEAD-only restriction

The `@responseAsBool` decorator only works on HEAD operations. The test
`test/decorators/response-as-bool.test.ts` has a "non-head operation" test case that confirms
diagnostic `non-head-bool-response-decorator` is emitted. The doc comment must mention this
restriction.

### @markAsPageable auto-@pageItems

When `@markAsPageable` is applied, if the return model has a `value` property without `@pageItems`,
TCGC automatically applies `@pageItems` to it. This is tested in
`test/decorators/mark-as-pageable.test.ts` ("should apply @pageItems to 'value' property when not
already decorated").

### @client empty @example tag

The `@client` decorator had an empty `@example` tag at the end of its doc comment. This causes an
empty example section in generated docs. Remove trailing empty `@example` tags.

## Guideline.md Property Placement

### Discriminator properties are on SdkModelType

`discriminatorProperty`, `discriminatedSubtypes`, and `discriminatorValue` are properties of
`SdkModelType` (in `src/interfaces.ts`), NOT `SdkModelPropertyType`. The guideline previously
listed these under Model Property Types.

### additionalProperties is on SdkModelType

`additionalProperties` is a property of `SdkModelType`, not `SdkModelPropertyType`.

### Property name: encode not arrayEncode

The property for array encoding on `SdkModelPropertyType` is named `encode` (type
`ArrayKnownEncoding`), not `arrayEncode`.

## Build and Tooling

### pnpm availability

In CI environments, `pnpm` may not be on PATH. Use `corepack pnpm` or install via
`npm install -g pnpm --prefix $HOME/.local` and add `$HOME/.local/bin` to PATH.

### Regen-docs workflow

After modifying `.tsp` doc comments:

1. Build the package: `pnpm -r --filter "@azure-tools/typespec-client-generator-core..." build`
2. Regenerate docs: `cd packages/typespec-client-generator-core && pnpm regen-docs`
3. This updates `generated-defs/`, `README.md`, and `reference/decorators.md`

## Test Suite Structure

- 92 test files, ~1,234 test cases across 12 categories
- Decorator tests: `test/decorators/` (29 files, 414 tests)
- Type tests: `test/types/` (17 files, 223 tests)
- Method tests: `test/methods/` (7 files, 157 tests)
- Pre-existing timeout flakes in `get-library-name.test.ts` and `general-list.test.ts`

## Documentation Gaps Identified (for future runs)

### Howto docs missing sections

- `08types.mdx`: No dedicated sections for DateTime encoding, Duration types, Constants, Multipart
- `10versioning.mdx`: No `@clientApiVersions` decorator section
- `04method.mdx`: Parameter manipulation functions (`addParameter`, `removeParameter`,
  `replaceParameter`, `reorderParameters`) have minimal documentation

### Spector coverage gaps

Decorators with no Spector spec: `@protocolAPI`, `@useSystemTextJsonConverter`,
`@clientApiVersions`, `@responseAsBool`, `@clientDoc`, `@clientOption`, `@disablePageable`,
`@markAsPageable`
