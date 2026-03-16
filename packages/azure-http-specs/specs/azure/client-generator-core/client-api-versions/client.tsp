import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";
import "@typespec/spector";

using Azure.ClientGenerator.Core;
using Spector;

// Define additional API versions beyond what the service specifies
enum ClientVersions {
  v2023_01_01: "2023-01-01",
  v2023_06_01: "2023-06-01",
  ..._Specs_.Azure.ClientGenerator.Core.ClientApiVersions.Versions,
}

@@clientApiVersions(_Specs_.Azure.ClientGenerator.Core.ClientApiVersions, ClientVersions);
