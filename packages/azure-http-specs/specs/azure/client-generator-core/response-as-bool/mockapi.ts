import { passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_ResponseAsBool_Exists = passOnSuccess([
  {
    uri: "/azure/client-generator-core/response-as-bool/resources/existing-resource",
    method: "head",
    request: {},
    response: {
      status: 204,
    },
    kind: "MockApiDefinition",
  },
  {
    uri: "/azure/client-generator-core/response-as-bool/resources/non-existing-resource",
    method: "head",
    request: {},
    response: {
      status: 404,
    },
    kind: "MockApiDefinition",
  },
]);
