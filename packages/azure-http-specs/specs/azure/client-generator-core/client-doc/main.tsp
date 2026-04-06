import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using global.Azure.ClientGenerator.Core;
using Spector;

@doc("Test for @clientDoc decorator.")
@scenarioService("/azure/client-generator-core/client-doc")
namespace _Specs_.Azure.ClientGenerator.Core.ClientDoc;

@doc("Service documentation for the model.")
@clientDoc(
  "Client-specific documentation that replaces the service doc.",
  DocumentationMode.replace
)
model ReplaceModel {
  @doc("Service doc for the property.")
  @clientDoc("Client doc replacing the property description.", DocumentationMode.replace)
  name: string;
}

@doc("Service documentation for the model.")
@clientDoc(" Additional client-specific note appended.", DocumentationMode.append)
model AppendModel {
  name: string;
}

@route("/replace")
@scenario
@scenarioDoc("""
  Test that @clientDoc with replace mode generates the replacement documentation.
  Expected response body:
  ```json
  { "name": "sample" }
  ```
  """)
namespace Replace {
  @route("/get")
  @get
  op getReplaceModel(): ReplaceModel;
}

@route("/append")
@scenario
@scenarioDoc("""
  Test that @clientDoc with append mode generates the appended documentation.
  Expected response body:
  ```json
  { "name": "sample" }
  ```
  """)
namespace Append {
  @route("/get")
  @get
  op getAppendModel(): AppendModel;
}
