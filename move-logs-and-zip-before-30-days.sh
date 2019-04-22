#finding all logs 30 days before, moves to backup folder and gzip them

last_month=$(date -d "-1 month" +%-m)
last_year=$(date -d "-1 year" +%-Y)
date=$(date +$last_year-$last_month-%d)
path=$(/var/log/x/y)
backup=$(/log_backup)

for log in $(find $path -type f -mtime +29 -print); do
  mv -f $log $backup
  echo $log moved
done
echo gzip started
gzip -9 $backup/*

#or can be use:  tar -cvfz /tmp/target_files - | compress > $backup_folder.tar
