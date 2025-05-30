#!/bin/bash

set -e -x

# Needs one argument: the bundle
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <bundle>"
    exit 1
fi

BUNDLE=$1

# Pull bundle and extract it to a temporary directory
podman pull $BUNDLE
CONTAINER_ID=$(podman create $BUNDLE)
TEMP_DIR=$(mktemp -d)

podman cp $CONTAINER_ID:/manifests $TEMP_DIR
podman rm $CONTAINER_ID

# Find the cluster service version YAML file
CSV_FILE=$(find $TEMP_DIR/manifests -name '*.clusterserviceversion.yaml' | head -n 1)
if [ -z "$CSV_FILE" ]; then
    echo "No CSV file found in the bundle."
    exit 1
fi

echo "Found CSV file: $CSV_FILE"

# Extract the name from the CSV file
NAME=$(yq e '.metadata.name' $CSV_FILE)

# Split the name by the first period
IFS='.' read -r OPERATOR_NAME CSV_VERSION <<< "$NAME"
VERSION=${CSV_VERSION#v}

# Create the operator catalog directory
mkdir -p catalog/$OPERATOR_NAME

# Render the bundle to a new file in the operator catalog directory
opm render $BUNDLE -o yaml > catalog/$OPERATOR_NAME/$NAME.yaml

# Delete the temporary directory
rm -rf $TEMP_DIR