import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_Scope_allLanguages = passOnSuccess({
  uri: "/azure/client-generator-core/scope/allLanguages",
  method: "get",
  request: {
    query: {
      name: "all",
    },
  },
  response: {
    status: 200,
    body: json({ name: "all" }),
  },
  kind: "MockApiDefinition",
});

Scenarios.Azure_ClientGenerator_Core_Scope_excludeCsharp = passOnSuccess({
  uri: "/azure/client-generator-core/scope/excludeCsharp",
  method: "get",
  request: {
    query: {
      name: "excluded",
    },
  },
  response: {
    status: 200,
    body: json({ name: "excluded" }),
  },
  kind: "MockApiDefinition",
});
