#!/bin/bash

# Define the port and protocol
PORT=4819
PROTOCOL="udp"

# List of IPs to whitelist
IP_LIST=(
    "79.137.101.98"
    "162.19.222.232"
    "189.1.164.31"
    "3.9.174.157"
    "54.162.30.129"
    "3.8.200.214"
    "100.27.66.148"
    "64.130.50.156"
    "146.0.74.196"
    "57.128.187.41"
    "51.89.173.125"
    "135.125.118.29"
    "40.160.13.196"
    "135.125.160.174"
    "15.204.101.122"
    "146.59.118.160"
    "148.113.187.118"
    "198.244.253.217"
    "72.251.3.176"
    "162.19.103.96"
    "135.125.119.131"
    "45.63.0.240"
    "45.32.232.230"
    "57.129.76.214"
)

# Enable UFW if it is not already enabled
if ! sudo ufw status | grep -q "Status: active"; then
    echo "UFW is not enabled. Enabling UFW..."
    sudo ufw enable
fi

# Function to remove existing rules for the specified port
remove_existing_rules() {
    echo "Removing existing rules for port $PORT/$PROTOCOL..."
    sudo ufw status numbered | grep "$PORT/$PROTOCOL" | awk '{print $1}' | sort -rn | while read -r rule_number; do
        sudo ufw --force delete $rule_number
    done
}

# Function to whitelist IPs
whitelist_ips() {
    for IP in "${IP_LIST[@]}"; do
        # Check if rule already exists
        if ! sudo ufw status | grep -q "$IP.*$PORT/$PROTOCOL"; then
            echo "Whitelisting IP: $IP for port $PORT/$PROTOCOL"
            sudo ufw allow from "$IP" to any port "$PORT" proto "$PROTOCOL"
        else
            echo "IP $IP is already whitelisted for port $PORT/$PROTOCOL"
        fi
    done
}

# Remove existing rules
remove_existing_rules

# Apply whitelist
whitelist_ips

# Reload UFW to apply changes
sudo ufw reload

echo "Whitelist update complete!"
