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

@route("/included")
@scenario
@scenarioDoc("""
  This scenario tests that an operation with no scope restriction is included for all languages.
  Expected query parameter: name="sample"
  Expected response body:
  ```json
  {
    "name": "sample"
  }
  ```
  """)
namespace IncludedForAll {
  @route("/all")
  @get
  op allLanguages(@query name: string): ScopeModel;
}

@route("/excluded")
@scenario
@scenarioDoc("""
  This scenario tests that the `@scope` decorator can be used to include an operation only for
  specific languages. An operation scoped to `"csharp"` should only be generated for C#.
  The second operation scoped to `"!csharp"` should be generated for all languages except C#.
  Expected query parameter: name="sample"
  Expected response body:
  ```json
  {
    "name": "sample"
  }
  ```
  """)
namespace LanguageSpecific {
  @route("/csharpOnly")
  @get
  @scope("csharp")
  op csharpOnly(@query name: string): ScopeModel;

  @route("/excludeCsharp")
  @get
  @scope("!csharp")
  op excludeCsharp(@query name: string): ScopeModel;
}
