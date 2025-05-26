#!/bin/bash

if [ $# -ne 3 ]; then
  echo "Usage: $0 <bundle url> <version> <csv>"
  exit 1
fi

bundle=$1
version=$2
csv=$3

opm render "$bundle:$version" -o yaml > "catalog/$csv/$csv.v$version.yaml"