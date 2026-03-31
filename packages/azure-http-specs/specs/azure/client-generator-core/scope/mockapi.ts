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

Scenarios.Azure_ClientGenerator_Core_Scope_IncludedForAll = passOnSuccess([
  createMockApiDefinition("included/all"),
]);

Scenarios.Azure_ClientGenerator_Core_Scope_LanguageSpecific = passOnSuccess([
  createMockApiDefinition("excluded/csharpOnly"),
  createMockApiDefinition("excluded/excludeCsharp"),
]);
