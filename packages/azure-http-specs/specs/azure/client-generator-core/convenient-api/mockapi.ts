import { json, MockApiDefinition, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

function createMockApiDefinition(route: string): MockApiDefinition {
  return {
    uri: `/azure/client-generator-core/convenient-api/${route}`,
    method: "get",
    request: {
      query: {
        name: "sample",
      },
    },
    response: {
      status: 200,
      body: json({ name: "sample" }),
    },
    kind: "MockApiDefinition",
  };
}

Scenarios.Azure_ClientGenerator_Core_ConvenientApi_ProtocolOnly = passOnSuccess([
  createMockApiDefinition("protocolOnly/get"),
]);

Scenarios.Azure_ClientGenerator_Core_ConvenientApi_ConvenientOnly = passOnSuccess([
  createMockApiDefinition("convenientOnly/get"),
]);

Scenarios.Azure_ClientGenerator_Core_ConvenientApi_Both = passOnSuccess([
  createMockApiDefinition("both/get"),
]);
