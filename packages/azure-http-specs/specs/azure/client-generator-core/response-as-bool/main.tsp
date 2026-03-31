import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using global.Azure.ClientGenerator.Core;
using Spector;

@doc("Test decorator @responseAsBool for HEAD operations.")
@scenarioService("/azure/client-generator-core/response-as-bool")
@global.Azure.ClientGenerator.Core.clientNamespace(
  "azure.clientgenerator.core.responseasbool",
  "java"
)
namespace _Specs_.Azure.ClientGenerator.Core.ResponseAsBool;

@scenario
@scenarioDoc("""
  Test a HEAD operation decorated with @responseAsBool that returns true for a resource that exists.
  The HEAD request should return 204 (No Content) and the client method should return `true`.
  
  Expected request: HEAD /azure/client-generator-core/response-as-bool/exists
  Expected response: 204
  Expected client method return value: true
  """)
@route("/exists")
@head
@responseAsBool
op exists(): void;

@scenario
@scenarioDoc("""
  Test a HEAD operation decorated with @responseAsBool that returns false for a resource that does not exist.
  The HEAD request should return 404 (Not Found) and the client method should return `false` instead of raising an error.
  
  Expected request: HEAD /azure/client-generator-core/response-as-bool/doesNotExist
  Expected response: 404
  Expected client method return value: false
  """)
@route("/doesNotExist")
@head
@responseAsBool
op doesNotExist(): void;
