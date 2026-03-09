import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using global.Azure.ClientGenerator.Core;
using Spector;

@doc("Test decorators @convenientAPI and @protocolAPI to control method generation.")
@scenarioService("/azure/client-generator-core/convenient-api")
@global.Azure.ClientGenerator.Core.clientNamespace(
  "azure.clientgenerator.core.convenientapi",
  "java"
)
namespace _Specs_.Azure.ClientGenerator.Core.ConvenientApi;

model SimpleModel {
  name: string;
}

@scenario
@scenarioDoc("""
  This scenario tests that an operation with @convenientAPI(false) generates only a protocol method.
  The client should be able to call the operation using the protocol method.
  Expected query parameter: name="test"
  Expected response body:
  ```json
  {
    "name": "test"
  }
  ```
  """)
@route("/protocol-only")
@get
@convenientAPI(false)
op protocolOnly(@query name: string): SimpleModel;

@scenario
@scenarioDoc("""
  This scenario tests that an operation with @protocolAPI(false) generates only a convenience method.
  The client should be able to call the operation using the convenience method.
  Expected query parameter: name="test"
  Expected response body:
  ```json
  {
    "name": "test"
  }
  ```
  """)
@route("/convenient-only")
@get
@protocolAPI(false)
op convenientOnly(@query name: string): SimpleModel;

@scenario
@scenarioDoc("""
  This scenario tests that @convenientAPI and @protocolAPI can be applied at the interface level.
  All operations in the interface inherit @protocolAPI(false) from the interface,
  but the second operation overrides with @protocolAPI(true).
  Expected query parameter: name="test"
  Expected response body:
  ```json
  {
    "name": "test"
  }
  ```
  """)
@route("/interface-level")
@operationGroup
@protocolAPI(false)
namespace InterfaceLevel {
  @route("/convenient-only")
  @get
  op convenientOnly(@query name: string): SimpleModel;

  @route("/both")
  @get
  @protocolAPI(true)
  op both(@query name: string): SimpleModel;
}
