import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Azure.ClientGenerator.Core;
using Spector;

@doc("Test for @responseAsBool decorator.")
@scenarioService("/azure/client-generator-core/response-as-bool")
namespace _Specs_.Azure.ClientGenerator.Core.ResponseAsBool;

@scenario
@scenarioDoc("""
  This scenario tests a HEAD operation decorated with @responseAsBool that should return true for existing resources.
  The operation should return `true` for a 200 response and `false` for a 404 response.
  Expected request: HEAD /azure/client-generator-core/response-as-bool/exists
  Expected response: 200 (returns true)
  """)
@global.Azure.ClientGenerator.Core.responseAsBool
@head
@route("/exists")
op exists(@query name: string): void;

@scenario
@scenarioDoc("""
  This scenario tests a HEAD operation decorated with @responseAsBool that should return false for non-existing resources.
  Expected request: HEAD /azure/client-generator-core/response-as-bool/notExists
  Expected response: 404 (returns false, not an error)
  """)
@global.Azure.ClientGenerator.Core.responseAsBool
@head
@route("/notExists")
op notExists(@query name: string): void;
