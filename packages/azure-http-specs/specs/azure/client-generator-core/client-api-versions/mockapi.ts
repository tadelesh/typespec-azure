import { passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_ClientApiVersions_test = passOnSuccess({
  uri: "/azure/client-generator-core/client-api-versions/test",
  method: "get",
  request: {
    query: {
      "api-version": "2024-06-01",
    },
  },
  response: {
    status: 204,
  },
  kind: "MockApiDefinition",
});
