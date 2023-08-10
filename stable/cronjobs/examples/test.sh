#!/usr/bin/env bash
set -Eeuo pipefail

pushd ../ > /dev/null
rm -rf ./charts/ Chart.lock
helm dependency update > /dev/null
popd > /dev/null || exit

for testCase in */; do
    echo "Test case: ${testCase}"
    pushd "${testCase}/" > /dev/null || exit
    rm -rf ./charts/ Chart.lock
    helm dependency update > /dev/null
    helm template . \
      --debug \
      --dry-run \
      --generate-name \
      --namespace test \
      --dependency-update \
      --set global.org=core \
      --set global.serviceName=test \
      --values values.yaml > 1.yaml
    popd > /dev/null || exit
done
