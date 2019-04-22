#this script checks how much whisper file(data) written on /data/graphite in last 10 minutes and compare the counts between last situtation and 10 mins before.

value1=$1 #for example 1000
value2=$2 #for example 1200
if [[ $# -le 1 ]]; then echo 'wrong usage' && exit 3; fi
old_check=$(cat /tmp/count.txt)
new_check=$(find /data/graphite/ -type f  -cmin -10|wc -l)
difference=$(expr $old_check - $new_check)
absolute=${difference#-}

if [[ $absolute -gt $value1 && $absolute -le $value2 ]]; then  #if between 1000-1200, returns warning level
    echo WARNING: The number of metrics that have been checked has been reduced by $absolute.
    echo Old metric count: $old_check
    echo New metric count: $new_check
    exit 1
elif [[ $absolute -gt $value2 ]]; then  #if higher then 1200, returns critical
    echo CRITICAL: The number of metrics that have been checked has been reduced to less than $absolute or too many new metrics have been entered.
    echo Old metric count: $old_check
    echo New metric count: $new_check
    exit 2
fi
echo $new_check  > /tmp/count.txt
echo 'OK'
exit 0
