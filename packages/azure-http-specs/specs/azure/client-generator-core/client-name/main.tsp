import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using global.Azure.ClientGenerator.Core;
using Spector;

@doc("Test decorator @clientName for renaming types in generated client libraries.")
@scenarioService("/azure/client-generator-core/client-name")
namespace _Specs_.Azure.ClientGenerator.Core.ClientName;

@clientName("RenamedModel")
model OriginalModel {
  @clientName("renamedProperty")
  originalProperty: string;
}

@scenario
@scenarioDoc("""
  This scenario tests that @clientName renames the model and its property in generated client code.
  The generated model should be named "RenamedModel" (not "OriginalModel").
  The property should be named "renamedProperty" (not "originalProperty").
  The serialized JSON key should still be "originalProperty".
  Expected query parameter: originalProperty="test"
  Expected response body:
  ```json
  {
    "originalProperty": "test"
  }
  ```
  """)
@route("/model")
@get
op getModel(@query originalProperty: string): OriginalModel;

@clientName("renamedOperation")
@scenario
@scenarioDoc("""
  This scenario tests that @clientName renames an operation in generated client code.
  The generated method should be named "renamedOperation" (not "originalOperation").
  Expected response status: 204
  """)
@route("/operation")
@head
op originalOperation(): void;
