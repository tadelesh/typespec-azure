import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_Scope_getAllLanguages = passOnSuccess({
  uri: "/azure/client-generator-core/scope/all-languages",
  method: "get",
  request: {},
  response: {
    status: 200,
    body: json({ id: "1", name: "widget1" }),
  },
  kind: "MockApiDefinition",
});

Scenarios.Azure_ClientGenerator_Core_Scope_getPythonJavaOnly = passOnSuccess({
  uri: "/azure/client-generator-core/scope/python-java-only",
  method: "get",
  request: {},
  response: {
    status: 200,
    body: json({ id: "2", name: "widget2" }),
  },
  kind: "MockApiDefinition",
});
