import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Spector;
using Azure.ClientGenerator.Core;

@doc("Test for @protocolAPI decorator.")
@scenarioService("/azure/client-generator-core/protocol-api")
@global.Azure.ClientGenerator.Core.clientNamespace("azure.clientgenerator.core.protocolapi", "java")
namespace _Specs_.Azure.ClientGenerator.Core.ProtocolApi;

model Resource {
  name: string;
}

@scenario
@scenarioDoc("""
  Test that an operation with @protocolAPI(false) does not generate a protocol method.
  Only the convenience method should be generated.
  
  Expected request:
  - GET /azure/client-generator-core/protocol-api/convenienceOnly?name=sample
  
  Expected response body:
  ```json
  { "name": "sample" }
  ```
  """)
@route("/convenienceOnly")
@get
@global.Azure.ClientGenerator.Core.protocolAPI(false)
op convenienceOnly(@query name: string): Resource;

@scenario
@scenarioDoc("""
  Test that an operation with @convenientAPI(false) does not generate a convenience method.
  Only the protocol method should be generated.
  
  Expected request:
  - GET /azure/client-generator-core/protocol-api/protocolOnly?name=sample
  
  Expected response body:
  ```json
  { "name": "sample" }
  ```
  """)
@route("/protocolOnly")
@get
@global.Azure.ClientGenerator.Core.convenientAPI(false)
op protocolOnly(@query name: string): Resource;

@scenario
@scenarioDoc("""
  Test that an operation without any decorator generates both protocol and convenience methods.
  
  Expected request:
  - GET /azure/client-generator-core/protocol-api/both?name=sample
  
  Expected response body:
  ```json
  { "name": "sample" }
  ```
  """)
@route("/both")
@get
op both(@query name: string): Resource;
