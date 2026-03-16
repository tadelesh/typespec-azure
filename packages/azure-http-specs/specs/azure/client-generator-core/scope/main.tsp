import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Azure.ClientGenerator.Core;
using Spector;

@doc("Test for @scope decorator.")
@scenarioService("/azure/client-generator-core/scope")
namespace _Specs_.Azure.ClientGenerator.Core.Scope;

@route("/allLanguages")
@scenario
@scenarioDoc("""
  This scenario tests an operation that is available in all languages (default behavior, no @scope).
  Expected response body:
  ```json
  {
    "message": "all languages"
  }
  ```
  """)
namespace AllLanguages {
  model Response {
    message: string;
  }

  @route("/get")
  @get
  op get(): Response;
}

@route("/javaOnly")
@scenario
@scenarioDoc("""
  This scenario tests an operation scoped to Java only using @scope("java").
  Only Java SDK should generate this operation.
  Expected response body:
  ```json
  {
    "message": "java only"
  }
  ```
  """)
namespace JavaOnly {
  model Response {
    message: string;
  }

  @global.Azure.ClientGenerator.Core.scope("java")
  @route("/get")
  @get
  op get(): Response;
}

@route("/excludeCsharp")
@scenario
@scenarioDoc("""
  This scenario tests an operation with @scope("!csharp") which excludes C# SDK.
  All languages except C# should generate this operation.
  Expected response body:
  ```json
  {
    "message": "exclude csharp"
  }
  ```
  """)
namespace ExcludeCsharp {
  model Response {
    message: string;
  }

  @global.Azure.ClientGenerator.Core.scope("!csharp")
  @route("/get")
  @get
  op get(): Response;
}
