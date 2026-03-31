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
  Test that a HEAD operation decorated with `@responseAsBool` returns true when the resource exists (2xx response).
  Expected request:
  ```
  HEAD /azure/client-generator-core/response-as-bool/exists
  ```
  Expected behavior:
  - Service returns 204 No Content
  - Client method returns `true`
  """)
@route("/exists")
@head
@responseAsBool
op exists(): void;

@scenario
@scenarioDoc("""
  Test that a HEAD operation decorated with `@responseAsBool` returns false when the resource does not exist (404 response).
  Expected request:
  ```
  HEAD /azure/client-generator-core/response-as-bool/doesNotExist
  ```
  Expected behavior:
  - Service returns 404 Not Found
  - Client method returns `false` (does NOT raise an error)
  """)
@route("/doesNotExist")
@head
@responseAsBool
op doesNotExist(): void;
