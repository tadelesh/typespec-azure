import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Azure.ClientGenerator.Core;
using Spector;

@doc("Test for @useSystemTextJsonConverter decorator.")
@scenarioService("/azure/client-generator-core/use-system-text-json-converter")
namespace _Specs_.Azure.ClientGenerator.Core.UseSystemTextJsonConverter;

@doc("Model that requires a custom JSON converter for backward compatibility (C# specific).")
@global.Azure.ClientGenerator.Core.useSystemTextJsonConverter
model ModelWithCustomConverter {
  @doc("Property that needs custom serialization.")
  value: string;

  @doc("Timestamp property.")
  timestamp: utcDateTime;
}

@doc("Model without custom converter for comparison.")
model ModelWithoutCustomConverter {
  @doc("Standard property.")
  value: string;

  @doc("Standard timestamp.")
  timestamp: utcDateTime;
}

@scenario
@scenarioDoc("""
  Test model with @useSystemTextJsonConverter decorator. This model should be
  generated with a custom JSON converter in C# for backward compatibility.
  Expected request body:
  ```json
  {
    "value": "test-value",
    "timestamp": "2024-01-01T00:00:00Z"
  }
  ```
  Expected response body:
  ```json
  {
    "value": "test-value",
    "timestamp": "2024-01-01T00:00:00Z"
  }
  ```
  """)
@route("/with-converter")
@post
op withConverter(@body body: ModelWithCustomConverter): ModelWithCustomConverter;

@scenario
@scenarioDoc("""
  Test model without custom converter for comparison.
  Expected request body:
  ```json
  {
    "value": "test-value",
    "timestamp": "2024-01-01T00:00:00Z"
  }
  ```
  Expected response body:
  ```json
  {
    "value": "test-value",
    "timestamp": "2024-01-01T00:00:00Z"
  }
  ```
  """)
@route("/without-converter")
@post
op withoutConverter(@body body: ModelWithoutCustomConverter): ModelWithoutCustomConverter;
