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

@doc("Test for @clientApiVersions decorator to extend the API version enum.")
@scenarioService(
  "/azure/client-generator-core/client-api-versions",
  {
    versioned: ServiceVersions,
  }
)
@versioned(ServiceVersions)
namespace _Specs_.Azure.ClientGenerator.Core.ClientApiVersions;

@doc("Supported service API versions.")
enum ServiceVersions {
  @doc("Service API version 2024-07-01.")
  v2024_07_01: "2024-07-01",

  @doc("Service API version 2025-01-01.")
  v2025_01_01: "2025-01-01",
}

@doc("A simple widget model.")
model Widget {
  @doc("Widget identifier.")
  id: string;

  @doc("Widget name.")
  name: string;
}

@scenario
@scenarioDoc("""
  Test @clientApiVersions decorator to extend the client API version enum.
  The service defines versions 2024-07-01 and 2025-01-01, but the client exposes
  additional older versions (2024-01-01 and 2024-04-01) via @clientApiVersions.

  This operation should be called with the latest version (2025-01-01) by default.

  Expected query parameter: api-version=2025-01-01
  Expected response body:
  ```json
  {
    "id": "widget-1",
    "name": "Sample Widget"
  }
  ```
  """)
@doc("Get a widget.")
@get
@route("/widget")
op getWidget(@query("api-version") apiVersion: ServiceVersions): Widget;
