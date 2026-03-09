import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using global.Azure.ClientGenerator.Core;
using Spector;

@doc("Test decorator @scope to control language-specific operation and property inclusion.")
@scenarioService("/azure/client-generator-core/scope")
@global.Azure.ClientGenerator.Core.clientNamespace("azure.clientgenerator.core.scope", "java")
namespace _Specs_.Azure.ClientGenerator.Core.Scope;

model ScopedModel {
  name: string;
}

@scenario
@scenarioDoc("""
  This scenario tests that the 'allLanguages' operation is generated for all language emitters
  since it has no @scope restriction.
  Expected query parameter: name="test"
  Expected response body:
  ```json
  {
    "name": "test"
  }
  ```
  """)
@route("/all-languages")
@get
op allLanguages(@query name: string): ScopedModel;

@scenario
@scenarioDoc("""
  This scenario tests that the 'pythonOnly' operation is only generated for the Python emitter.
  Other language emitters should NOT generate this operation.
  Expected query parameter: name="test"
  Expected response body:
  ```json
  {
    "name": "test"
  }
  ```
  """)
@route("/python-only")
@get
@scope("python")
op pythonOnly(@query name: string): ScopedModel;

@scenario
@scenarioDoc("""
  This scenario tests that the 'excludeCsharp' operation is generated for all languages
  except C#. The @scope decorator uses negation syntax to exclude a language.
  Expected query parameter: name="test"
  Expected response body:
  ```json
  {
    "name": "test"
  }
  ```
  """)
@route("/exclude-csharp")
@get
@scope("!csharp")
op excludeCsharp(@query name: string): ScopedModel;
