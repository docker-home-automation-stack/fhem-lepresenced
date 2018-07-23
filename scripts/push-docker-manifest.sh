#!/bin/bash
set -e

if [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
  exit 0
fi

echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

for variant in dev latest; do
  echo "Creating manifest file homeautomationstack/fhem-lepresenced:$variant ..."
  docker manifest create homeautomationstack/fhem-lepresenced:$variant \
    homeautomationstack/fhem-lepresenced-amd64_linux:$variant \
    homeautomationstack/fhem-lepresenced-i386_linux:$variant \
    homeautomationstack/fhem-lepresenced-arm32v5_linux:$variant \
    homeautomationstack/fhem-lepresenced-arm32v7_linux:$variant \
    homeautomationstack/fhem-lepresenced-arm64v8_linux:$variant
  docker manifest annotate homeautomationstack/fhem-lepresenced:$variant homeautomationstack/fhem-lepresenced-arm32v5_linux:$variant --os linux --arch arm --variant v5
  docker manifest annotate homeautomationstack/fhem-lepresenced:$variant homeautomationstack/fhem-lepresenced-arm32v7_linux:$variant --os linux --arch arm --variant v7
  docker manifest annotate homeautomationstack/fhem-lepresenced:$variant homeautomationstack/fhem-lepresenced-arm64v8_linux:$variant --os linux --arch arm64 --variant v8
  docker manifest inspect homeautomationstack/fhem-lepresenced:$variant

  echo "Pushing manifest homeautomationstack/fhem-lepresenced:$variant to Docker Hub ..."
  docker manifest push homeautomationstack/fhem-lepresenced:$variant

  echo "Requesting current manifest from Docker Hub ..."
  docker run --rm mplatform/mquery homeautomationstack/fhem-lepresenced:$variant
done
