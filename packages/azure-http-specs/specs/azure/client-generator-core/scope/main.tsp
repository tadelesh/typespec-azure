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

model ScopeModel {
  name: string;
}

@scenario
@scenarioDoc("""
  Test an operation that is scoped to all languages (no scope decorator).
  All language emitters should generate this operation.
  Expected query parameter: name="sample"
  Expected response body:
  ```json
  {
    "name": "sample"
  }
  ```
  """)
@route("/allLanguages")
@get
op allLanguages(@query name: string): ScopeModel;

@scenario
@scenarioDoc("""
  Test an operation that is scoped to specific languages using `@scope("!java")`.
  All language emitters EXCEPT Java should generate this operation.
  Expected query parameter: name="sample"
  Expected response body:
  ```json
  {
    "name": "sample"
  }
  ```
  """)
@route("/excludeJava")
@get
@scope("!java")
op excludeJava(@query name: string): ScopeModel;

@doc("Model with language-scoped properties.")
model ScopedPropertyModel {
  name: string;

  @doc("Property only for Python emitter.")
  @scope("python")
  pythonProperty?: string;

  @doc("Property for all emitters except Go.")
  @scope("!go")
  excludeGoProperty?: string;
}

@scenario
@scenarioDoc("""
  Test a model with language-scoped properties.
  The `pythonProperty` should only be generated for Python.
  The `excludeGoProperty` should be generated for all languages except Go.
  Expected request body:
  ```json
  {
    "name": "sample"
  }
  ```
  Expected response body:
  ```json
  {
    "name": "sample"
  }
  ```
  """)
@route("/scopedProperties")
@put
op scopedProperties(@body body: ScopedPropertyModel): ScopedPropertyModel;
