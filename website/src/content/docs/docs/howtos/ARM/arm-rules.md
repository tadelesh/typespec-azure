---
title: ARM Rules, TypeSpec Linting, and Suppression
---

ARM includes many rules on the structure of resources and the details of resource operations that ensure a consistent user experience when managing services inside Azure. TypeSpec encodes many of these rules into linting checks that occur on each compilation. If you use an IDE and install the [TypeSpec IDE Tools](../../getstarted/azure-resource-manager/step00.md#installing-ide-tools), violations of rules will show up as yellow highlights in your tsp code. If you hover over these, you will get a message indicating the issue and how to fix it in your specification. If you use the typespec command-line, violations of rules will be printed as warnings, with a description and steps to correct the issue, and a pointer to the location in the specification where the violation occurred.

In the sections below, we will discuss these rules, how they work, and, in cases where a violation is a false positive, or has a reason approved by an ARM reviewer, can be suppressed.

## ARM RPC Rules

TypeSpec has a set of linting rules that execute whenever the specification is compiled, and in the IDE as you type. Violations are highlighted inline in the spec, or emitted during compilation.

For more information, see [ARM RPC rules](https://eng.ms/docs/products/arm/api_contracts/guidelines/rpc)

### Current rules

The following table lists all rules included in the `@azure-tools/typespec-azure-resource-manager` linter. All rules are enabled at `warning` severity when using the `@azure-tools/typespec-azure-resource-manager/all` ruleset. For detailed documentation of each rule, including examples and how to fix violations, see the [linter rule reference](/docs/libraries/azure-resource-manager/reference/linter).

| Rule | Description |
| ---- | ----------- |
| `arm-common-types-version` | Specify the ARM common-types version using `@armCommonTypesVersion`. |
| `arm-custom-resource-no-key` | Validate that custom resource contains a key property. |
| `arm-custom-resource-usage-discourage` | Verify the usage of `@customAzureResource` decorator. |
| `arm-delete-operation-response-codes` | Ensure delete operations have the appropriate status codes. |
| `arm-no-record` | Don't use Record types for ARM resources. |
| `arm-post-operation-response-codes` | Ensure post operations have the appropriate status codes. |
| `arm-put-operation-response-codes` | Ensure put operations have the appropriate status codes. |
| `arm-resource-action-no-segment` | `@armResourceAction` should not be used with `@segment`. |
| `arm-resource-duplicate-property` | Warn about duplicate properties in resources. |
| `arm-resource-interface-requires-decorator` | Each resource interface must have an `@armResourceOperations` decorator. |
| `arm-resource-invalid-action-verb` | Actions must be HTTP Post or Get operations. |
| `arm-resource-invalid-envelope-property` | Check for invalid resource envelope properties. |
| `arm-resource-invalid-version-format` | Check for valid versions. |
| `arm-resource-key-invalid-chars` | Arm resource key must contain only alphanumeric characters. |
| `arm-resource-name-pattern` | The resource name parameter should be defined with a `pattern` restriction. |
| `arm-resource-operation` | Validate ARM Resource operations. |
| `arm-resource-operation-response` | PUT, GET, PATCH & LIST must return the same resource schema. |
| `arm-resource-patch` | Validate ARM PATCH operations. |
| `arm-resource-path-segment-invalid-chars` | Arm resource path segment must contain only alphanumeric characters. |
| `arm-resource-provisioning-state` | Check for properly configured `provisioningState` property. |
| `beyond-nesting-levels` | Tracked Resources must use 3 or fewer levels of nesting. |
| `empty-updateable-properties` | Should have updateable properties. |
| `improper-subscription-list-operation` | Tenant and Extension resources should not define a list by subscription operation. |
| `lro-location-header` | A 202 response should include a Location response header. |
| `missing-operations-endpoint` | Check for missing Operations interface. |
| `missing-x-ms-identifiers` | Array properties should describe their identifying properties with `x-ms-identifiers`. |
| `no-empty-model` | ARM properties with `type:object` that don't reference a model definition are not allowed. |
| `no-resource-delete-operation` | Check for resources that must have a delete operation. |
| `no-response-body` | Check that the body is empty for 202 and 204 responses, and not empty for other 2xx responses. |
| `patch-envelope` | Patch envelope properties should match the resource properties. |
| `resource-name` | Check the resource name. |
| `retry-after` | Check if `retry-after` header appears in response body. |
| `secret-prop` | Check that properties with names indicating sensitive information are marked with `@secret`. |
| `unsupported-type` | Check for unsupported ARM types. |

## Detecting and Suppressing Rule Violations at Design Time

Violations of ARM RPC rules will show up at design time as a yellow highlight over the violating type in TypeSpec, and at compile time as an emitted warning with a specific reference in the specification code (line number, position, pointer).

Here is an example of a linter warning:

```bash
Diagnostics were reported during compilation:

C:/typespec-samples/resource-manager/zerotrust/main.tsp:38:3 - warning @azure-tools/typespec-azure-resource-manager/arm-resource-operation-missing-decorator: Resource POST operation must be decorated with @armResourceAction.
> 38 |   /** Gets the Zero Trust URL for this resource */
     |   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 39 |   @post
     | ^^^^^^^
> 40 |   getZeroTrustUrl(...ResourceInstanceParameters<ZeroTrustResource>): ZeroTrustUrl | ErrorResponse;
     | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Found 1 warning.

```

To suppress the warning, you would use the `#suppress` directive on the type that violates the rule. The directive takes the fully-qualified name of the rule you are suppressing, and a reason for the suppression.

```typespec
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-operation-missing-decorator" "This is a sample suppression."
  /** Gets the MAA URL for this resource */
  @post
  getZeroTrustUrl(...ResourceInstanceParameters<ZeroTrustResource>): ZeroTrustUrl | ErrorResponse;
```

Of course, in this case, the best resolution would be to follow the advice in the linting rule, and add the `@armResourceAction` decorator.

```typespec
  @armResourceAction(ZeroTrustResource)
  /** Gets the MAA URL for this resource */
  @post
  getZeroTrustUrl(...ResourceInstanceParameters<ZeroTrustResource>): ZeroTrustUrl | ErrorResponse;
```
