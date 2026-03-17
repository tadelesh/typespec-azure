import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Spector;

@doc("Test decorator @markAsPageable from Legacy namespace.")
@scenarioService("/azure/client-generator-core/mark-as-pageable")
@global.Azure.ClientGenerator.Core.clientNamespace(
  "azure.clientgenerator.core.markaspageable",
  "java"
)
namespace _Specs_.Azure.ClientGenerator.Core.MarkAsPageable;

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
  Test that a regular GET operation decorated with @markAsPageable is treated as a pageable operation.
  The response model has @pageItems on the items property. The generated client should return
  a paged iterator of Item objects.
  
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
@global.Azure.ClientGenerator.Core.Legacy.markAsPageable
@route("/items")
@get
op listItems(): ItemListResult;
