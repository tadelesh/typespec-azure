---
title: arm-post-operation-response-codes
---

```text title=- Full name-
@azure-tools/typespec-azure-resource-manager/arm-post-operation-response-codes
```

## Synchronous

Synchronous post operations should have one of the following combinations of responses - 200 and default, or 204 and default. They must have no other responses.

#### ❌ Incorrect

```tsp
@armResourceOperations
interface Employees {
  @armResourceAction(Employee)
  @post
  deactivate(...ApiVersionParameter): {
    @statusCode _: 201;
    result: boolean;
  };
}
```

#### ✅ Correct

```tsp
@armResourceOperations
interface Employees {
  deactivate is ArmResourceActionSync<Employee, void, void>;
}
```

## Asynchronous

Long-running (LRO) post operations should have 202 and default responses. The must also have a 200 response only if the final response is intended to have a schema. They must have no other responses. The 202 response must not have a response schema specified.

#### ❌ Incorrect

```tsp
@armResourceOperations
interface Employees {
  @armResourceAction(Employee)
  @post
  deactivate(...ApiVersionParameter): {
    @statusCode _: 200;
    result: boolean;
  } | {
    @statusCode _: 201;
  };
}
```

#### ✅ Correct

```tsp
@armResourceOperations
interface Employees {
  deactivate is ArmResourceActionAsync<Employee, void, void>;
}
```
