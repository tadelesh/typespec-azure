/**
 * DO NOT GENERATE FROM THIS FILE USE client.tsp
 * This is just to simulate a service entrypoint
 */
import "@typespec/http";
import "@typespec/versioning";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Versioning;
using Azure.ClientGenerator.Core;
using Spector;

@scenarioService(
  "/azure/client-generator-core/client-api-versions",
  {
    versioned: Versions,
  }
)
namespace _Specs_.Azure.ClientGenerator.Core.ClientApiVersions;

@doc("Service-defined API versions.")
enum Versions {
  @doc("Api version 2024-01-01.")
  v2024_01_01: "2024-01-01",

  @doc("Api version 2024-06-01.")
  v2024_06_01: "2024-06-01",
}

@scenario
@scenarioDoc("""
  This scenario tests that @clientApiVersions adds additional API versions to the client.
  The service defines versions v2024-01-01 and v2024-06-01.
  The client extends the enum with additional versions v2023-01-01 and v2023-06-01.
  The generated client's API version enum should include all four versions.
  Expected query parameter: api-version="2024-06-01"
  Expected response status: 204
  """)
@route("/test")
@get
op test(@query("api-version") apiVersion: Versions): void;
