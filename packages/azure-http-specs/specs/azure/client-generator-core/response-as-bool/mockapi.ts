import { passOnCode, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_ResponseAsBool_exists = passOnSuccess({
  uri: "/azure/client-generator-core/response-as-bool/exists",
  method: "head",
  request: {},
  response: {
    status: 200,
  },
  kind: "MockApiDefinition",
});

Scenarios.Azure_ClientGenerator_Core_ResponseAsBool_doesNotExist = passOnCode(404, {
  uri: "/azure/client-generator-core/response-as-bool/doesNotExist",
  method: "head",
  request: {},
  response: {
    status: 404,
  },
  kind: "MockApiDefinition",
});
