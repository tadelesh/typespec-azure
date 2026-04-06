import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_Scope_AllLanguages = passOnSuccess([
  {
    uri: "/azure/client-generator-core/scope/allLanguages/get",
    method: "get",
    request: {},
    response: {
      status: 200,
      body: json({ id: "1", name: "widget1" }),
    },
    kind: "MockApiDefinition",
  },
]);

Scenarios.Azure_ClientGenerator_Core_Scope_PythonOnly = passOnSuccess([
  {
    uri: "/azure/client-generator-core/scope/pythonOnly/get",
    method: "get",
    request: {},
    response: {
      status: 200,
      body: json({ id: "2", name: "python-widget" }),
    },
    kind: "MockApiDefinition",
  },
]);

Scenarios.Azure_ClientGenerator_Core_Scope_Excluded = passOnSuccess([
  {
    uri: "/azure/client-generator-core/scope/excluded/get",
    method: "get",
    request: {},
    response: {
      status: 200,
      body: json({ id: "3", name: "excluded-widget" }),
    },
    kind: "MockApiDefinition",
  },
]);
