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
  Test HEAD operation with @responseAsBool decorator when resource exists.
  The HEAD operation should return true for a 200 response.
  Expected response status: 200
  """)
@route("/exists")
@head
@responseAsBool
op exists(): void;

@scenario
@scenarioDoc("""
  Test HEAD operation with @responseAsBool decorator when resource does not exist.
  The HEAD operation should return false for a 404 response.
  Expected response status: 404
  """)
@route("/notExists")
@head
@responseAsBool
op notExists(): void;
