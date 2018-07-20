# linux_benchmarks

July 18th 2018

## disk_test.sh

disk_cpu_test.sh utilizes a pssh-hosts file to run disk and cpu tests in parallel on the hosts listed in pssh-hosts. The script should make new benchmarks in the future easier and quicker to perform. This performs a test with fio as well as a binary called seeker and finally, a cpu tst using sysbench. The output for both tests is stored in logs on the host machines and are brought back to your local machine for review

## net_test.sh

net_test.sh is a bit different than disk_test.sh. It is intended that net_test.sh be run with no arguments on one machine and then to run net_test.sh on a sperate machine with an argument of the IP address of the machine in server mode. This will test using qperf and record data on the network connection between the two machines running net_test.sh. A log file for the test is stored on the client machine for review.

## other

Other scripts are included in the repo but are not necesary for running the benchmarks at this time. However, the intention would be to have a run.sh script that simply does everything with little to no user input. But due to time constraints, that implimentation has been put on hold.
