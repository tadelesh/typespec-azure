import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using global.Azure.ClientGenerator.Core;
using Spector;

@doc("Test decorator @scope.")
@scenarioService("/azure/client-generator-core/scope")
@global.Azure.ClientGenerator.Core.clientNamespace("azure.clientgenerator.core.scope", "java")
namespace _Specs_.Azure.ClientGenerator.Core.Scope;

model Widget {
  name: string;
}

@scenario
@scenarioDoc("""
  Test that a model property with @scope is only included for the specified languages.
  
  Expected response body:
  ```json
  {
    "name": "test"
  }
  ```
  """)
@route("/model")
@get
op getModel(): Widget;

@scenario
@scenarioDoc("""
  Test that an operation with @scope("!csharp") is excluded from C# but available for all other languages.
  
  Expected response: 204 No Content
  """)
@route("/all-languages")
@get
op allLanguages(): void;
