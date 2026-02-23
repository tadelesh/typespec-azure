import "@azure-tools/typespec-client-generator-core";
import "@typespec/versioning";
import "./main.tsp";

using Azure.ClientGenerator.Core;
using _Specs_.Azure.ClientGenerator.Core.ClientApiVersions;

namespace Customizations;

// Define extended API versions including older versions not in the service spec
enum ClientApiVersions {
  @doc("Client API version 2024-01-01.")
  v2024_01_01: "2024-01-01",

  @doc("Client API version 2024-04-01.")
  v2024_04_01: "2024-04-01",

  // Include all service versions
  ...ServiceVersions,
}

// Apply extended API versions to the service namespace
@@clientApiVersions(_Specs_.Azure.ClientGenerator.Core.ClientApiVersions, ClientApiVersions);

@@clientNamespace(_Specs_.Azure.ClientGenerator.Core.ClientApiVersions,
  "azure.clientgenerator.core.clientapiversions",
  "java"
);
