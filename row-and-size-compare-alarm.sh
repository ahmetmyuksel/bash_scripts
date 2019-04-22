#Determines less than 7m rows OR less then 1,4G size file, and creates alarm

limit=1370000000
row=7000000
value=$(ls -latr yourpath/* | awk '{print $5}' | tail -n 1)   #awk is cuts columns of output. so it can be change every path
time=$(ls -latr yourpath* | awk '{print $8}' | tail -n 1)
filename=$(ls -latr yourpath* | awk '{print $9}' | tail -n 1)
row_count=$(cat $filename | wc -l)

if [[ $value -lt $limit || $row_count -lt $row ]] ; then
  echo 'WARNING: The file named' $filename 'created at' $time 'is less than 1.4GB or less than 7M.'
  echo 'Row Count=' $row_count
  echo 'File Size=' $(expr $value / 1048576) 'MB'
  exit 2
fi
echo 'OK: Last created csv file is suitable.'
exit 0

