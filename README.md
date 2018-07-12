# linux_benchmarks
Contains  benchmarking scripts.

## net_test.sh
Benchmarks network performance between two linux devices.
Run the script with no arguments to run it in server mode. Then run the script on your device with the IP address of the machine running the script ins erver mode. This will initalize a connection and run the benchmark for the conenction between the two machines.

## disk_test.sh
Benchmarks disk performance on list of linux servers in parallel.
Server lsits defined in pssh-hosts file.
Simply run the script and enter passwords as required.
You can have as many servers in the pssh-hosts file as you want to test. Although, since this is meant for invidi expanse servers, it has not been extensively tested outside of expanse.
