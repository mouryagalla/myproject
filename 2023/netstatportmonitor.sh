#!/bin/bash

# Define the list of TCP ports to monitor
ports=(80 443 22)

# Continuously monitor the TCP ports
while true
do
    # Loop through the list of ports and check their status
    for port in ${ports[@]}
    do
        # Use netstat to check if the port is in use
        netstat -an | grep "^tcp.*LISTEN.*:$port\s" > /dev/null
        if [ $? -eq 0 ]
        then
            echo "Port $port is in use"
        else
            echo "Port $port is not in use"
        fi
    done
    
    # Wait for some time before checking the ports again
    sleep 60
done
