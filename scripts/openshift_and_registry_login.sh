#token=$(ssh root@10.10.10.10 'oc login -u admin -p q1w2e3r4' )
/usr/local/bin/oc login https://ocp.mydomain.com:8443 --insecure-skip-tls-verify=true -u admin -p password
#ssh root@10.10.10.10 'oc login https://ocp.mydomain.com:8443 --insecure-skip-tls-verify=true -u admin -p password'

if [[ ! $? -eq 0 ]]; then
        echo CRITICAL: can not login to openshift
            exit 2
fi

token=$(ssh root@10.10.10.10 'oc whoami --show-token')
echo $token
docker login -p $token -e unused -u unused docker-registry-default.apps.skyz.tech
echo docker login -p $token -e unused -u unused docker-registry-default.apps.skyz.tech
if [[ ! $? -eq 0 ]]; then
        echo CRITICAL: can not login to openshift registry
            exit 2
fi
