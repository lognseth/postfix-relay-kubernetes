#!/bin/bash
set -e 
set -o pipefail

# This script will deploy all Helm charts in the helm-charts directory using Helm package. 
# It will also get the version from the Chart.yaml and set this as the version of the packaged chart.
# Note that this script _must_ be run after the login.sh script.

containerRegistry=${GHCR_ENDPOINT}

charts=(
    "postfix"
)

for chart in "${charts[@]}";
do
    helm dependency update "$chart"
    helm package "$chart"
    VERSION=`sed -n 's/^version:\(.*\)/\1/p' < "$chart"/Chart.yaml`
    VERSION=`echo "$VERSION" | xargs`
    helm push "$chart-$VERSION.tgz" "$containerRegistry"
done
echo "published all charts"