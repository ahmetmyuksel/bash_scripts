#ssh root@10.10.10.10 'oc login https://openshift.domainname.com:8443 --insecure-skip-tls-verify=true -u admin -p changeme'

token=$(ssh root@10.10.10.10 'oc whoami --show-token')
echo $token

docker login -p $token -u unused docker-registry-default.apps.domainname.com
echo 'docker login -p' $token '-u unused docker-registry-default.apps.domainname.com'

if [[ ! $? -eq 0 ]]; then
    echo CRITICAL: can not login to openshift registry
    exit 2
fi
