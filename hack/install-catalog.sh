#!/bin/bash

NEXT_VERSION="4.20"
SUPPORTED_VERSIONS="4.15 4.18 4.19"

# Get script directory
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

CATALOG_YAML=$(cat $SCRIPT_DIR/catalog-source.yaml)

# Find installed command oc or kubectl
if command -v oc &> /dev/null; then
    KUBE_CMD="oc"
elif command -v kubectl &> /dev/null; then
    KUBE_CMD="kubectl"
else
    echo "Neither 'oc' nor 'kubectl' command found. Please install one of them."
    exit 1
fi

# Check if the user is logged in
if ! $KUBE_CMD whoami &> /dev/null; then
    echo "You are not logged in to the Kubernetes cluster. Please log in first."
    exit 1
fi

# Get the OpenShift version of the cluster from ClusterVersion resource
OCP_VERSION=$($KUBE_CMD get clusterversion version -o jsonpath='{.status.desired.version}')
if [ -z "$OCP_VERSION" ]; then
    echo "Failed to retrieve OKD version."
    exit 1
fi

# Pull major and minor version from OCP_VERSION
MAJOR=$(echo "$OCP_VERSION" | cut -d. -f1)
MINOR=$(echo "$OCP_VERSION" | cut -d. -f2)

export CATALOG_TAG="${MAJOR}.${MINOR}"

# Check if cluster version is next, and use the previous version for the catalog
if [[ "$CATALOG_TAG" == "$NEXT_VERSION" ]]; then
    CATALOG_TAG=$(echo "$SUPPORTED_VERSIONS" | tr ' ' '\n' | sort -V | tail -n 1)
fi

# Check if cluster version is supported by the catalog
if [[ ! " ${SUPPORTED_VERSIONS[@]} " =~ " ${CATALOG_TAG} " ]]; then
    echo "Clusters running ${CATALOG_TAG} are not supported. Supported versions are: ${SUPPORTED_VERSIONS[*]}"
    exit 1
fi

# Envsubst the catalog source and apply to cluster
$KUBE_CMD apply -f <(envsubst <<< "$CATALOG_YAML")
