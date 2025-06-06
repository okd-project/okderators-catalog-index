#!/bin/bash

NEXT_VERSION="4.19"
SUPPORTED_VERSIONS="4.15 4.18"

CATALOG_YAML=$(cat <<EOF
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: okderators
  namespace: openshift-marketplace
spec:
  displayName: OKDerators
  image: 'quay.io/okderators/catalog-index:\$CATALOG_TAG'
  publisher: OKD Community
  icon:
    base64data: '' # Todo
    mediatype: '' # Todo
  updateStrategy:
    registryPoll:
      interval: 10m
  priority: -100 # Prefer default/manual CatalogSources
  sourceType: grpc
  grpcPodConfig:
    nodeSelector:
      kubernetes.io/os: linux
      node-role.kubernetes.io/master: ''
    priorityClassName: system-cluster-critical
    securityContextConfig: restricted
    tolerations:
      - effect: NoSchedule
        key: node-role.kubernetes.io/master
        operator: Exists
      - effect: NoExecute
        key: node.kubernetes.io/unreachable
        operator: Exists
        tolerationSeconds: 120
      - effect: NoExecute
        key: node.kubernetes.io/not-ready
        operator: Exists
        tolerationSeconds: 120
EOF
)

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

# Add check for 4.15 to convert the tag to latest
if [[ "$CATALOG_TAG" == "4.15" ]]; then
    CATALOG_TAG="latest"
fi

# Check if cluster version is supported by the catalog
if [[ ! " ${SUPPORTED_VERSIONS[@]} " =~ " ${CATALOG_TAG} " ]]; then
    echo "Clusters running ${CATALOG_TAG} are not supported. Supported versions are: ${SUPPORTED_VERSIONS[*]}"
    exit 1
fi

# Envsubst the catalog source and apply to cluster
$KUBE_CMD apply -f <(envsubst <<< "$CATALOG_YAML")