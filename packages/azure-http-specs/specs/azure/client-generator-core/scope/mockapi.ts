import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_Scope_allEmitters = passOnSuccess({
  uri: "/azure/client-generator-core/scope/all",
  method: "get",
  request: {},
  response: {
    status: 200,
    body: json({ name: "all" }),
  },
  kind: "MockApiDefinition",
});

Scenarios.Azure_ClientGenerator_Core_Scope_pythonOnly = passOnSuccess({
  uri: "/azure/client-generator-core/scope/python-only",
  method: "get",
  request: {},
  response: {
    status: 200,
    body: json({ name: "python" }),
  },
  kind: "MockApiDefinition",
});

Scenarios.Azure_ClientGenerator_Core_Scope_excludeCsharp = passOnSuccess({
  uri: "/azure/client-generator-core/scope/exclude-csharp",
  method: "get",
  request: {},
  response: {
    status: 200,
    body: json({ name: "not-csharp" }),
  },
  kind: "MockApiDefinition",
});
