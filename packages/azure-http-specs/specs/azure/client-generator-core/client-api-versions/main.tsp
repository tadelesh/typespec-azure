import "@typespec/http";
import "@typespec/versioning";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Versioning;
using global.Azure.ClientGenerator.Core;
using Spector;

@doc("Test decorator @clientApiVersions.")
@scenarioService(
  "/azure/client-generator-core/client-api-versions",
  {
    versioned: ServiceVersions,
  }
)
@versioned(ServiceVersions)
@global.Azure.ClientGenerator.Core.clientNamespace(
  "azure.clientgenerator.core.clientapiversions",
  "java"
)
namespace _Specs_.Azure.ClientGenerator.Core.ClientApiVersions;

@doc("Service API versions.")
enum ServiceVersions {
  @doc("Version 2024-01-01.")
  v2024_01_01: "2024-01-01",
}

@doc("Additional client API versions.")
enum ClientVersions {
  v2024_01_01: "2024-01-01",
  v2025_01_01: "2025-01-01",
}

@@clientApiVersions(_Specs_.Azure.ClientGenerator.Core.ClientApiVersions, ClientVersions);

model VersionInfo {
  version: string;
}

@scenario
@scenarioDoc("""
  Test that the client supports the additional API version "2025-01-01"
  defined via @clientApiVersions, beyond the service-defined "2024-01-01".
  
  Expected behavior:
  - GET request to /azure/client-generator-core/client-api-versions/version
  - Query parameter: api-version=2025-01-01
  - Response body:
  ```json
  {
    "version": "2025-01-01"
  }
  ```
  """)
@route("/version")
@get
op getVersion(@query `api-version`: string): VersionInfo;
