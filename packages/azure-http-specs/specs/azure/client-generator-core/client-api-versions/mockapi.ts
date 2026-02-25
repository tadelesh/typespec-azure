import { passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_ClientApiVersions_getOperation = passOnSuccess({
  uri: "/azure/client-generator-core/client-api-versions/operation",
  method: "get",
  request: {
    query: {
      "api-version": "2025-01-01",
    },
  },
  response: {
    status: 200,
  },
  kind: "MockApiDefinition",
});
