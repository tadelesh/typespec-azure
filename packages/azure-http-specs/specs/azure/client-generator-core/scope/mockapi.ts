import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

// Test model retrieval
Scenarios.Azure_ClientGenerator_Core_Scope_getModel = passOnSuccess({
  uri: "/azure/client-generator-core/scope/model",
  method: "get",
  request: {},
  response: {
    status: 200,
    body: json({
      name: "test",
    }),
  },
  kind: "MockApiDefinition",
});

// Test operation that is excluded from C# via @scope("!csharp")
Scenarios.Azure_ClientGenerator_Core_Scope_allLanguages = passOnSuccess({
  uri: "/azure/client-generator-core/scope/all-languages",
  method: "get",
  request: {},
  response: {
    status: 204,
  },
  kind: "MockApiDefinition",
});
