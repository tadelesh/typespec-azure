import "@typespec/http";
import "@typespec/versioning";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";
import "./main.tsp";

using Http;
using Versioning;
using Azure.ClientGenerator.Core;
using _Specs_.Azure.ClientGenerator.Core.ClientApiVersions;
using Spector;

namespace Customizations;

@doc("Extended client API versions including older versions not defined by the service.")
enum ClientVersions {
  @doc("Older client API version.")
  v2024_06_01: "2024-06-01",

  ...ServiceVersions,
}

@@clientApiVersions(_Specs_.Azure.ClientGenerator.Core.ClientApiVersions, ClientVersions);

@@clientNamespace(_Specs_.Azure.ClientGenerator.Core.ClientApiVersions,
  "azure.clientgenerator.core.clientapiversions",
  "java"
);
