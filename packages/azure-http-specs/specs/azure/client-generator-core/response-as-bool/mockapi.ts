import { passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

// Test @responseAsBool with 200 response - should return true
Scenarios.Azure_ClientGenerator_Core_ResponseAsBool_exists = passOnSuccess({
  uri: "/azure/client-generator-core/response-as-bool/exists/existing",
  method: "head",
  request: {},
  response: {
    status: 200,
  },
  kind: "MockApiDefinition",
});

// Test @responseAsBool with 404 response - should return false (not throw error)
Scenarios.Azure_ClientGenerator_Core_ResponseAsBool_notExists = passOnSuccess({
  uri: "/azure/client-generator-core/response-as-bool/not-exists/non-existing",
  method: "head",
  request: {},
  response: {
    status: 404,
  },
  kind: "MockApiDefinition",
});
