import { passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_ResponseAsBool_HeadOperation = passOnSuccess([
  {
    uri: "/azure/client-generator-core/response-as-bool/exists/existing",
    method: "head",
    request: {},
    response: {
      status: 200,
    },
    kind: "MockApiDefinition",
  },
  {
    uri: "/azure/client-generator-core/response-as-bool/exists/non-existing",
    method: "head",
    request: {},
    response: {
      status: 404,
    },
    kind: "MockApiDefinition",
  },
]);
