#!/bin/bash
#
# SPDX-FileCopyrightText: 2024 SAP SE or an SAP affiliate company and Gardener contributors
#
# SPDX-License-Identifier: Apache-2.0

set -e

CURRENT_DIR=$(dirname $0)
PROJECT_ROOT="${CURRENT_DIR}"/..
CHART_ROOT="${PROJECT_ROOT}/charts"

if [[ -n $1 ]]; then
  EFFECTIVE_VERSION=$1
elif [[ $EFFECTIVE_VERSION == "" ]]; then
  EFFECTIVE_VERSION=$(cat $PROJECT_ROOT/VERSION)
fi

CHARTLIST=$(find $CHART_ROOT -maxdepth 10 -type f -name "Chart.yaml")

echo "Updating version and appVersion of Helm Charts to $EFFECTIVE_VERSION"

for chart in $CHARTLIST; do
    echo "Updating chart ${chart} with version ${EFFECTIVE_VERSION}"
    sed -i -e "s/^appVersion:.*/appVersion: ${EFFECTIVE_VERSION}/" $chart
    sed -i -e "s/version:.*/version: ${EFFECTIVE_VERSION}/" $chart
    rm -f "$chart-e" # remove backup file created by sed on macos
done
