#!/usr/bin/env bash
#token=$(ssh root@10.10.10.10 'oc login -u admin -p q1w2e3r4' )
#/usr/local/bin/oc login https://ocp.mydomain.com:8443 --insecure-skip-tls-verify=true -u admin -p password
#ssh root@10.10.10.10 'oc login https://ocp.mydomain.com:8443 --insecure-skip-tls-verify=true -u admin -p password'

LOCATION=$1
if [[ $(echo $LOCATION) == "openshift.location1" ]]; then
  token=$(ssh root@10.10.10.10 'oc login -u admin -p password1' )
elif [[ $(echo $LOCATION) == "openshift.location2" ]]; then
  token=$(ssh root@192.168.10.10 'oc login -u admin -p password2' )
else
  exit 2
fi

if [[ ! $? -eq 0 ]]; then
    echo CRITICAL: can not login to openshift
    exit 2
fi

if [[ $(echo $LOCATION) == "openshift.location1" ]]; then
  token=$(ssh root@10.10.10.10 'oc whoami --show-token')
  docker login -p $token -u unused docker-registry-default.apps.location1
elif [[ $(echo $LOCATION) == "openshift.location2" ]]; then
  token=$(ssh root@192.168.10.10 'oc whoami --show-token')
  docker login -p $token -u unused docker-registry-default.apps.location2
fi
if [[ ! $? -eq 0 ]]; then
    echo CRITICAL: can not login to openshift
    exit 2
fi
