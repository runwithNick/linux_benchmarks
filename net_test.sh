#!/bin/bash

# variables
# is there a firewall and firewall-cmd
FIREWALL=0
# Path to qperf
qperf=qperf-0.4.9/src/qperf

err_handler()
{
    echo "ERROR on line $1"
    exit 1
}
trap 'err_handler $LINENO' ERR


# Checking for install of qperf
if [ -z $qperf ] ; then
	echo "qperf needs to be isntalled!"
	exit 1
fi

# Handle too many args error (should only accept 0 or 1 args.)
if [ $# -gt 1 ]; then
	printf "Too Many Input Arguments ... \n"
	printf "Enter 0 arguments for server mode, or an IP address.\n"
	exit 1
fi

# CONFIGURABLES

# Provide more detailed output (Default true)
verbose=true

# Set how long to run the test (Default 30 seconds)
time=5

# Set timeout. This is the timeout used for various things
# such as exchanging messages. (Default 5 seconds)
timeout=5

# Set port for socket tests (Default 19865)
socketPort=19865

# Set port for listening (Default 19765)
listenPort=19765

# qperf uses port 19765 by default for listening.
# This must be set to the same port on both the server and client machines.

if [ $FIREWALL -gt 0 ] ; then
    # ADDING PORTS TO FIREWALL FOR 1 HOUR
    printf "\nAdding port 19765 for 10 minutes ... "
    sudo firewall-cmd --add-port=19765/tcp --timeout=1h
    printf "\nAdding port 19865 for 10 minutes ... "
    sudo firewall-cmd --add-port=19865/tcp --timeout=1h
fi

# When the script is run in server mode, the device begins to listen
# for other devices to begin a test.

# Example: Cassandra1 could run in server mode and on Cassandra 2
# you can add the argument which is the IP address of Cassandra 1.
# This would test the connection between Cassandra1 and Cassandra 2.


if [ $# -eq 0 ]; then
	# IF THERE IS NO INPUT ARGS, USE SERVER MODE
	printf "\nStarting qperf in server mode ...\n"
	$qperf
elif [ $# -eq 1 ]; then
	# IF THERE IS 1 INPUT ARG, USE QPERF NORMALLY.
	IP=$1
	printf "\n\nRunning qperf on IP: $IP ...\n\n"
	# IF VERBOSE IS TRUE, SHOW DETAILED OUTPUT
	if [ $verbose ]; then
		"$qperf" -to "$timeout" -t "$time" -ip "$socketPort" -lp "$listenPort" -v "$IP" tcp_bw tcp_lat | tee net_test_results.log
	else
		"$qperf" -to "$timeout" -t "$time" -ip "$socketPort" -lp "$listenPort" "$IP" tcp_bw tcp_lat | tee net_test_results.log
	fi
	echo "... Done"
fi
