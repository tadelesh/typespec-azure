import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_Scope_ScopedOperations = passOnSuccess([
  {
    uri: "/azure/client-generator-core/scope/all",
    method: "get",
    request: {
      query: {
        name: "sample",
      },
    },
    response: {
      status: 200,
      body: json({ name: "sample" }),
    },
    kind: "MockApiDefinition",
  },
  {
    uri: "/azure/client-generator-core/scope/csharpOnly",
    method: "get",
    request: {
      query: {
        name: "sample",
      },
    },
    response: {
      status: 200,
      body: json({ name: "sample" }),
    },
    kind: "MockApiDefinition",
  },
]);
