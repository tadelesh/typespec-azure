import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Spector;
using Azure.ClientGenerator.Core;

@doc("Test for @clientDoc decorator.")
@scenarioService("/azure/client-generator-core/client-doc")
@global.Azure.ClientGenerator.Core.clientNamespace("azure.clientgenerator.core.clientdoc", "java")
@global.Azure.ClientGenerator.Core.clientNamespace(
  "specs.azure.clientgenerator.core.clientdoc",
  "python"
)
namespace _Specs_.Azure.ClientGenerator.Core.ClientDoc;

@doc("A widget model.")
@global.Azure.ClientGenerator.Core.clientDoc(
  "A widget model with SDK-specific documentation that replaces the original.",
  global.Azure.ClientGenerator.Core.DocumentationMode.replace
)
model Widget {
  @doc("The widget id.")
  id: string;

  @doc("The widget name.")
  @global.Azure.ClientGenerator.Core.clientDoc(
    " This property is required for creation.",
    global.Azure.ClientGenerator.Core.DocumentationMode.append
  )
  name: string;
}

@scenario
@scenarioDoc("""
  Test for @clientDoc decorator on a model with replaced and appended documentation.
  The Widget model should have its documentation replaced, and the 'name' property
  should have documentation appended.
  
  Expected request: GET /azure/client-generator-core/client-doc/widget
  Expected response body:
  ```json
  {
    "id": "1",
    "name": "widget1"
  }
  ```
  """)
@route("/widget")
@get
op getWidget(): Widget;
