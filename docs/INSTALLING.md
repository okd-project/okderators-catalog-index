Installing OKDerators Catalog
===

> [!CAUTION]
> OKDerators is a WIP project that is in active development. Cluster breaking changes could be introduced.
> Use with caution!

> [!IMPORTANT]
> Keep up to date with changes and development by joining the OKD Working Group community

# Quick Start

To install the OKDerators CatalogSource, run the following command:
```bash
curl -s https://raw.githubusercontent.com/okd-project/okderators-catalog-index/refs/heads/release-4.18/hack/install-catalog.sh | bash
```

You must be authenticated as a `cluster-admin`, if successful the command will return

`catalogsource.operators.coreos.com/okderators created`


# Supported Versions

This matrix shows the supported versions of OKD and the corresponding catalog image to use.

| OKD Version  | Status | Catalog Image                             |
|--------------|--------|-------------------------------------------|
| 4.15         | EOL    | `quay.io/okderators/catalog-index:latest` |
| 4.18         | Active | `quay.io/okderators/catalog-index:4.18`   |