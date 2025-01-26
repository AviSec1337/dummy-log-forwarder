#!/bin/bash

destination_ip="<syslog-server/SIEM-ip>"
destination_port="514"
log_file="f5.log"

# Infinite loop to send logs continuously
while true; do
    # Loop through each line in the log file
    while IFS= read -r log_line; do
        # Get current timestamp
        current_timestamp=$(date "+%b %d %H:%M:%S")

        # Modify the timestamp in the log line
        modified_line=$(echo "$log_line" | sed "s/^[A-Za-z]\{3\} [0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}/$current_timestamp/")

        # Print the modified log line to verify it
        echo "Forwarding log: $modified_line"

        # Send the log via UDP to the specified destination IP and port
        echo "$modified_line" | socat - UDP:"$destination_ip":"$destination_port"

        # Optional: sleep to avoid overwhelming the network or the receiver
        sleep 1
    done < "$log_file"

    # Optional: if you want to pause for a while between the loops to simulate a delay
    sleep 5  # Adjust the sleep time to control how often the log file is read again
done
