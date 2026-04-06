import { passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_ResponseAsBool_Exists = passOnSuccess([
  {
    uri: "/azure/client-generator-core/response-as-bool/exists/test-resource",
    method: "head",
    request: {},
    response: {
      status: 200,
    },
    kind: "MockApiDefinition",
  },
]);

Scenarios.Azure_ClientGenerator_Core_ResponseAsBool_DoesNotExist = passOnSuccess([
  {
    uri: "/azure/client-generator-core/response-as-bool/doesNotExist/non-existent-resource",
    method: "head",
    request: {},
    response: {
      status: 404,
    },
    kind: "MockApiDefinition",
  },
]);
