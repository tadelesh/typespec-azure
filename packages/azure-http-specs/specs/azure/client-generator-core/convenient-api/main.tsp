import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Azure.ClientGenerator.Core;
using Spector;

@doc("Test for the @convenientAPI and @protocolAPI decorators.")
@scenarioService("/azure/client-generator-core/convenient-api")
namespace _Specs_.Azure.ClientGenerator.Core.ConvenientApi;

@doc("A simple model used for testing.")
model SimpleModel {
  name: string;
}

@route("/protocolOnly")
@scenario
@scenarioDoc("""
  This scenario tests an operation with only protocol API generation.
  The operation has `@convenientAPI(false)` so only the protocol method should be generated.
  Expected query parameter: name="sample"
  Expected response body:
  ```json
  {
    "name": "sample"
  }
  ```
  """)
namespace ProtocolOnly {
  @route("/get")
  @get
  @global.Azure.ClientGenerator.Core.convenientAPI(false)
  op get(@query name: string): SimpleModel;
}

@route("/convenientOnly")
@scenario
@scenarioDoc("""
  This scenario tests an operation with only convenient API generation.
  The operation has `@protocolAPI(false)` so only the convenience method should be generated.
  Expected query parameter: name="sample"
  Expected response body:
  ```json
  {
    "name": "sample"
  }
  ```
  """)
namespace ConvenientOnly {
  @route("/get")
  @get
  @global.Azure.ClientGenerator.Core.protocolAPI(false)
  op get(@query name: string): SimpleModel;
}

@route("/both")
@scenario
@scenarioDoc("""
  This scenario tests the default behavior where both protocol and convenient methods are generated.
  Expected query parameter: name="sample"
  Expected response body:
  ```json
  {
    "name": "sample"
  }
  ```
  """)
namespace Both {
  @route("/get")
  @get
  op get(@query name: string): SimpleModel;
}
