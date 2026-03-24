import { json, MockApiDefinition, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

function createGetScenario(route: string): MockApiDefinition {
  return {
    uri: `/azure/client-generator-core/protocol-api/${route}`,
    method: "get",
    request: {
      query: { name: "sample" },
    },
    response: {
      status: 200,
      body: json({ name: "sample" }),
    },
    kind: "MockApiDefinition",
  };
}

Scenarios.Azure_ClientGenerator_Core_ProtocolApi_convenienceOnly = passOnSuccess(
  createGetScenario("convenienceOnly"),
);

Scenarios.Azure_ClientGenerator_Core_ProtocolApi_protocolOnly = passOnSuccess(
  createGetScenario("protocolOnly"),
);

Scenarios.Azure_ClientGenerator_Core_ProtocolApi_both = passOnSuccess(createGetScenario("both"));
