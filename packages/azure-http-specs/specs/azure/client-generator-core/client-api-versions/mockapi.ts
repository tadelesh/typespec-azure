import { passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

// Test that client can call with the latest API version
Scenarios.Azure_ClientGenerator_Core_ClientApiVersions_get = passOnSuccess({
  uri: "/azure/client-generator-core/client-api-versions/get",
  method: "get",
  request: {
    query: {
      "api-version": "2024-01-01",
    },
  },
  response: {
    status: 204,
  },
  kind: "MockApiDefinition",
});
