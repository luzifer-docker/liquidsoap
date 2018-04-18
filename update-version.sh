#!/bin/bash

set -euo pipefail

### ---- ###

echo "Switch back to master"
git checkout master
git reset --hard origin/master

### ---- ###

echo "Fetching latest version..."
LATEST=$(curl -sSLf 'https://lv.luzifer.io/catalog-api/liquidsoap/latest.txt?p=version')

echo "Found version ${LATEST}, patching..."
sed -i "s/LIQUIDSOAP_VERSION=.*$/LIQUIDSOAP_VERSION=${LATEST}/" Dockerfile

echo "Checking for changes..."
git diff --exit-code && exit 0

echo "Testing build..."
docker build .

echo "Updating repository..."
git add Dockerfile
git -c user.name='Travis Automated Update' -c user.email='travis@luzifer.io' \
  commit -m "Jenkins ${LATEST}"
git tag ${LATEST}

git push -q https://${GH_USER}:${GH_TOKEN}@github.com/luzifer-docker/liquidsoap.git master --tags
