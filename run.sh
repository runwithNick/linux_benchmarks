#!/bin/bash

# probably best to run with sudo

# This file sets up and runs net_test.sh in server mode on a machine and then tests with the local machine.
# Next disk_test.sh is run.
# Lastly, seeker test is done on the local machine.


echo "NET TEST START ... "
echo ""
# net_test.sh server mode
# Ask user for IP address input
# echo "Enter the IP address or hostname of the machine you wish to run the net_test server: "
# read net_test_server_ip

# Setting IP to cas1 for quick testing
net_test_server_ip="expanse-cas1.invidi.com"

# Deliver required files for net_test to inputed IP.
echo "Delivering latest version of net_test.sh and qperf-0.4.9"
scp -r ~/Desktop/linux_benchmarks/qperf-0.4.9 ~/Desktop/linux_benchmarks/net_test.sh "invidi@$net_test_server_ip":~/benchmarking

# Start server on IP provided
ssh -n -f "invidi@$net_test_server_ip" "sh -c 'cd benchmarking; nohup source net_test.sh > /dev/null 2>&1 &'"

# Start net_test from local machine and connect with IP provided
echo ""
echo "net_test in progress ... "
source net_test.sh $net_test_server_ip
echo ""
echo "NET TEST END"
printf "\n\n\n"
# NET TEST ENDS HERE




# Do disk test
echo "DISK TEST START ...  "
echo ""
source disk_test.sh
echo ""
echo "DISK TEST END"
