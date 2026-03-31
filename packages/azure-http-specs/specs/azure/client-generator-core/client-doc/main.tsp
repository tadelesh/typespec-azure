import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Azure.ClientGenerator.Core;
using Spector;

@doc("Test for the @clientDoc decorator.")
@scenarioService("/azure/client-generator-core/client-doc")
namespace _Specs_.Azure.ClientGenerator.Core.ClientDoc;

@doc("Service-level documentation for the model.")
@global.Azure.ClientGenerator.Core.clientDoc(
  "Client-specific documentation that replaces the service doc.",
  global.Azure.ClientGenerator.Core.DocumentationMode.replace
)
model ReplaceModel {
  @doc("Service doc for name property.")
  @global.Azure.ClientGenerator.Core.clientDoc(
    "Client doc for name property.",
    global.Azure.ClientGenerator.Core.DocumentationMode.replace
  )
  name: string;
}

@doc("Service-level documentation for the model.")
@global.Azure.ClientGenerator.Core.clientDoc(
  " Additional client-specific notes appended.",
  global.Azure.ClientGenerator.Core.DocumentationMode.append
)
model AppendModel {
  @doc("Service doc for name property.")
  @global.Azure.ClientGenerator.Core.clientDoc(
    " Extra client-specific details.",
    global.Azure.ClientGenerator.Core.DocumentationMode.append
  )
  name: string;
}

@route("/replace")
@scenario
@scenarioDoc("""
  This scenario tests the `@clientDoc` decorator with `DocumentationMode.replace`.
  The generated model documentation should use the client-specific documentation
  instead of the service-level documentation.
  Expected request body:
  ```json
  {
    "name": "sample"
  }
  ```
  Expected response body:
  ```json
  {
    "name": "sample"
  }
  ```
  """)
namespace Replace {
  @route("/model")
  @post
  op replaceDoc(@body body: ReplaceModel): ReplaceModel;
}

@route("/append")
@scenario
@scenarioDoc("""
  This scenario tests the `@clientDoc` decorator with `DocumentationMode.append`.
  The generated model documentation should append client-specific documentation
  to the service-level documentation.
  Expected request body:
  ```json
  {
    "name": "sample"
  }
  ```
  Expected response body:
  ```json
  {
    "name": "sample"
  }
  ```
  """)
namespace Append {
  @route("/model")
  @post
  op appendDoc(@body body: AppendModel): AppendModel;
}
