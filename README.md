# linux_benchmarks

Nicholas Borle
July 23rd 2018

## disk_cpu_test.sh

disk_cpu_test.sh utilizes a pssh-hosts file to run disk and cpu tests in parallel on the hosts listed in pssh-hosts. The script should make new benchmarks in the future easier and quicker to perform. This performs a test with fio as well as a binary called seeker and finally, a cpu tst using sysbench. The output for both tests is stored in logs on the host machines and are brought back to your local machine for review

## net_test.sh

net_test.sh is a bit different than disk_test.sh. It is intended that net_test.sh be run with no arguments on one machine and then to run net_test.sh on a sperate machine with an argument of the IP address of the machine in server mode. This will test using qperf and record data on the network connection between the two machines running net_test.sh. A log file for the test is stored on the client machine for review.

## other

Other scripts are included in the repo but are not necesary for running the benchmarks at this time. However, the intention would be to have a run.sh script that simply does everything with little to no user input. But due to time constraints, that implimentation has been put on hold.

## Walthrough for performing a benchmark

The net_test or disk_cpu_test scripts can be run independently of each other and do not rely on eachother. But for the purpose of this example walkthrough, I will begin an outline starting with the net_test.

When I did the benchmark tests, I had a directory called "benchmarking" where all the files and directories I was working with lived. I would recommend the same idea. Although, the only script that relies on that directory structure is the disk_cpu_test. That script will automatically create the correct file structure inside the benchmarking directory. As well, the disk_cpu_test script will create the benchmarking directory on all the hosts that it connects with to perform the benchmarking. (More detail on disk_cpu_test.sh later)

### Using the net_test.sh script

The net test uses qperf to perform the network test which is included in the top directory in the qperf-0.4.9 directory. Otherwise, you can get qperf yourself from other sources and modify the path to qperf defiend at the top of the script.

To begin a network test between two machines, each machine will need to have the net_test.sh script and qperf. It is intended that one machine runs net_test.sh with no arguments, putting it into "server mode", and the other machine runs the script with one argument, which is the IP address or hostname of the machine running server mode. For example, if we wanted to test the network conenction between expanse-cas1.invidi.com and expanse-jetty.invidi.com, we could run the script in server mode on either machine, and then use the hostname of the non-server machine to conenct and run the test. The machine that is not running server mode is the machine that shows the output of the test. The output is shown in the terminal as well as saved to net_test_results.log.

When I performed the benchmarks myself, I foudn that it was simple to just copy the contents shown in the terminal over to my local machine and save all the log files myself to review later. I had palnned to setup a portion of the script to automatically collect all the net test logs, but time constraints forced me to put that on hold for this particular script.

Another note on running net_test.sh, I found that some machines on capacity or expanse (not sure which ones exactly) use firewall-cmd. On the machines in which that is enabled, you will have to uncomment the lines `# sudo firewall-cmd --add-port=19765/tcp --timeout=10m` and `# sudo firewall-cmd --add-port=19865/tcp --timeout=10m`. This is line 52 and 54. I also found that sometimes the net_test would simply not connect for reasons I could not identify. I suppose that some bugs exist that I haven't been able to identify or solve.

### Using the disk_cpu_test.sh script

This script is a lot more automated than the previous, which is very important in my opinion because of the large amount of log files that can accumulate. The amount of log files you can expect to to get back from disk_cpu_test.sh is 3*(number of machines).

To get started, you will need to have the disk_cpu_test.sh script, the pssh-hosts file, and the seeker binary file on your local machine in the same directory. Also, you will need to have pssh installed on your machine. `apt-get install pssh` or `yum --enablerepo=epel -y install pssh`

You will need to specify which machines you want to perform the benchmark on. You can add or remove as many machines as you would like in the pssh-hosts file. An example of what the pssh-host file could contain would be as follows:
```
capacity-cas1.invidi.com
capacity-cas2.invidi.com
capacity-cas3.invidi.com
capacity-cas4.invidi.com
capacity-cas5.invidi.com
capacity-cas6.invidi.com
capacity-jetty.invidi.com
```
In this case, all of the cassandra machines and the jetty machine on capacity will be tested by the script. I should also note that you should only add machines that have the same password, in the above case it is capacity. This is because alot fo the script will use ssh in parallel to improve runtime and sends the same password to all servers. If you added a machine from expanse to the above list, it would fail if you entered the password for capacity. Perhaps this could be improved in the future. With that in mind, I would recomend copying the password that you will need to enter to the clipboard so you can paste it in the terminal for the next part.

Once you have all the machines you want to test in the pssh-hosts files, you can simply run the disk_cpu_test.sh script. You will be prompted for your password several times. The script will go through and perform several operations. First, it will pssh to all the machines to create the benchmarking directory, then it will parallel-scp the seeker binary to each machine. At this point, the script will pssh a bunch of commands over to each machine to run. These commands include installing sysbench and fio using yum if they are not installed, making log directories to store correct logs, and actually running the fio, seeker and sysbench tests. fio and seeker are for measuring disk performance and sysbench is used for measuring cpu performance. The corresponding log files for each test are stored in their respective directories. Lastly, the script uses scp to bring back all of the log files to your local machine and pouts them in an organized directory structure for review.

The most annoying part of this script would be how many times you will have to enter the password. Hopeully, in the future this can be changed. But once the script terminates, you should have a bunch of log files to review on your local machine.
