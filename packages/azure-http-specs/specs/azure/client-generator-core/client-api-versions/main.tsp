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
using Spector;

@scenarioService(
  "/azure/client-generator-core/client-api-versions",
  {
    versioned: ServiceVersions,
  }
)
namespace _Specs_.Azure.ClientGenerator.Core.ClientApiVersions;

@doc("Service-defined API versions.")
enum ServiceVersions {
  @doc("Api version 2025-01-01.")
  v2025_01_01: "2025-01-01",
}

@scenario
@scenarioDoc("""
  This scenario tests that the client can call a service operation using the service-defined API version
  passed as a query parameter.
  
  Expected query parameter: api-version="2025-01-01"
  Expected response status: 200
  """)
@route("/operation")
@get
op getOperation(@query("api-version") apiVersion: string): OkResponse;
