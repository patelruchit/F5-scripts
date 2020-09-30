#!/bin/sh

#Ask for the number of monitors requrired
echo -e "Enter the number of monitors required:\c"
read -r TOTAL_COUNT

#Ask for the name of the monitor
echo -e "Enter the name you want for the monitor:\c"
read -r NAME

for i in `seq 1 $TOTAL_COUNT`
do 
#Make changes to the F5 command as required
    echo "Creating monitor with name $NAME$i"  
    tmsh create ltm monitor tcp $NAME$i { send GET/ recv /endurance }
    ((START=START+1))
done
