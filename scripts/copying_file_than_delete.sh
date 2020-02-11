#!/bin/bash

DESTINATION=root@10.10.10.10

for FILE in $(ls -a /home/user/docker/log_*/*.gz); do
 scp $FILE  $DESTINATION:$FILE
 echo $FILE file copied to $DESTINATION":"$FILE

 if [[ -f $FILE ]]; then
   echo $FILE and $DESTINATION:$FILE
   if ssh $DESTINATION stat $FILE \> /dev/null 2\>\&1
     then
       rm -rf $FILE
       echo $FILE "deleted."
   fi
 fi
done
