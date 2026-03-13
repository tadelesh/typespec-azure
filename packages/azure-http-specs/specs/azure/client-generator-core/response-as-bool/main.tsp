import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Spector;
using Azure.ClientGenerator.Core;

@doc("Test for @responseAsBool decorator.")
@scenarioService("/azure/client-generator-core/response-as-bool")
@global.Azure.ClientGenerator.Core.clientNamespace(
  "azure.clientgenerator.core.responseasbool",
  "java"
)
@global.Azure.ClientGenerator.Core.clientNamespace(
  "specs.azure.clientgenerator.core.responseasbool",
  "python"
)
namespace _Specs_.Azure.ClientGenerator.Core.ResponseAsBool;

model Resource {
  @doc("The name of the resource.")
  name: string;
}

@scenario
@scenarioDoc("""
  Test for @responseAsBool decorator on a HEAD operation.
  When the resource exists, the operation should return true.
  
  Expected request: HEAD /azure/client-generator-core/response-as-bool/exists
  Expected response: 200 (returns true)
  """)
@global.Azure.ClientGenerator.Core.responseAsBool
@route("/exists")
@head
op exists(): OkResponse;

@scenario
@scenarioDoc("""
  Test for @responseAsBool decorator on a HEAD operation.
  When the resource does not exist, the operation should return false.
  
  Expected request: HEAD /azure/client-generator-core/response-as-bool/doesNotExist
  Expected response: 404 (returns false)
  """)
@global.Azure.ClientGenerator.Core.responseAsBool
@route("/doesNotExist")
@head
op doesNotExist(): OkResponse;
