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

model Resource {
  @doc("The resource ID.")
  id: string;

  @doc("The resource name.")
  name: string;
}

@scenario
@scenarioDoc("""
  Test that a HEAD operation decorated with @responseAsBool returns a boolean.
  A 2xx response should map to true, and a 404 response should map to false.
  
  For the 'exists' case:
  Expected status code: 204
  Expected SDK return: true
  
  For the 'notFound' case:
  Expected status code: 404
  Expected SDK return: false
  """)
namespace Exists {
  @global.Azure.ClientGenerator.Core.responseAsBool
  @route("/resources/{resourceId}")
  @head
  op checkExists(@path resourceId: string): void;
}
