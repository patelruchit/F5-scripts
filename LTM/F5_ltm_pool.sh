#!/bin/sh

#Ask for the number of Pools requrired
echo -e "Enter the number of Pool members required:\c"
read -r TOTAL_COUNT

#Ask for the name of the Pool
echo -e "Enter the name you want for the Pool:\c"
read -r NAME

for i in `seq 1 $TOTAL_COUNT`
do 
#Make changes to the F5 command as required
    echo "Creating Pool with name $NAME$i and one member endurance_node$i:80"  
#Note that the nodes were created already and the naming sequence is used here to utilize to add them to the pool.
    tmsh create ltm pool $NAME$i members add { test_node$i:80 { monitor gateway_icmp } }
    ((START=START+1))
done
