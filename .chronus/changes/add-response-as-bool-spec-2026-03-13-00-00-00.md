---
changeKind: feature
packages:
  - "@azure-tools/azure-http-specs"
---

Add Spector test scenario for `@responseAsBool` decorator. Tests HEAD operations that return a boolean response where 2xx maps to `true` and 404 maps to `false`.
