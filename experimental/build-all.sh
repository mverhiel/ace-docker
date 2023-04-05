#!/bin/bash

# Later versions from the same site, or else via the Developer edition download site linked from
# https://www.ibm.com/docs/en/app-connect/12.0?topic=enterprise-download-ace-developer-edition-get-started
export DOWNLOAD_URL=https://iwm.dhe.ibm.com/sdfdl/v2/regs2/mbford/Xa.2/Xb.WJL1CuPI9gANX1QcrGVXqLm8R3Z9hT_z6mpcVFZMeWs/Xc.12.0.8.0-ACE-LINUX64-DEVELOPER.tar.gz/Xd./Xf.lPr.D1vk/Xg.12236614/Xi.swg-wmbfd/XY.regsrvs/XZ._OlDET6JkawrJ7N3CNOnkvr8SPnOO-hz/12.0.8.0-ACE-LINUX64-DEVELOPER.tar.gz
export PRODUCT_VERSION=12.0.8.0
export PRODUCT_LABEL=ace-${PRODUCT_VERSION}

export DOWNLOAD_CONNECTION_COUNT=1

# Exit on error
set -e

cd ace-minimal
docker build --build-arg DOWNLOAD_URL --build-arg DOWNLOAD_CONNECTION_COUNT -t ace-minimal:${PRODUCT_VERSION}-alpine -f Dockerfile.alpine .
docker build --build-arg DOWNLOAD_URL --build-arg DOWNLOAD_CONNECTION_COUNT -t ace-minimal:${PRODUCT_VERSION}-ubuntu -f Dockerfile.ubuntu .

cd ../ace-full
docker build --build-arg DOWNLOAD_URL --build-arg DOWNLOAD_CONNECTION_COUNT -t ace-full:${PRODUCT_VERSION}-ubuntu -f Dockerfile.ubuntu .

cd ../ace-basic
docker build --build-arg DOWNLOAD_URL --build-arg DOWNLOAD_CONNECTION_COUNT -t ace-basic:${PRODUCT_VERSION}-ubuntu -f Dockerfile.ubuntu .

cd ../devcontainers
docker build --build-arg DOWNLOAD_URL --build-arg PRODUCT_LABEL -t ace-devcontainer:${PRODUCT_VERSION} -f Dockerfile .
docker build --build-arg DOWNLOAD_URL --build-arg PRODUCT_LABEL -t ace-minimal-devcontainer:${PRODUCT_VERSION} -f Dockerfile.ace-minimal .
docker build --build-arg DOWNLOAD_URL --build-arg PRODUCT_LABEL -t ace-devcontainer-mqclient:${PRODUCT_VERSION} -f Dockerfile.mqclient .

cd ../sample
# Normally only one of these would be built, and would be tagged with an application version
docker build --build-arg LICENSE=accept --build-arg BASE_IMAGE=ace-minimal:${PRODUCT_VERSION}-alpine -t ace-sample:${PRODUCT_VERSION}-alpine -f Dockerfile .
docker build --build-arg LICENSE=accept --build-arg BASE_IMAGE=ace-minimal:${PRODUCT_VERSION}-ubuntu -t ace-sample:${PRODUCT_VERSION}-ubuntu -f Dockerfile .
docker build --build-arg LICENSE=accept --build-arg BASE_IMAGE=ace-full:${PRODUCT_VERSION}-ubuntu -t ace-sample:${PRODUCT_VERSION}-full-ubuntu -f Dockerfile .
