import { json, MockApiDefinition, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

function createMockApiDefinition(route: string): MockApiDefinition {
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

Scenarios.Azure_ClientGenerator_Core_Scope_AllLanguages = passOnSuccess([
  createMockApiDefinition("allLanguages/get"),
]);

Scenarios.Azure_ClientGenerator_Core_Scope_ScopedToSpecificLanguages = passOnSuccess([
  createMockApiDefinition("scopedToSpecificLanguages/get"),
]);

Scenarios.Azure_ClientGenerator_Core_Scope_ExcludedFromSpecificLanguages = passOnSuccess([
  createMockApiDefinition("excludedFromSpecificLanguages/get"),
]);
