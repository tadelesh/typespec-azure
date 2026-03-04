import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_Scope_getAllLanguages = passOnSuccess({
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
    body: json({ name: "python-only" }),
  },
  kind: "MockApiDefinition",
});

Scenarios.Azure_ClientGenerator_Core_Scope_excludeJava = passOnSuccess({
  uri: "/azure/client-generator-core/scope/not-java",
  method: "get",
  request: {},
  response: {
    status: 200,
    body: json({ name: "not-java" }),
  },
  kind: "MockApiDefinition",
});
