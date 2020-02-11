#!/bin/bash
db_ip=
db_name=

if [[ $(ip a |grep $db_ip |wc -l) -eq 0 ]]; then
  echo 'OK: PG is working here.'
  exit 0
fi
if [[ ! -f /tmp/pg_provisioning_log.txt  ]]; then
    touch /tmp/pg_provisioning_log.txt
fi
if [[ ! -f /tmp/pg_polling_log.txt ]]; then
    touch /tmp/pg_polling_log.txt
fi
time_polling_log=$(sudo -u postgres bash -c "cd && psql -d $db_name -U postgres -c 'select created_at from polling_log order by created_at desc limit 1;' | awk '{print $2}' | sed -n 3p | cut -c 13-20")
time_provisioning_log=$(sudo -u postgres bash -c "cd && psql -d $db_name -U postgres -c 'select created_at from provisioning_log order by created_at desc limit 1;' | awk '{print $2}' | sed -n 3p | cut -c 13-20")
one_hour_ago=$(date -d '1 hour ago' "+%m/%d/%Y -%H:%M:%S" | awk '{print $2}' | cut -c 2-)
provisioning_log=$(sudo -u postgres bash -c "cd && psql -d $db_name -U postgres -c 'SELECT count(status) FROM provisioning_log' | sed -n 3p")
polling_log=$(sudo -u postgres bash -c "cd && psql -d $db_name -U postgres -c 'SELECT count(status) FROM polling_log' | sed -n 3p")
if [ $polling_log -eq $(cat /tmp/pg_polling_log.txt) ] || [ $provisioning_log -eq $(cat /tmp/pg_provisioning_log.txt) ] ;
  then
    echo $provisioning_log > /tmp/pg_provisioning_log.txt
    echo $polling_log > /tmp/pg_polling_log.txt
    echo 'CRITICAL: There is no insert at polling_log or provisioning_log table at last 1 hour.' '| Last insert time at provisioning_log= '$time_provisioning_log '| Last insert time at polling_log= ' $time_polling_log
    exit 2
  else
    echo 'OK: At least one raw added at polling_log table.'
    echo $provisioning_log > /tmp/pg_provisioning_log.txt
    echo $polling_log > /tmp/pg_polling_log.txt
    exit 0
fi
