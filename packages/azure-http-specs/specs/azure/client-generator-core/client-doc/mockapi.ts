import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

const sampleBody = { name: "sample" };

Scenarios.Azure_ClientGenerator_Core_ClientDoc_Replace = passOnSuccess([
  {
    uri: "/azure/client-generator-core/client-doc/replace/model",
    method: "post",
    request: {
      body: json(sampleBody),
    },
    response: {
      status: 200,
      body: json(sampleBody),
    },
    kind: "MockApiDefinition",
  },
]);

Scenarios.Azure_ClientGenerator_Core_ClientDoc_Append = passOnSuccess([
  {
    uri: "/azure/client-generator-core/client-doc/append/model",
    method: "post",
    request: {
      body: json(sampleBody),
    },
    response: {
      status: 200,
      body: json(sampleBody),
    },
    kind: "MockApiDefinition",
  },
]);
