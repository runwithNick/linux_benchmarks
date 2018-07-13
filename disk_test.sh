#!/bin/bash

# NOTES AND GENERAL INFO
# REQUIRES PSSH (Parallel SSH)
# sudo apt install pssh

# REQUIRES fio
# sudo apt-get install fio

# CONFIGURABLES
# testSize="100M"

# Hosts are defined in the pssh-hosts file

mkdir -p logs
mkdir -p logs/seekerLogs
mkdir -p logs/errors
mkdir -p logs/errors/parallel-scp
mkdir -p logs/errors/pssh

echo "Starting Disk Test ... "
echo ""

filename=pssh-hosts
MACHINES=""
totalMachines=0

# Read pssh-hosts in
while read -r line; do
	let "totalMachines++"
	MACHINES="$MACHINES $line"
done < "$filename"

# If you want to only run a local test, add the -l flag.
if [ "$1" == "-l" ]; then
	# Run Fio test
	echo "Running Local Disk Test ... "
	echo ""
	echo "Results:"
	fio -randrepeat=1 -ioengine=libaio -direct=1 -gtod_reduce=1 -name=test -filename=test -iodepth=64 -size=100M --readwrite=randrw --rwmixread=75 | awk '/sda/' | tee logs/LocalMachine.log
	echo ""
	echo "... Done"
	# Run seeker test
	echo "Running Local Seeker Disk Test ... "
	echo ""
	sudo ./seeker /dev/sda | awk '/Results/' | tee logs/seekerLogs/LocalMachine.log
	echo ""
	echo "... Done"
	exit 1
fi

# If local flag is not present, then perform networked disk test.
if [ "$1" != "-l" ]; then
	echo "Running Networked Disk Test ... "
	echo ""
	echo "Participating Servers:"
	for MACHINE in $MACHINES ; do
		echo $MACHINE
	done
	echo "TOTAL: $totalMachines"
	echo ""

	# Parallel SCP seeker binary to all participating machines
	echo "Sending latesting Seeker binary to machines ... "
	parallel-scp -e "/errors/parallel-scp" -v -t 300 -h pssh-hosts -l invidi -A "~/Desktop/linux_benchmarks/seeker" "/home/invidi/benchmarking/seeker"
	echo "... Done"
	# Using PSSH navigate to benchmarking directory,
	# install fio
	# do fio test
	# then scp resulting log file back to ~/Desktop/benchmarking directory.
	echo "Running fio and seeker tests on machines ... "
	pssh -e "/errors/pssh" -i -t 300 -O StrictHostKeyChecking=no -h pssh-hosts -l invidi -A 'mkdir -p benchmarking; cd benchmarking; fio -randrepeat=1 -ioengine=libaio -direct=1 -gtod_reduce=1 -name=test -filename=test -iodepth=64 -size=100M --readwrite=randrw --rwmixread=75 | awk "/sda/" > `hostname`.log; mkdir -p seekerLogs; cd seekerLogs; sudo ./seeker /dev/sda | awk "/Results/" > seekerLogs/`hostname`.log'
	echo "... Done"
	# for each MACHINE in MACHINES, scp the .log file back
	for MACHINE in $MACHINES ; do
		echo ""
		echo "SCP fio log from $MACHINE"
		scp "invidi@$MACHINE":~/benchmarking/*.log ~/Desktop/linux_benchmarks/logs/$MACHINE.log
		echo "SCP seeker log from $MACHINE"
		scp "invidi@$MACHINE":~/benchmarking/seekerLogs*.log ~/Desktop/linux_benchmarks/logs/seekerLogs/$MACHINE.log
		echo ""
	done

	# Afterwards, do a local test.
	# Test Sequential Read/Write (75% read) on local machine.
	fio -randrepeat=1 -ioengine=libaio -direct=1 -gtod_reduce=1 -name=test -filename=test -iodepth=64 -size=100M --readwrite=randrw --rwmixread=75 | awk '/sda/' > logs/LocalMachine.log
fi

printf "\n\nSUMMARY"

# PRINTING RESULTS
printf "\n`hostname`\n"
local_test_result=`awk -F',' '{ print }' logs/LocalMachine.log`
printf "%s\n" "$local_test_result"

for MACHINE in $MACHINES ; do
	printf "\n$MACHINE\n"
	test_result_fio=`awk -F',' '{ print }' logs/$MACHINE.log`
	test_result_seeker=`awk -F',' '{ print }' logs/seekerLogs/$MACHINE.log`
	printf "%s\n" "$test_result"
done

echo ""
echo "... Done"
# hostname notes
# expanse-bdms.invidi.com has different login credentials

# expanse-etl.invidi.com
# expanse-etl2.invidi.com
# expanse-jetty.invidi.com
# expanse-jetty2.invidi.com
# expanse-metrics.invidi.com
# expanse-nlb.invidi.com
# expanse-cas1.invidi.com
# expanse-cas2.invidi.com
# expanse-cas3.invidi.com
# expanse-cas4.invidi.com
# expanse-cas5.invidi.com
# expanse-cas6.invidi.com
