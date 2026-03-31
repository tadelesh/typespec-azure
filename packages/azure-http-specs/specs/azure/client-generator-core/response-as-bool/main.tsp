import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Azure.ClientGenerator.Core;
using Spector;

@doc("Test for the @responseAsBool decorator.")
@scenarioService("/azure/client-generator-core/response-as-bool")
namespace _Specs_.Azure.ClientGenerator.Core.ResponseAsBool;

@doc("A simple resource model.")
model Resource {
  name: string;
}

@route("/exists")
@scenario
@scenarioDoc("""
  This scenario tests a HEAD operation decorated with `@responseAsBool`.
  The generated client method should return `bool` instead of a raw response.
  - A 200 response should return `true`.
  - A 404 response should return `false`.
  
  Test case 1: Resource exists (returns true)
  Expected path parameter: name="existing"
  Expected response: 200 (method returns true)
  
  Test case 2: Resource does not exist (returns false)
  Expected path parameter: name="missing"
  Expected response: 404 (method returns false, no error raised)
  """)
namespace Exists {
  @global.Azure.ClientGenerator.Core.responseAsBool
  @route("/{name}")
  @head
  op checkExists(@path name: string): void;
}
