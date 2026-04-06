import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using global.Azure.ClientGenerator.Core;
using Spector;

@doc("Test for @scope decorator.")
@scenarioService("/azure/client-generator-core/scope")
namespace _Specs_.Azure.ClientGenerator.Core.Scope;

model Widget {
  id: string;
  name: string;
}

@route("/allLanguages")
@scenario
@scenarioDoc("""
  Test that an operation without @scope is generated for all languages.
  Expected response body:
  ```json
  { "id": "1", "name": "widget1" }
  ```
  """)
namespace AllLanguages {
  @route("/get")
  @get
  op getWidget(): Widget;
}

@route("/pythonOnly")
@scenario
@scenarioDoc("""
  Test that an operation with @scope("python") is only generated for Python.
  Expected response body:
  ```json
  { "id": "2", "name": "python-widget" }
  ```
  """)
namespace PythonOnly {
  @route("/get")
  @get
  @scope("python")
  op getPythonWidget(): Widget;
}

@route("/excluded")
@scenario
@scenarioDoc("""
  Test that an operation with @scope("!csharp") is generated for all languages except C#.
  Expected response body:
  ```json
  { "id": "3", "name": "excluded-widget" }
  ```
  """)
namespace Excluded {
  @route("/get")
  @get
  @scope("!csharp")
  op getExcludedWidget(): Widget;
}
