

# SCP QPERF and net_test.sh to all machines to prepare machines to be sued in net_test.sh

# config
RUNAS=invidi
TARGETHOME=/home/invidi
#RUNAS=capacity
#TARGETHOME=/home/capacity

# Hosts are defined in the pssh-hosts file

# make directories
echo "Making directories ..."
pssh -e "logs/errors/pssh" -i -t 900 -O StrictHostKeyChecking=no -h pssh-hosts -l $RUNAS -A 'mkdir -p benchmarking; cd benchmarking'
echo "... Done"
echo ""

# install qperf on machines
echo ""
echo "Distributing QPERF to Machines ..."
parallel-scp -v -t 300 -h pssh-hosts -l $RUNAS -A -r "qperf-0.4.9" "${TARGETHOME}/benchmarking/qperf-0.4.9"
echo "... Done"
echo ""

echo ""
echo "Distributing net_test.sh to Machines ..."
parallel-scp -v -t 300 -h pssh-hosts -l $RUNAS -A "net_test.sh" "${TARGETHOME}/benchmarking/net_test.sh"
echo "... Done"
echo ""
