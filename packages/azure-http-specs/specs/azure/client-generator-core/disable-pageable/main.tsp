import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Spector;

@doc("Test decorator @disablePageable from Legacy namespace.")
@scenarioService("/azure/client-generator-core/disable-pageable")
@global.Azure.ClientGenerator.Core.clientNamespace(
  "azure.clientgenerator.core.disablepageable",
  "java"
)
namespace _Specs_.Azure.ClientGenerator.Core.DisablePageable;

model Item {
  @doc("The item ID.")
  id: string;

  @doc("The item name.")
  name: string;
}

model ItemListResult {
  @pageItems
  items: Item[];

  nextLink?: string;
}

@scenario
@scenarioDoc("""
  Test that a list operation decorated with @disablePageable is treated as a basic operation
  instead of a pageable one. The generated client should return the full ItemListResult model
  rather than a paged iterator of Item objects.
  
  Expected response body:
  ```json
  {
    "items": [
      { "id": "1", "name": "item1" },
      { "id": "2", "name": "item2" }
    ]
  }
  ```
  """)
@global.Azure.ClientGenerator.Core.Legacy.disablePageable
@route("/items")
@get
@list
op listItems(...Item): ItemListResult;
