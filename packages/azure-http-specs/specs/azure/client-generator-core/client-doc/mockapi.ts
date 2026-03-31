import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_ClientDoc_getReplaceDoc = passOnSuccess({
  uri: "/azure/client-generator-core/client-doc/replaceDoc",
  method: "get",
  request: {},
  response: {
    status: 200,
    body: json({ name: "sample" }),
  },
  kind: "MockApiDefinition",
});

Scenarios.Azure_ClientGenerator_Core_ClientDoc_getAppendDoc = passOnSuccess({
  uri: "/azure/client-generator-core/client-doc/appendDoc",
  method: "get",
  request: {},
  response: {
    status: 200,
    body: json({ name: "sample" }),
  },
  kind: "MockApiDefinition",
});
