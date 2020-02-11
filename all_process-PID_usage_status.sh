#!/usr/bin/env bash
OUT=$(mktemp)
ps xal > $OUT
timestamp=$(date +%s)
hostname=$(hostname)

function get_disk_read() {
  if [[ $(iotop -kbo -p $1 -n 5|wc -l) -gt 16  ]]; then
    disk_read=$(iotop -kbo -p $1 -n 5|tail -n 1|awk '{print $4"/1"}'|bc)
    if [[ ! $? -eq 0 ]]; then
      disk_read="0"
    fi
  else
    disk_read="0"
  fi
  echo "$hostname"."$2"."disk_read" "$disk_read" $timestamp
}

function get_disk_write() {
  if [[ $(iotop -kbo -p $1 -n 5|wc -l) -gt 16 ]]; then
    disk_write=$(iotop -kbo -p $1-n 5|tail -n 1|awk '{print $6"/1"}'|bc)
    if [[ ! $? -eq 0 ]]; then
      disk_write="0"
    fi
  else
    disk_write="0"
  fi
  echo "$hostname"."$2"."disk_write" "$disk_write" $timestamp
}

function get_cpu_usage() {
  ps -p $1 2>&1 >/dev/null
  if [[ ! $? -eq 0 ]]; then
    cpu_usage="0"
  else
    cpu_usage=$(ps -p $1 -o %cpu|tail -n1|awk '{print $1"/1"}'|bc)
    echo "$hostname"."$2"."cpu_usage" "$cpu_usage" $timestamp
  fi
}

function get_mem_usage() {
  ps -p $1 2>&1 >/dev/null
  if [[ ! $? -eq 0 ]]; then
    mem_usage="0"
  else
    mem_usage=$(ps -p $1 -o %mem|tail -n1|awk '{print $1"/1"}'|bc)
    echo "$hostname"."$2"."mem_usage" "$mem_usage" $timestamp
  fi
}

while read line; do
  pidno=$(echo $line |awk '{print $3}'|sed -e 's/\./-/g')
  if [[ $pidno == "PID" ]]; then
    continue
  fi
  if [[ ! $? -eq 0 ]]; then
    continue
  fi
  command=$(echo $line |awk '{print $13}'|sed -e 's/\./-/g')
  if [[ ! $? -eq 0 ]]; then
    continue
  fi
  if [[ -f /proc/"$pidno"/status ]]; then
    name=$(cat /proc/"$pidno"/status|grep Name:|awk '{print $2}'|sed -e 's/\./-/g')
    if [[ ! $? -eq 0 ]]; then
      continue
    fi
    state=$(cat /proc/"$pidno"/status|grep State:|awk '{print $2}'|sed -e 's/\./-/g')
    if [[ ! $? -eq 0 ]]; then
      continue
    fi
  fi
  if [[ $state == "S" ]]; then
    state_name="sleeping"
  elif [[ $state == "R" ]]; then
    state_name="running"
  elif [[ $state == "Z" ]]; then
    state_name="zombie"
  fi
  if [[ ! $? -eq 0 ]]; then
    continue
  fi
  get_disk_read $pidno $name &
  get_disk_write $pidno $name &
  get_cpu_usage $pidno $name &
  get_mem_usage $pidno $name &
done < $OUT
wait
