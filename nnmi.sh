#!/bin/bash

# Path to the text file containing IP addresses
ip_file="ip_addresses.txt"

# Get the current date in the format YYYY-MM-DD
current_date=$(date +%F)

# Path to the log file where the output will be recorded, with the current date
log_file="nmpconfigpoll_logs_$current_date.txt"

# Read each line in the file as an IP address
while IFS= read -r ip_address
do
  echo "Processing $ip_address..."
  
  # Run the command and capture the output
  output=$(./nmpconfigpoll.vopl $ip_address)
  
  # Check for "Supports SNMP V3" in the output
  if echo "$output" | grep -q "Supports SNMP V3"; then
    echo "$ip_address is successfully added"
    echo "$ip_address is successfully added" >> $log_file
    # If found, proceed to the next IP without waiting
    continue
  fi
  
  # Wait for 1 minute before trying the next IP address
  sleep 60
done < "$ip_file"

echo "All IP addresses processed. Check $log_file for details."
