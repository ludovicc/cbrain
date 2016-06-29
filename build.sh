#!/bin/bash -e

VERSION=${1:-dev}

docker build -f Docker/Dockerfile -t mcin/cbrain .
docker tag mcin/cbrain mcin/cbrain:$VERSION

docker build -f Docker/Dockerfile.Portal -t mcin/cbrain_portal .
docker tag mcin/cbrain_portal mcin/cbrain_portal:$VERSION

docker build -f Docker/Dockerfile.Bourreau -t mcin/cbrain_bourreau .
docker tag mcin/cbrain_bourreau mcin/cbrain_bourreau:$VERSION

docker push mcin/cbrain:$VERSION
docker push mcin/cbrain_portal:$VERSION
docker push mcin/cbrain_bourreau:$VERSION
