import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using global.Azure.ClientGenerator.Core;
using Spector;

@doc("Test for @responseAsBool decorator.")
@scenarioService("/azure/client-generator-core/response-as-bool")
namespace _Specs_.Azure.ClientGenerator.Core.ResponseAsBool;

model Resource {
  id: string;
  name: string;
}

@route("/exists")
@scenario
@scenarioDoc("""
  Test that a HEAD operation decorated with @responseAsBool returns true for 2xx responses.
  Expected path parameter: id="test-resource"
  Expected response: 200 with empty body, client should return true.
  """)
namespace Exists {
  @route("/{id}")
  @head
  @responseAsBool
  op checkExists(@path id: string): void;
}

@route("/doesNotExist")
@scenario
@scenarioDoc("""
  Test that a HEAD operation decorated with @responseAsBool returns false for 404 responses.
  Expected path parameter: id="non-existent-resource"
  Expected response: 404 with empty body, client should return false (no error raised).
  """)
namespace DoesNotExist {
  @route("/{id}")
  @head
  @responseAsBool
  op checkDoesNotExist(@path id: string): void;
}
