---
title: 2. Defining the Service
description: Defining the ARM service
llmstxt: true
---

To define an Azure Resource Manager service, the first thing you will need to do is define the service namespace and decorate it with the `service` and `armProviderNamespace` decorators:

```typespec tryit="{"emit": ["@azure-tools/typespec-autorest"]}"
@armProviderNamespace
@service(#{ title: "<service name>" })
@versioned(Versions)
namespace <mynamespace>;
```

For example:

```typespec
@armProviderNamespace
@service(#{ title: "Contoso User Service" })
@versioned(Versions)
namespace Contoso.Users;
```

## Versioning

ARM services must declare their API versions using a `Versions` enum. Each version member should be decorated with `@armCommonTypesVersion` to specify the version of ARM `common-types` definitions to use in your emitted Swagger files.

```typespec
/** API versions */
enum Versions {
  /** 2021-01-01-preview version */
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v5)
  @previewVersion
  `2021-01-01-preview`,
}
```

If you need to use a different version of the ARM `common-types` definitions, change the `@armCommonTypesVersion` decorator on the version enum member to the version that you require.

## The `using` keyword

Just after the `namespace` declaration, you will also need to include a few `using` statements to pull in symbols from the namespaces of libraries you will for your specification.

For example, these lines pull in symbols from the `@typespec/rest` and `@azure-tools/typespec-azure-resource-manager`:

```
using Http;
using Rest;
using Versioning;
using Azure.Core;
using Azure.ResourceManager;
```

## The `operations` interface

All Resource Providers are required to provide operations that list the available operations for their resources. If you are using ProviderHub (RPaaS: RP as a Service), this functionality can be provided for you, but you will still need to include these operations in your api description. You can include these operations in your API description automatically using the following code:

```typespec
interface Operations extends Azure.ResourceManager.Operations {}
```
