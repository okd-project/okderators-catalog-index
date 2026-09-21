#!/bin/bash

set -e -x

# Needs one argument: the bundle
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <bundle>"
    exit 1
fi

BUNDLE=$1

# Render the bundle. Its name and package field name the catalog file and
# directory (the CSV name prefix is not a reliable package name, e.g. the CSV
# clusterkubedescheduleroperator.vX belongs to the package
# cluster-kube-descheduler-operator). Reading both from the rendered output
# avoids extracting the CSV with podman, which fails for bundle images built
# FROM scratch with no CMD ("no command or entrypoint provided").
RENDERED=$(opm render $BUNDLE -o yaml)
NAME=$(echo "$RENDERED" | yq e 'select(.schema == "olm.bundle") | .name' -)
PACKAGE_NAME=$(echo "$RENDERED" | yq e 'select(.schema == "olm.bundle") | .package' -)

if [ -z "$NAME" ] || [ "$NAME" = "null" ] || [ -z "$PACKAGE_NAME" ] || [ "$PACKAGE_NAME" = "null" ]; then
    echo "Could not determine bundle name/package from opm render output."
    exit 1
fi

echo "Found bundle ${NAME} (package ${PACKAGE_NAME})"

# Create the operator catalog directory
mkdir -p catalog/$PACKAGE_NAME

# Write the rendered bundle to a new file in the operator catalog directory
echo "$RENDERED" > catalog/$PACKAGE_NAME/$NAME.yaml
