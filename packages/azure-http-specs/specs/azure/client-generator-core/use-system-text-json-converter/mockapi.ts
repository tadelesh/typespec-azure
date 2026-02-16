import { json, MockApiDefinition, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

const requestBody = {
  value: "test-value",
  timestamp: "2024-01-01T00:00:00Z",
};

Scenarios.Azure_ClientGenerator_Core_UseSystemTextJsonConverter_withConverter = passOnSuccess({
  uri: "/azure/client-generator-core/use-system-text-json-converter/with-converter",
  method: "post",
  request: {
    body: requestBody,
  },
  response: {
    status: 200,
    body: json(requestBody),
  },
  kind: "MockApiDefinition",
});

Scenarios.Azure_ClientGenerator_Core_UseSystemTextJsonConverter_withoutConverter = passOnSuccess({
  uri: "/azure/client-generator-core/use-system-text-json-converter/without-converter",
  method: "post",
  request: {
    body: requestBody,
  },
  response: {
    status: 200,
    body: json(requestBody),
  },
  kind: "MockApiDefinition",
});
