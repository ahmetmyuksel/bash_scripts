#!/bin/bash

cust_func(){
  echo "Do something $1 times..."
  sleep 1
}

for i in {1..5}
do
   cust_func $i &    #Put a function in the background
done

## Put all cust_func in the background and bash would wait until those are completed before displaying all done message
wait
echo "All done"

