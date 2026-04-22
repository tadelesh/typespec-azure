# Azure Resource Manager Documentation Update Knowledge Base

## Library Structure

- Main lib declarations are in `packages/typespec-azure-resource-manager/lib/` with subdirectories:
  `common-types/`, `foundations/`, `legacy-types/`, `extension/`
- Implementation source in `packages/typespec-azure-resource-manager/src/` with `rules/` subdirectory
- 34 linting rules registered in `src/linter.ts`
- Samples in `packages/samples/specs/resource-manager/`

## Envelope Properties

The library provides these spread-able envelope property models in `models.tsp`. The correct (non-deprecated)
names all end with `Property`:

- `ManagedServiceIdentityProperty` (not ~~ManagedServiceIdentity~~)
- `ManagedSystemAssignedIdentityProperty` (not ~~ManagedSystemAssignedIdentity~~)
- `EntityTagProperty` (not ~~EntityTag~~)
- `ResourceKindProperty` (not ~~ResourceKind~~)
- `ResourcePlanProperty` (not ~~ResourcePlan~~)
- `ResourceSkuProperty` (not ~~ResourceSku~~)
- `ManagedByProperty` (not ~~ManagedBy~~)
- `EncryptionProperty` (not ~~Encryption~~)
- `AvailabilityZonesProperty`
- `ExtendedLocationProperty`
- `DefaultProvisioningStateProperty`

The old names without `Property` suffix are deprecated aliases in `models.tsp`.

Legacy-only property: `ExtendedLocationOptionalProperty` (from `legacy-types/resource.tsp`)

## Linting Rule Naming

Several rules have an `arm-` prefix in their actual registered name but their documentation
files omit it. The correct mapping:

- Rule `arm-delete-operation-response-codes` → file `delete-operation-response-codes.md`
- Rule `arm-post-operation-response-codes` → file `post-operation-response-codes.md`
- Rule `arm-put-operation-response-codes` → file `put-operation-response-codes.md`
- Rule `arm-resource-name-pattern` → file `resource-name-pattern.md`

The frontmatter title and full name in each rule doc must match the registered rule name
(with the `arm-` prefix).

## Common Doc Comment Issues in TSP Files

- List operation templates (ArmListBySubscription, ArmResourceListByParent, ArmResourceListAtScope)
  historically had copy-paste errors saying "resource being patched" instead of "resource being listed"
- The `@dev` tag on template interfaces is intentional — it prevents the description from leaking to
  instantiations. Never convert `@dev` to regular doc comments.
- NSP operations Action and ActionAsync are POST operations, not GET — their `@dev` descriptions
  should reflect this.
- Private endpoint/link operations had typo "GET the a" → should be "GET a"

## Getting Started Guide Patterns

- step02 correctly uses `...ResourceNameParameter<Resource>` spread pattern
- step03 and step05 must also use the spread pattern (not manual @key/@segment/@path)
- step04 response types: use `ResourceListResult<T>` not `Page<T>`, `ErrorResponse` not `ErrorResponse<T>`
- step04 parameters: use `ResourceGroupParameter` (the ARM alias) not `ResourceGroupNameParameter`
- `CommonResourceParameters` does not exist — do not reference it

## Private Links / Endpoints / NSP Operations

Each interface has a `ListSinglePageByParent` legacy operation that is easy to miss:

- `PrivateLinks`: Read, ListByParent, ListSinglePageByParent
- `PrivateEndpoints`: Read, ListByParent, CreateOrUpdateAsync, CreateOrReplaceSync, CreateOrReplaceAsync,
  CustomPatchAsync, CustomPatchSync, DeleteAsync, DeleteSync, DeleteAsyncBase
- `NspConfigurationOperations`: Read, ListByParent, ListSinglePageByParent, Action, ActionAsync

## Extension Operations

The `Extension` namespace (`lib/extension/operations.tsp`) includes these operation templates:

- ListByTarget, Read, CheckExistence
- CreateOrUpdateAsync, CreateOrUpdateSync
- Update, UpdateSync
- Delete
- Action, ActionAsync, ActionNoContentSync, ActionNoResponseContentAsync

## Build and Regen Commands

- Build: `pnpm -r --filter "@azure-tools/typespec-azure-resource-manager..." build`
- Regen docs: `pnpm regen-docs` from `packages/typespec-azure-resource-manager/`
- Requires Node.js >= 22
- Regen-docs updates files under `website/src/content/docs/docs/libraries/azure-resource-manager/reference/`
- Build also regenerates `generated-defs/` and `README.md` — these are outside doc allowed paths
