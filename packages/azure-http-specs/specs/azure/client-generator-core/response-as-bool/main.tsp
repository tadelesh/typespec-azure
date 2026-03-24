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
namespace _Specs_.Azure.ClientGenerator.Core.ResponseAsBool;

@scenario
@scenarioDoc("""
  Test that a HEAD operation decorated with @responseAsBool returns a boolean.
  When the resource exists, the service returns 204 and the client should return true.
  
  Expected request:
  - HEAD /azure/client-generator-core/response-as-bool/exists
  
  Expected response:
  - Status code: 204
  - Client return value: true
  """)
@route("/exists")
@head
@global.Azure.ClientGenerator.Core.responseAsBool
op exists(): void;

@scenario
@scenarioDoc("""
  Test that a HEAD operation decorated with @responseAsBool returns false for 404.
  When the resource does not exist, the service returns 404 and the client should return false.
  
  Expected request:
  - HEAD /azure/client-generator-core/response-as-bool/doesNotExist
  
  Expected response:
  - Status code: 404
  - Client return value: false (no error raised)
  """)
@route("/doesNotExist")
@head
@global.Azure.ClientGenerator.Core.responseAsBool
op doesNotExist(): void;
