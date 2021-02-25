#!/bin/sh

#Ask for the number of Nodes requrired
echo -e "Enter the number of Pool members required:\c"
read -r TOTAL_COUNT

#Ask for the IP segment
echo -e "Enter the first IP (non-routable):\c"
read -r FIRST_IP

#Ask for the name of the node
echo -e "Enter the name you want for the Pool members:\c"
read -r NAME

#Function to convert the IP to integer
function iptoint
{
#Returns the integer representation of an IP arg, passed in ascii dotted-decimal notation (x.x.x.x)
IP=$1; IPNUM=0
for (( i=0 ; i<4 ; ++i )); do
((IPNUM+=${IP%%.*}*$((256**$((3-${i}))))))
IP=${IP#*.}
done
echo $IPNUM 
} 

#Function to convert the IP to integer for ease of change of subnets
#dotted_decimal_to_integer()
#{
#using dot '.' as the internal field separator variable (IFS) as it is an IP.
#    IFS="." read a b c d <<< `echo $1`
#
 # Left-shift the values as per bits position for the octects.   
#    expr $(( (a<<24) + (b<<16) + (c<<8) + d ))
#}

#Function to convert integer to IP for F5 and echo
integer_to_dotted_decimal()
{
    local ip=$1
    let a=$((ip>>24&255))
    let b=$((ip>>16&255))
    let c=$((ip>>8&255))
    let d=$((ip&255))
    echo "${a}.${b}.${c}.${d}"
}
#Convert the first ip to integer 
START=$(iptoint $FIRST_IP)

for i in `seq 1 $TOTAL_COUNT`
do 
    IP=$(integer_to_dotted_decimal $START)
#Change the F5 command as per the requirement.
    echo "Creating Pool Member with name $NAME$i and IP: $IP"  
    tmsh create ltm node $NAME$i address $IP
    ((START=START+1))
done
