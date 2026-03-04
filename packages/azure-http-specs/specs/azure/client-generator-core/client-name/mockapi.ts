import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_ClientName_getModel = passOnSuccess({
  uri: "/azure/client-generator-core/client-name/model",
  method: "get",
  request: {
    query: {
      originalProperty: "test",
    },
  },
  response: {
    status: 200,
    body: json({ originalProperty: "test" }),
  },
  kind: "MockApiDefinition",
});

Scenarios.Azure_ClientGenerator_Core_ClientName_originalOperation = passOnSuccess({
  uri: "/azure/client-generator-core/client-name/operation",
  method: "head",
  request: {},
  response: {
    status: 204,
  },
  kind: "MockApiDefinition",
});
