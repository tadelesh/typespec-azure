import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";
import "@typespec/spector";

using Azure.ClientGenerator.Core;
using Spector;

// Apply @scope to exclude an operation from C#
@@scope(_Specs_.Azure.ClientGenerator.Core.Scope.allLanguages, "!csharp");
