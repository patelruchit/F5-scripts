#!/bin/sh

# Note that the pool memeber is the VS in the same device's LTM module and the self-ip was added to the GSLB>>Server to get it populated

#Ask for the number of virtual server required
echo -e "Enter the number of virtual servers required:\c"
read -r TOTAL_COUNT

#Ask for the IP segment
echo -e "Enter the first IP (non-routable):\c"
read -r FIRST_IP

#Ask for the name of the virtual server
echo -e "Enter the name you want for the virtual server:\c"
read -r NAME

#Function to convert the IP to integer for ease of change of subnets
dotted_decimal_to_integer()
{
    IFS="." read a b c d <<< `echo $1`

 # Left-shift the values as per bits position for the octects.   
    expr $(( (a<<24) + (b<<16) + (c<<8) + d ))
}

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
START=$(dotted_decimal_to_integer $FIRST_IP)

for i in `seq 1 $TOTAL_COUNT`
do 
    IP=$(integer_to_dotted_decimal $START)
#Change the F5 command as per the requirement.
    echo "Creating virtual server $NAME$i and IP: $IP"  
    tmsh create ltm virtual $NAME$i { destination $IP:80 ip-protocol tcp mask 255.255.255.255 profiles add { http } }
    ((START=START+1))
done
