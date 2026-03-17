import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_ClientDoc_getShape = passOnSuccess({
  uri: "/azure/client-generator-core/client-doc/shape",
  method: "get",
  request: {},
  response: {
    status: 200,
    body: json({
      name: "triangle",
      sides: 3,
    }),
  },
  kind: "MockApiDefinition",
});
