#search all wsp files in $path and if they are created before 7 days, moves them to backup folder

path=$(/data/other/metrics/whisper)
backup_path=$(/data/other/metric_backup_before7days)

for i in $(find $path -type f -name '*.wsp' | sed 's/\(.*\)\/.*/\1/' | uniq); do
  j=$(expr $(find $i -maxdepth 1 -name '*.wsp' | wc -l) - $(find $i -maxdepth 1 -mtime +7 -name '*.wsp' |wc -l))
  if [[ $j -eq "0" ]] ; then
    echo $i
    mkdir -p $backup_path
    mv -f $i/*.wsp $backup_path/
  fi
done
