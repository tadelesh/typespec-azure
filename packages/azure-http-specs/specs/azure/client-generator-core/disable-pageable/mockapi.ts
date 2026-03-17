import { json, passOnSuccess, ScenarioMockApi } from "@typespec/spec-api";

export const Scenarios: Record<string, ScenarioMockApi> = {};

Scenarios.Azure_ClientGenerator_Core_DisablePageable_listItems = passOnSuccess({
  uri: "/azure/client-generator-core/disable-pageable/items",
  method: "get",
  request: {},
  response: {
    status: 200,
    body: json({
      items: [
        { id: "1", name: "item1" },
        { id: "2", name: "item2" },
      ],
    }),
  },
  kind: "MockApiDefinition",
});
