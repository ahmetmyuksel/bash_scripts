#hadoop distcp command can be use for copying all datas on hdfs to remote server. But this command is limited to 30000 files. So you can copy each sub folder with bash scripts, using for loop.
#other solution is using hadoop get command. you can save files with hadoop get, then zip them with -9, then copy with rsync. After it is done, unzip and use hadoop put command

hdfs_server=$(ip_address:port)  #4.3.2.1:50070
remote_hdfs=$(ip_address:port)  #1.2.3.4:8020
sudo -u hdfs hadoop distcp -pb -overwrite webhdfs://$hdfs_server/data  hdfs://$remote_hdfs/data1    #awk is cuts columns of output. so it can be change every path

for i in $(sudo -u hdfs hadoop fs -ls /data | awk '{print $8}' |awk -F '/' '{print $3}'); do
  echo "$i COPYING"
  sudo -u hdfs hadoop distcp -pb -overwrite webhdfs://$hdfs_server/data/$i  hdfs://$remote_hdfs/data/$i
  echo "$i COPIED"
done

#for update these folders, can be use hadoop update command
for i in $(sudo -u hdfs hadoop fs -ls /data | awk '{print $8}' |awk -F '/' '{print $3}'); do
  echo "$i UPDATING"
    sudo -u hdfs hadoop distcp -pb -update webhdfs://$hdfs_server/data/$i  hdfs://$remote_hdfs/data/$i
  echo "$i UPDATED"
done
