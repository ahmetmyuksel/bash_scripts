#!/bin/bash
#It checks the values whose status is different than 20 and created in last 20 minutes in a table in a database running on 10.10.10.10 server.

hostname=$(postgres_host)
port=$(postgres_port)
user=$(postgres_user)
password=$(postgres_password)
database=$(postgres_database)
table=$(postgres_table)

value=$(/opt/sensu/embedded/bin/ruby /opt/sensu/embedded/bin/metrics-postgres-query.rb -h $postgres_host -u $postgres_user -P $postgres_port -p $postgres_password -d $postgres_database -q "select count(*) from $postgres_table where created_at < NOW() - INTERVAL '20 minutes' and status = 20;" | awk '{print $2}')

if [[ $value -ne 0 ]] ; then
  echo 'WARNING:' $postgres_table 'table has a record as status=20 in last 20 minutes'
  echo 'Row count=' $value
  exit 2
fi
echo 'OK: Timestamp and status values are appropriate.'
exit 0
