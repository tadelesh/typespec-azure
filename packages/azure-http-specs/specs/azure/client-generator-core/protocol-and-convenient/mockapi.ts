import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_ProtocolAndConvenient_bothMethods = passOnSuccess({
  uri: "/azure/client-generator-core/protocol-and-convenient/both",
  method: "get",
  request: {},
  response: {
    status: 200,
    body: json({ name: "both" }),
  },
  kind: "MockApiDefinition",
});

Scenarios.Azure_ClientGenerator_Core_ProtocolAndConvenient_protocolOnly = passOnSuccess({
  uri: "/azure/client-generator-core/protocol-and-convenient/protocol-only",
  method: "get",
  request: {},
  response: {
    status: 200,
    body: json({ name: "protocol-only" }),
  },
  kind: "MockApiDefinition",
});

Scenarios.Azure_ClientGenerator_Core_ProtocolAndConvenient_convenientOnly = passOnSuccess({
  uri: "/azure/client-generator-core/protocol-and-convenient/convenient-only",
  method: "get",
  request: {},
  response: {
    status: 200,
    body: json({ name: "convenient-only" }),
  },
  kind: "MockApiDefinition",
});
