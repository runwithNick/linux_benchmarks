#!/bin/bash

# NOTES AND GENERAL INFO
# REQUIRES PSSH (Parallel SSH)
# sudo apt install pssh

# REQUIRES fio
# sudo apt-get install fio

# CONFIGURABLES
# testSize="100M"

# config
RUNAS=invidi
TARGETHOME=/home/invidi

# Hosts are defined in the pssh-hosts file

err_handler()
{
    echo "ERROR on line $1"
    exit 1
}
trap 'err_handler $LINENO' ERR

mkdir -p logs
mkdir -p logs/seekerLogs
mkdir -p logs/cpuLogs
mkdir -p logs/errors
mkdir -p logs/errors/parallel-scp
mkdir -p logs/errors/pssh

echo "Starting Disk Test ... "
echo ""

filename=pssh-hosts
MACHINES=`cat ${filename}`

echo "Running Networked Disk Test ... "
echo ""
echo "Participating Servers:"
for MACHINE in $MACHINES ; do
    echo $MACHINE
done
echo ""

# make directories
echo "Making directories ..."
#pssh -e "logs/errors/pssh" -i -t 300 -O StrictHostKeyChecking=no -h pssh-hosts -l $RUNAS -A 'HOSTNAME=`hostname` ; mkdir -p benchmarking; cd benchmarking'
pssh -e "logs/errors/pssh" -i -t 300 -O StrictHostKeyChecking=no -h pssh-hosts -l $RUNAS -A 'HOSTNAME=`hostname` ; mkdir -p benchmarking; cd benchmarking'
echo "... Done"
echo ""

# Parallel SCP seeker binary to all participating machines
echo "Sending latesting Seeker binary to machines ... "
parallel-scp -e "logs/errors/parallel-scp" -v -t 300 -h pssh-hosts -l $RUNAS -A "seeker" "${TARGETHOME}/benchmarking/seeker"
echo "... Done"
echo ""

# Using PSSH navigate to benchmarking directory,
# do fio test
# then scp resulting log file back to logs directory.
# do seeker test, then get log back to logs/seekerLogs
echo "Install sysbench then -> Running fio, seeker, and sybench cpu tests on machines ... "
pssh -e "logs/errors/pssh" -i -t 300 -O StrictHostKeyChecking=no -h pssh-hosts -l $RUNAS -A 'sudo yum -y install sysbench; HOSTNAME=`hostname` ; cd benchmarking; fio -randrepeat=1 -ioengine=libaio -direct=1 -gtod_reduce=1 -name=test -filename=test -iodepth=64 -size=100M --readwrite=randrw --rwmixread=75 > ${HOSTNAME}.log; mkdir -p seekerLogs; sudo ./seeker /dev/sda > seekerLogs/${HOSTNAME}.log; numCores=`grep -c ^processor /proc/cpuinfo`; mkdir -p cpuLogs; sysbench --test=cpu --num-threads="$numCores" run > cpuLogs/${HOSTNAME}.log'
echo "... Done"
echo ""

# for each MACHINE in MACHINES, scp the .log file back
for MACHINE in $MACHINES ; do
    echo ""
    echo "SCP fio log from $MACHINE"
    scp -r "${RUNAS}@$MACHINE":benchmarking/*.log logs/$MACHINE.log
    echo "SCP seeker log from $MACHINE"
    scp -r "${RUNAS}@${MACHINE}":benchmarking/seekerLogs/*.log logs/seekerLogs/$MACHINE.log
		echo "SCP cpu log from $MACHINE"
		scp -r "${RUNAS}@${MACHINE}":benchmarking/cpuLogs/*.log logs/cpuLogs/$MACHINE.log
    echo ""
done

printf "\n\nSUMMARY"

# PRINTING RESULTS
for MACHINE in $MACHINES ; do
	echo ""
	echo "========"
	printf "\n$MACHINE\n"
	echo ""
	echo "   *** fio ***"
	cat logs/$MACHINE.log
	echo ""
	echo "   *** seeker ***"
	cat logs/seekerLogs/$MACHINE.log
	echo ""
	echo "   *** cpu ***"
	cat logs/cpuLogs/$MACHINE.log
	echo ""
	echo "--------"
	echo ""
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
