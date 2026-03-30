import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using global.Azure.ClientGenerator.Core;
using Spector;

@doc("Test decorator @responseAsBool on HEAD operations.")
@scenarioService("/azure/client-generator-core/response-as-bool")
namespace _Specs_.Azure.ClientGenerator.Core.ResponseAsBool;

model Resource {
  id: string;
  name: string;
}

@scenario
@scenarioDoc("""
  Test that a HEAD operation decorated with @responseAsBool returns true for a 2xx response.
  Send a HEAD request to check if a resource exists. The server returns 200 for an existing resource.
  Expected response status: 200
  Expected client return value: true
  """)
@route("/resources/existing")
@head
@responseAsBool
op exists(): void;

@scenario
@scenarioDoc("""
  Test that a HEAD operation decorated with @responseAsBool returns false for a 404 response.
  Send a HEAD request to check if a resource exists. The server returns 404 for a missing resource.
  Expected response status: 404
  Expected client return value: false
  """)
@route("/resources/missing")
@head
@responseAsBool
op notExists(): void;
