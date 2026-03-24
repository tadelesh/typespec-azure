import "@typespec/http";
import "@typespec/spector";
import "@typespec/versioning";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Spector;
using TypeSpec.Versioning;
using Azure.ClientGenerator.Core;

@doc("Test for @clientApiVersions decorator.")
@scenarioService("/azure/client-generator-core/client-api-versions")
@versioned(ServiceVersions)
@global.Azure.ClientGenerator.Core.clientNamespace(
  "azure.clientgenerator.core.clientapiversions",
  "java"
)
namespace _Specs_.Azure.ClientGenerator.Core.ClientApiVersions;

enum ServiceVersions {
  v2024_01_01: "2024-01-01",
  v2024_07_01: "2024-07-01",
}

enum ClientVersions {
  v2023_01_01: "2023-01-01",
  v2023_07_01: "2023-07-01",
  ...ServiceVersions,
}

@@global.Azure.ClientGenerator.Core.clientApiVersions(_Specs_.Azure.ClientGenerator.Core.ClientApiVersions,
  ClientVersions
);

@scenario
@scenarioDoc("""
  Test that @clientApiVersions extends the client's API version enum to include
  additional versions beyond those defined in @versioned.
  
  The service defines versions 2024-01-01 and 2024-07-01 via @versioned.
  The client extends this with 2023-01-01 and 2023-07-01 using @clientApiVersions.
  
  Expected client API version enum to contain: 2023-01-01, 2023-07-01, 2024-01-01, 2024-07-01.
  
  Expected request:
  - GET /azure/client-generator-core/client-api-versions/resource
  
  Expected response body:
  ```json
  { "name": "sample" }
  ```
  """)
@route("/resource")
@get
op getResource(): {
  name: string;
};
