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
  Test that a HEAD operation decorated with @responseAsBool returns a boolean.
  A 200 response should return true, and a 404 response should return false (without raising an error).
  
  For the 'exists' operation:
  - HEAD /azure/client-generator-core/response-as-bool/exists with id="existing" should return true (200).
  - HEAD /azure/client-generator-core/response-as-bool/exists with id="non-existing" should return false (404).
  """)
namespace HeadOperation {
  @global.Azure.ClientGenerator.Core.responseAsBool
  @route("/exists/{id}")
  @head
  op exists(@path id: string): void;
}
