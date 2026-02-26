import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";
import "./main.tsp";

using Http;
using Azure.ClientGenerator.Core;
using _Specs_.Azure.ClientGenerator.Core.ClientApiVersions;
using Spector;

namespace Customizations;

enum ClientVersions {
  v2023_01_01: "2023-01-01",
  v2023_06_01: "2023-06-01",
  ...Versions,
}

@@clientApiVersions(_Specs_.Azure.ClientGenerator.Core.ClientApiVersions, ClientVersions);

@@clientNamespace(_Specs_.Azure.ClientGenerator.Core.ClientApiVersions,
  "azure.clientgenerator.core.clientapiversions",
  "java"
);
