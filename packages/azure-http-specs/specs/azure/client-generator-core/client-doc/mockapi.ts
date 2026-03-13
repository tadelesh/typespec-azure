import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_ClientDoc_getWidget = passOnSuccess({
  uri: "/azure/client-generator-core/client-doc/widget",
  method: "get",
  request: {},
  response: {
    status: 200,
    body: json({ id: "1", name: "widget1" }),
  },
  kind: "MockApiDefinition",
});
