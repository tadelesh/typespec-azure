import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using global.Azure.ClientGenerator.Core;
using Spector;

@doc("Test decorator @responseAsBool.")
@scenarioService("/azure/client-generator-core/response-as-bool")
@global.Azure.ClientGenerator.Core.clientNamespace(
  "azure.clientgenerator.core.responseasbool",
  "java"
)
namespace _Specs_.Azure.ClientGenerator.Core.ResponseAsBool;

@scenario
@scenarioDoc("""
  Test that a HEAD operation decorated with @responseAsBool returns true when the resource exists (200)
  and false when it does not (404).
  
  Expected behavior for exists call:
  - HEAD request to /azure/client-generator-core/response-as-bool/exists
  - Response status: 200
  - Client method returns: true
  
  Expected behavior for not exists call:
  - HEAD request to /azure/client-generator-core/response-as-bool/notExists
  - Response status: 404
  - Client method returns: false
  """)
namespace Exists {
  @head
  @route("/exists")
  @responseAsBool
  op exists(): OkResponse | NotFoundResponse;

  @head
  @route("/notExists")
  @responseAsBool
  op notExists(): OkResponse | NotFoundResponse;
}
