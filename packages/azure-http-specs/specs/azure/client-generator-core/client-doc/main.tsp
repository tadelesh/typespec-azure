import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using global.Azure.ClientGenerator.Core;
using Spector;

@doc("Test decorator @clientDoc.")
@scenarioService("/azure/client-generator-core/client-doc")
@global.Azure.ClientGenerator.Core.clientNamespace("azure.clientgenerator.core.clientdoc", "java")
namespace _Specs_.Azure.ClientGenerator.Core.ClientDoc;

@doc("This is the original model documentation.")
@clientDoc(
  "This is the client-specific documentation that replaces the original.",
  DocumentationMode.replace
)
model ReplaceModel {
  name: string;
}

@doc("This is the original model documentation.")
@clientDoc(" This additional note is for client libraries only.", DocumentationMode.append)
model AppendModel {
  name: string;
}

@scenario
@scenarioDoc("""
  Test model with replaced documentation using `@clientDoc` with `DocumentationMode.replace`.
  The generated SDK model should have the client-specific documentation instead of the original.
  Expected response body:
  ```json
  {
    "name": "sample"
  }
  ```
  """)
@route("/replaceDoc")
@get
op getReplaceDoc(): ReplaceModel;

@scenario
@scenarioDoc("""
  Test model with appended documentation using `@clientDoc` with `DocumentationMode.append`.
  The generated SDK model should have both the original and client-specific documentation.
  Expected response body:
  ```json
  {
    "name": "sample"
  }
  ```
  """)
@route("/appendDoc")
@get
op getAppendDoc(): AppendModel;
