import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_ClientDoc_Replace = passOnSuccess([
  {
    uri: "/azure/client-generator-core/client-doc/replace/get",
    method: "get",
    request: {},
    response: {
      status: 200,
      body: json({ name: "sample" }),
    },
    kind: "MockApiDefinition",
  },
]);

Scenarios.Azure_ClientGenerator_Core_ClientDoc_Append = passOnSuccess([
  {
    uri: "/azure/client-generator-core/client-doc/append/get",
    method: "get",
    request: {},
    response: {
      status: 200,
      body: json({ name: "sample" }),
    },
    kind: "MockApiDefinition",
  },
]);
