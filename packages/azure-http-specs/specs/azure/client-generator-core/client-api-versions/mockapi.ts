import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_ClientApiVersions_getWidget = passOnSuccess([
  {
    uri: "/azure/client-generator-core/client-api-versions/widget",
    method: "get",
    request: {
      query: {
        "api-version": "2025-01-01",
      },
    },
    response: {
      status: 200,
      body: json({
        id: "widget-1",
        name: "Sample Widget",
      }),
    },
    kind: "MockApiDefinition",
  },
]);
