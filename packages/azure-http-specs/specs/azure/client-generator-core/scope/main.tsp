import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Azure.ClientGenerator.Core;
using Spector;

@doc("Test for the @scope decorator.")
@scenarioService("/azure/client-generator-core/scope")
namespace _Specs_.Azure.ClientGenerator.Core.Scope;

@doc("A simple model used for testing.")
model ScopeModel {
  name: string;
}

@route("/allLanguages")
@scenario
@scenarioDoc("""
  This scenario tests an operation that is available in all languages (no scope restriction).
  Expected query parameter: name="sample"
  Expected response body:
  ```json
  {
    "name": "sample"
  }
  ```
  """)
namespace AllLanguages {
  @route("/get")
  @get
  op get(@query name: string): ScopeModel;
}

@route("/scopedToSpecificLanguages")
@scenario
@scenarioDoc("""
  This scenario tests an operation scoped to only specific languages using `@scope("java, python")`.
  The operation should only be generated for Java and Python emitters.
  Other language emitters should not generate this operation.
  Expected query parameter: name="sample"
  Expected response body:
  ```json
  {
    "name": "sample"
  }
  ```
  """)
namespace ScopedToSpecificLanguages {
  @route("/get")
  @get
  @global.Azure.ClientGenerator.Core.scope("java, python")
  op get(@query name: string): ScopeModel;
}

@route("/excludedFromSpecificLanguages")
@scenario
@scenarioDoc("""
  This scenario tests an operation excluded from specific languages using `@scope("!csharp, !go")`.
  The operation should be generated for all languages except C# and Go.
  Expected query parameter: name="sample"
  Expected response body:
  ```json
  {
    "name": "sample"
  }
  ```
  """)
namespace ExcludedFromSpecificLanguages {
  @route("/get")
  @get
  @global.Azure.ClientGenerator.Core.scope("!csharp, !go")
  op get(@query name: string): ScopeModel;
}
