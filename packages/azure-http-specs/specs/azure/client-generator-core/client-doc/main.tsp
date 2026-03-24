import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Spector;
using Azure.ClientGenerator.Core;

@doc("Test for @clientDoc decorator.")
@scenarioService("/azure/client-generator-core/client-doc")
@global.Azure.ClientGenerator.Core.clientNamespace("azure.clientgenerator.core.clientdoc", "java")
namespace _Specs_.Azure.ClientGenerator.Core.ClientDoc;

@doc("Original documentation for Widget.")
@global.Azure.ClientGenerator.Core.clientDoc(
  "Replaced documentation for Widget.",
  global.Azure.ClientGenerator.Core.DocumentationMode.replace
)
model Widget {
  @doc("Original name documentation.")
  @global.Azure.ClientGenerator.Core.clientDoc(
    "Replaced name documentation.",
    global.Azure.ClientGenerator.Core.DocumentationMode.replace
  )
  name: string;

  @doc("Original color documentation.")
  @global.Azure.ClientGenerator.Core.clientDoc(
    " Additional color details appended.",
    global.Azure.ClientGenerator.Core.DocumentationMode.append
  )
  color: string;
}

@scenario
@scenarioDoc("""
  Test that @clientDoc with DocumentationMode.replace replaces the original documentation,
  and @clientDoc with DocumentationMode.append appends to the original documentation.
  
  Expected request:
  - GET /azure/client-generator-core/client-doc/widget?name=sample
  
  Expected response body:
  ```json
  { "name": "sample", "color": "blue" }
  ```
  """)
@route("/widget")
@get
op getWidget(@query name: string): Widget;
