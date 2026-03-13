import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Spector;
using Azure.ClientGenerator.Core;

@doc("Test for @scope decorator.")
@scenarioService("/azure/client-generator-core/scope")
@global.Azure.ClientGenerator.Core.clientNamespace("azure.clientgenerator.core.scope", "java")
@global.Azure.ClientGenerator.Core.clientNamespace(
  "specs.azure.clientgenerator.core.scope",
  "python"
)
namespace _Specs_.Azure.ClientGenerator.Core.Scope;

model Widget {
  @doc("The id of the widget.")
  id: string;

  @doc("The name of the widget.")
  name: string;
}

@scenario
@scenarioDoc("""
  Test for an operation that is available in all languages (no scope restriction).
  
  Expected request: GET /azure/client-generator-core/scope/all-languages
  Expected response body:
  ```json
  {
    "id": "1",
    "name": "widget1"
  }
  ```
  """)
@route("/all-languages")
@get
op getAllLanguages(): Widget;

@scenario
@scenarioDoc("""
  Test for an operation scoped to specific languages using `@scope("python, java")`.
  This operation should only be generated for Python and Java emitters.
  
  Expected request: GET /azure/client-generator-core/scope/python-java-only
  Expected response body:
  ```json
  {
    "id": "2",
    "name": "widget2"
  }
  ```
  """)
@global.Azure.ClientGenerator.Core.scope("python, java")
@route("/python-java-only")
@get
op getPythonJavaOnly(): Widget;
