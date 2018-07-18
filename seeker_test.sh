#!/bin/bash

mkdir -p logs/seekerLogs

echo "Starting Disk Test ... "
echo ""

# Run seeker test
sudo ./seeker /dev/sda
