---
title: arm-post-operation-response-codes
---

```text title=- Full name-
@azure-tools/typespec-azure-resource-manager/arm-post-operation-response-codes
```

## Synchronous

Synchronous post operations should have one of the following combinations of responses — 200 and default, or 204 and default. They must have no other responses.

#### ❌ Incorrect

```tsp
@armResourceOperations
interface Employees {
  move(...ApiVersionParameter): {
    @statusCode _: 200;
    result: boolean;
  };
}
```

#### ✅ Correct

```tsp
@armResourceOperations
interface Employees {
  move is ArmResourceActionSync<Employee, MoveRequest, MoveResponse>;
}
```

## Asynchronous

Long-running (LRO) post operations should have 202 and default responses. They must also have a 200 response only if the final response is intended to have a schema. They must have no other responses. The 202 response must not have a response schema specified.

#### ❌ Incorrect

```tsp
@armResourceOperations
interface Employees {
  move is ArmResourceActionAsync<Employee, MoveRequest, ArmAcceptedLroResponse>;
}
```

#### ✅ Correct

```tsp
@armResourceOperations
interface Employees {
  move is ArmResourceActionAsync<Employee, MoveRequest, MoveResponse>;
}
```
