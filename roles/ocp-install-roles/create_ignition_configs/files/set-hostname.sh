#!/bin/bash

# Get own IP address
address=$(ip -o addr show up scope global | awk '{ print $4 }' | cut -d/ -f1)

echo "IP address: ${address}"

# Get hostname using reverse lookup
name=$(dig -x ${address} +short | sed 's/\.$//')

echo "Hostname: ${name}"

# Set hostname
hostnamectl set-hostname --static ${name}

