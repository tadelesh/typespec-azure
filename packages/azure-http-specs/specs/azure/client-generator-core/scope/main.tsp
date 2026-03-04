import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using global.Azure.ClientGenerator.Core;
using Spector;

@doc("Test decorator @scope for controlling which language emitters generate operations and properties.")
@scenarioService("/azure/client-generator-core/scope")
namespace _Specs_.Azure.ClientGenerator.Core.Scope;

model ScopedModel {
  name: string;
}

@scenario
@scenarioDoc("""
  This scenario tests an operation that should be generated for all languages (no scope restriction).
  Expected response body:
  ```json
  {
    "name": "all"
  }
  ```
  """)
@route("/all")
@get
op getAllLanguages(): ScopedModel;

@scope("python")
@scenario
@scenarioDoc("""
  This scenario tests an operation scoped to only Python.
  Only the Python emitter should generate this operation.
  Other language emitters should omit it.
  Expected response body:
  ```json
  {
    "name": "python-only"
  }
  ```
  """)
@route("/python-only")
@get
op pythonOnly(): ScopedModel;

@scope("!java")
@scenario
@scenarioDoc("""
  This scenario tests an operation excluded from Java.
  All language emitters except Java should generate this operation.
  Expected response body:
  ```json
  {
    "name": "not-java"
  }
  ```
  """)
@route("/not-java")
@get
op excludeJava(): ScopedModel;
