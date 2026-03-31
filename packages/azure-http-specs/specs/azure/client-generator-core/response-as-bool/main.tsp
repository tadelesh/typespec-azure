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
  This scenario tests that a HEAD operation decorated with `@responseAsBool` returns `true`
  when the resource exists (2xx response) and `false` when it does not (404 response).
  
  Test case 1 - resource exists:
  Expected path parameter: id="exists"
  Expected response: 200 OK → method returns `true`
  
  Test case 2 - resource does not exist:
  Expected path parameter: id="notExists"
  Expected response: 404 Not Found → method returns `false`
  """)
interface HeadOperation {
  @route("/exists/{id}")
  @head
  @responseAsBool
  exists(@path id: string): void;
}
