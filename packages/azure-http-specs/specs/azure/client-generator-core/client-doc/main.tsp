import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Spector;

@doc("Test decorator @clientDoc.")
@scenarioService("/azure/client-generator-core/client-doc")
@global.Azure.ClientGenerator.Core.clientNamespace("azure.clientgenerator.core.clientdoc", "java")
namespace _Specs_.Azure.ClientGenerator.Core.ClientDoc;

@doc("A geometric shape.")
@global.Azure.ClientGenerator.Core.clientDoc(
  "Represents a geometric shape with specific dimensions. Use this model to define shape properties for rendering.",
  global.Azure.ClientGenerator.Core.DocumentationMode.replace
)
model Shape {
  @doc("The shape name.")
  name: string;

  @doc("Number of sides.")
  @global.Azure.ClientGenerator.Core.clientDoc(
    "The total number of sides this shape has. For example, a triangle has 3 sides.",
    global.Azure.ClientGenerator.Core.DocumentationMode.replace
  )
  sides: int32;
}

@scenario
@scenarioDoc("""
  Test that the @clientDoc decorator overrides documentation in generated code.
  The Shape model documentation should be replaced with custom text.
  
  Expected response body:
  ```json
  {
    "name": "triangle",
    "sides": 3
  }
  ```
  """)
@route("/shape")
@get
op getShape(): Shape;
