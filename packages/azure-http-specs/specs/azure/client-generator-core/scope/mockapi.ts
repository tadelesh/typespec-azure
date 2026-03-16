import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_Scope_AllLanguages = passOnSuccess([
  {
    uri: "/azure/client-generator-core/scope/allLanguages/get",
    method: "get",
    request: {},
    response: {
      status: 200,
      body: json({ message: "all languages" }),
    },
    kind: "MockApiDefinition",
  },
]);

Scenarios.Azure_ClientGenerator_Core_Scope_JavaOnly = passOnSuccess([
  {
    uri: "/azure/client-generator-core/scope/javaOnly/get",
    method: "get",
    request: {},
    response: {
      status: 200,
      body: json({ message: "java only" }),
    },
    kind: "MockApiDefinition",
  },
]);

Scenarios.Azure_ClientGenerator_Core_Scope_ExcludeCsharp = passOnSuccess([
  {
    uri: "/azure/client-generator-core/scope/excludeCsharp/get",
    method: "get",
    request: {},
    response: {
      status: 200,
      body: json({ message: "exclude csharp" }),
    },
    kind: "MockApiDefinition",
  },
]);
