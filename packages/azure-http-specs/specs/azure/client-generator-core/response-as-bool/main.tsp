import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using global.Azure.ClientGenerator.Core;
using Spector;

@doc("Test decorator @responseAsBool.")
@scenarioService("/azure/client-generator-core/response-as-bool")
namespace _Specs_.Azure.ClientGenerator.Core.ResponseAsBool;

@scenario
@scenarioDoc("""
  Test that a HEAD operation with @responseAsBool returns true when the resource exists.
  The server responds with 204 (No Content).
  Expected client method return value: true
  """)
@route("/exists")
@head
@responseAsBool
op exists(): void;
