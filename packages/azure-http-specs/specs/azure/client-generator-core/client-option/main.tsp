import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using global.Azure.ClientGenerator.Core;
using Spector;

@doc("Test decorator @clientOption for passing experimental options to emitters.")
@scenarioService("/azure/client-generator-core/client-option")
@global.Azure.ClientGenerator.Core.clientNamespace(
  "azure.clientgenerator.core.clientoption",
  "java"
)
namespace _Specs_.Azure.ClientGenerator.Core.ClientOption;

#suppress "@azure-tools/typespec-client-generator-core/client-option" "testing client option"
@clientOption("enableExperimentalFeature", true, "python")
model TestModel {
  name: string;
}

@scenario
@scenarioDoc("""
  This scenario tests that @clientOption passes options to emitters.
  The TestModel has a client option "enableExperimentalFeature" set to true for Python.
  Emitters should be able to read this option via getClientOptions().
  Expected query parameter: name="test"
  Expected response body:
  ```json
  {
    "name": "test"
  }
  ```
  """)
@route("/test")
@get
op test(@query name: string): TestModel;
