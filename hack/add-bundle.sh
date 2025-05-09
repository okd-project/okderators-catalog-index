#!/bin/bash

if [ $# -ne 3 ]; then
  echo "Usage: $0 <bundle image> <csv> <version>"
  exit 1
fi

bundle=$1
csv=$2
version=$3

opm render $bundle -o yaml > "catalog/$csv/$csv.v$version.yaml"