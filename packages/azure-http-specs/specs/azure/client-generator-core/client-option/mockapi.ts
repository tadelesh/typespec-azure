import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_ClientOption_test = passOnSuccess({
  uri: "/azure/client-generator-core/client-option/test",
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
