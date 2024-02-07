Installing OKDerator Catalog
===

> [!CAUTION]
> OKDerator is a WIP project that is in active development. Cluster breaking changes could be introduced.
> Use with caution!

> [!IMPORTANT]
> Keep up to date with changes and development by joining the OKD Working Group community

# Quick Start
`oc apply -f https://raw.githubusercontent.com/okd-project/okderators-catalog-index/main/install/okderators.catalogsource.yml`

Must be authenticated as a `cluster-admin`, if succeful the command will return

`catalogsource.operators.coreos.com/okderators created`
