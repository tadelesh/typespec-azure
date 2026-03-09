import { json, MockApiDefinition, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

function createMockApiDefinition(route: string): MockApiDefinition {
  return {
    uri: `/azure/client-generator-core/convenient-api/${route}`,
    method: "get",
    request: {
      query: {
        name: "test",
      },
    },
    response: {
      status: 200,
      body: json({ name: "test" }),
    },
    kind: "MockApiDefinition",
  };
}

Scenarios.Azure_ClientGenerator_Core_ConvenientApi_protocolOnly = passOnSuccess(
  createMockApiDefinition("protocol-only"),
);

Scenarios.Azure_ClientGenerator_Core_ConvenientApi_convenientOnly = passOnSuccess(
  createMockApiDefinition("convenient-only"),
);

Scenarios.Azure_ClientGenerator_Core_ConvenientApi_InterfaceLevel = passOnSuccess([
  createMockApiDefinition("interface-level/convenient-only"),
  createMockApiDefinition("interface-level/both"),
]);
