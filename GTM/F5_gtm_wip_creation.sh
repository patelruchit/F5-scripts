#!/bin/sh

#Ask for the number of GTM WIPs requrired
echo -e "Enter the number of GTM pools required:\c"
read -r TOTAL_COUNT

#Ask for the name of the WIP
echo -e "Enter the name you want for the GTM WIP:\c"
read -r NAME

for i in `seq 1 $TOTAL_COUNT`
do 
#Make changes to the F5 command as required
    echo "Creating GTM WIP with name $NAME$i.com"  
    tmsh create gtm wideip a $NAME$i.com
    ((START=START+1))
done














