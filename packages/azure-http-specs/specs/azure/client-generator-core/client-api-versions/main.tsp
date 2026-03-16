import "@typespec/http";
import "@typespec/versioning";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Versioning;
using Spector;

@doc("Test decorator @clientApiVersions.")
@versioned(Versions)
@scenarioService("/azure/client-generator-core/client-api-versions")
@global.Azure.ClientGenerator.Core.clientNamespace(
  "azure.clientgenerator.core.clientapiversions",
  "java"
)
namespace _Specs_.Azure.ClientGenerator.Core.ClientApiVersions;

enum Versions {
  @doc("Version 2024-01-01")
  v2024_01_01: "2024-01-01",
}

@scenario
@scenarioDoc("""
  Test that the client exposes additional API versions specified by @clientApiVersions.
  The service defines only v2024_01_01, but the client should also expose v2023_01_01 and v2023_06_01.
  
  Expected query parameter: api-version="2024-01-01"
  Expected response: 204 No Content
  """)
@route("/get")
@get
op get(@query("api-version") apiVersion: string): void;
