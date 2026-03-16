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
  Test that a HEAD operation decorated with @responseAsBool returns true for a 200 response.
  
  Expected path parameter:
  id: "existing"
  
  Expected response: 200 (client should return true)
  """)
@responseAsBool
@head
@route("/exists/{id}")
op exists(@path id: string): {
  @statusCode code: 200 | 404;
};

@scenario
@scenarioDoc("""
  Test that a HEAD operation decorated with @responseAsBool returns false for a 404 response.
  
  Expected path parameter:
  id: "non-existing"
  
  Expected response: 404 (client should return false, not throw an error)
  """)
@responseAsBool
@head
@route("/not-exists/{id}")
op notExists(@path id: string): {
  @statusCode code: 200 | 404;
};
