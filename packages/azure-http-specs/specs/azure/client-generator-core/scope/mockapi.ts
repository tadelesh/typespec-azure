import { json, MockApiDefinition, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

function createGetMockApi(route: string): MockApiDefinition {
  return {
    uri: `/azure/client-generator-core/scope/${route}`,
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

Scenarios.Azure_ClientGenerator_Core_Scope_allLanguages = passOnSuccess(
  createGetMockApi("allLanguages"),
);

Scenarios.Azure_ClientGenerator_Core_Scope_excludeJava = passOnSuccess(
  createGetMockApi("excludeJava"),
);

Scenarios.Azure_ClientGenerator_Core_Scope_scopedProperties = passOnSuccess({
  uri: "/azure/client-generator-core/scope/scopedProperties",
  method: "put",
  request: {
    body: json({ name: "sample" }),
  },
  response: {
    status: 200,
    body: json({ name: "sample" }),
  },
  kind: "MockApiDefinition",
});
