#!/bin/bash

set -euo pipefail

# Check arguments
if [ $# -ne 1 ]; then
  echo "Usage: $0 <tag>"
  exit 1
fi

IMAGE=${IMAGE:-quay.io/okderators/catalog-index}
tag=$1

podman build -t $IMAGE:$tag -f catalog.Containerfile .
podman push $IMAGE:$tag