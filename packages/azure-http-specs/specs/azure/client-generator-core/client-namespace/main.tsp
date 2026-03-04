import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using global.Azure.ClientGenerator.Core;
using Spector;

@doc("Test decorator @clientNamespace for overriding the namespace of types in generated client libraries.")
@scenarioService("/azure/client-generator-core/client-namespace")
namespace _Specs_.Azure.ClientGenerator.Core.ClientNamespace;

@clientNamespace("Azure.ClientGenerator.Core.ClientNamespace.Models")
model RenamedNamespaceModel {
  name: string;
}

@scenario
@scenarioDoc("""
  This scenario tests that @clientNamespace moves a model to a different namespace in generated client code.
  The generated model "RenamedNamespaceModel" should be in the "Azure.ClientGenerator.Core.ClientNamespace.Models" namespace
  instead of the default namespace.
  Expected query parameter: name="test"
  Expected response body:
  ```json
  {
    "name": "test"
  }
  ```
  """)
@route("/model")
@get
op getModel(@query name: string): RenamedNamespaceModel;
