import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using global.Azure.ClientGenerator.Core;
using Spector;

@doc("Test decorator @scope for controlling operation visibility per language.")
@scenarioService("/azure/client-generator-core/scope")
@global.Azure.ClientGenerator.Core.clientNamespace("azure.clientgenerator.core.scope", "java")
namespace _Specs_.Azure.ClientGenerator.Core.Scope;

model ScopeModel {
  name: string;
}

@scenario
@scenarioDoc("""
  This scenario tests that an operation without @scope is generated for all languages.
  Expected query parameter: name="all"
  Expected response body:
  ```json
  {
    "name": "all"
  }
  ```
  """)
@route("/allLanguages")
@get
op allLanguages(@query name: string): ScopeModel;

@scenario
@scenarioDoc("""
  This scenario tests that an operation decorated with @scope("!csharp") is excluded from C# generation
  but included in all other languages.
  Expected query parameter: name="excluded"
  Expected response body:
  ```json
  {
    "name": "excluded"
  }
  ```
  """)
@route("/excludeCsharp")
@get
@scope("!csharp")
op excludeCsharp(@query name: string): ScopeModel;
