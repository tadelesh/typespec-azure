import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using global.Azure.ClientGenerator.Core;
using Spector;

@doc("Test decorators @protocolAPI and @convenientAPI for controlling method generation.")
@scenarioService("/azure/client-generator-core/protocol-and-convenient")
namespace _Specs_.Azure.ClientGenerator.Core.ProtocolAndConvenient;

model SimpleModel {
  name: string;
}

@scenario
@scenarioDoc("""
  This scenario tests an operation with default behavior (both protocol and convenience methods generated).
  Expected response body:
  ```json
  {
    "name": "both"
  }
  ```
  """)
@route("/both")
@get
op bothMethods(): SimpleModel;

@convenientAPI(false)
@scenario
@scenarioDoc("""
  This scenario tests an operation where only the protocol method is generated.
  The @convenientAPI(false) decorator disables convenience method generation.
  Expected response body:
  ```json
  {
    "name": "protocol-only"
  }
  ```
  """)
@route("/protocol-only")
@get
op protocolOnly(): SimpleModel;

@protocolAPI(false)
@scenario
@scenarioDoc("""
  This scenario tests an operation where only the convenience method is generated.
  The @protocolAPI(false) decorator disables protocol method generation.
  Expected response body:
  ```json
  {
    "name": "convenient-only"
  }
  ```
  """)
@route("/convenient-only")
@get
op convenientOnly(): SimpleModel;
