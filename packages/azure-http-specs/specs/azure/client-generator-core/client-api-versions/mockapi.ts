import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_ClientApiVersions_getResource = passOnSuccess({
  uri: "/azure/client-generator-core/client-api-versions/resource",
  method: "get",
  request: {},
  response: {
    status: 200,
    body: json({ name: "sample" }),
  },
  kind: "MockApiDefinition",
});
