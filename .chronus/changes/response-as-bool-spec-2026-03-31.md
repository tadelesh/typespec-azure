---
changeKind: feature
packages:
  - "@azure-tools/azure-http-specs"
---

Add Spector spec for `@responseAsBool` decorator covering HEAD operations that return boolean based on HTTP status code (2xx→true, 404→false).
