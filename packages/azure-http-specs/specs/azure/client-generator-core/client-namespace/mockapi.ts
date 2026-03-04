import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_ClientNamespace_getModel = passOnSuccess({
  uri: "/azure/client-generator-core/client-namespace/model",
  method: "get",
  request: {
    query: {
      name: "test",
    },
  },
  response: {
    status: 200,
    body: json({ name: "test" }),
  },
  kind: "MockApiDefinition",
});
