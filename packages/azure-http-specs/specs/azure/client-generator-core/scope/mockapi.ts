import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

function createScopeResponse(route: string) {
  return {
    uri: `/azure/client-generator-core/scope/${route}`,
    method: "get" as const,
    request: {
      query: {
        name: "test",
      },
    },
    response: {
      status: 200,
      body: json({ name: "test" }),
    },
    kind: "MockApiDefinition" as const,
  };
}

Scenarios.Azure_ClientGenerator_Core_Scope_allLanguages = passOnSuccess(
  createScopeResponse("all-languages"),
);

Scenarios.Azure_ClientGenerator_Core_Scope_pythonOnly = passOnSuccess(
  createScopeResponse("python-only"),
);

Scenarios.Azure_ClientGenerator_Core_Scope_excludeCsharp = passOnSuccess(
  createScopeResponse("exclude-csharp"),
);
