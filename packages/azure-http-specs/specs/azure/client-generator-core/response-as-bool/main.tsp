import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
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
  Test that a HEAD operation decorated with @responseAsBool returns true for 2xx responses.
  Expected request: HEAD /azure/client-generator-core/response-as-bool/exists
  Expected response status code: 200
  Expected client return value: true
  """)
@route("/exists")
@head
@global.Azure.ClientGenerator.Core.responseAsBool
op exists(): OkResponse;

@scenario
@scenarioDoc("""
  Test that a HEAD operation decorated with @responseAsBool returns false for 404 responses.
  Expected request: HEAD /azure/client-generator-core/response-as-bool/doesNotExist
  Expected response status code: 404
  Expected client return value: false (should not throw an error)
  """)
@route("/doesNotExist")
@head
@global.Azure.ClientGenerator.Core.responseAsBool
op doesNotExist(): OkResponse;
