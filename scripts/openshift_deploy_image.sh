#!/bin/bash

if [[ ! $? -eq 0 ]]; then
    echo CRITICAL: can not login to openshift
    exit 2
fi
PACKAGE_NAME=$1
PACKAGE_VERSION=$2

#/usr/local/bin/oc set image deploymentconfigs/"$PACKAGE_NAME" "$PACKAGE_NAME"="$PACKAGE_NAME":"$PACKAGE_VERSION" -n "$PROJECT_NAMESPACE"

function deploy() {
        echo $PACKAGE_NAME $PACKAGE_VERSION $PROJECT_NAMESPACE
        sudo -u root /usr/local/bin/oc patch dc $PACKAGE_NAME --patch="{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\": \"${PACKAGE_NAME}\", \"image\": \"registry.company.com/${PACKAGE_NAME}:${PACKAGE_VERSION}\"}]}}}}" -n $PROJECT_NAMESPACE
}

if [[ $PACKAGE_NAME = +(preprod-ipam-backend|preprod-ipam-ui) ]]; then
  PROJECT_NAMESPACE="preprod-ipam"
  deploy
fi

if [[ $PACKAGE_NAME = +(prod-ipam-backend|prod-ipam-ui) ]]; then
  PROJECT_NAMESPACE="prod-ipam"
  deploy
fi
