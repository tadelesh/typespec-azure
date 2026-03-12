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
  This scenario tests that a HEAD operation decorated with @responseAsBool returns true for a 200 response.
  Expected response status: 200
  Expected client method return value: true
  """)
@route("/exists")
@responseAsBool
@head
op exists(): OkResponse;

@scenario
@scenarioDoc("""
  This scenario tests that a HEAD operation decorated with @responseAsBool returns false for a 404 response.
  Expected response status: 404
  Expected client method return value: false
  """)
@route("/doesNotExist")
@responseAsBool
@head
op doesNotExist(): OkResponse;
