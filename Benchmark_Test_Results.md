# Linux Disk and Networking Benchmark Tools
July 18th 2018

disk_cpu_test.sh utilizes a pssh-hosts file to run disk and cpu tests in parallel on the hosts listed in pssh-hosts. The script should make new benchmarks in the future easier and quicker to perform. This performs a test with fio as well as a binary called seeker and finally, a cpu tst using sysbench. The output for both tests is stored in logs on the host machines and are brought back to your local machine for review.

net_test.sh is a bit different than disk_test.sh. It is intended that net_test.sh be run with no arguments on one machine and then to run net_test.sh on a sperate machine with an argument of the IP address of the machine in server mode. This will test using qperf and record data on the network connection between the two machines running net_test.sh. A log file for the test is stored on the client machine for review.

Other scripts are included in the repo but are not necesary for running the benchmarks at this time. However, the intention would be to have a run.sh script that simply does everything with little to no user input. But due to time constraints, that implimentation has been put on hold.

---

#  Disk Tests

## Results From Expanse-Cas2 Disk Test

### Fio

```
test: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.1
Starting 1 process

test: (groupid=0, jobs=1): err= 0: pid=2067: Wed Jul 18 17:28:57 2018
   read: IOPS=660, BW=2644KiB/s (2707kB/s)(75.1MiB/29101msec)
   bw (  KiB/s): min= 1664, max= 3336, per=99.90%, avg=2640.26, stdev=280.21, samples=58
   iops        : min=  416, max=  834, avg=660.05, stdev=70.04, samples=58
  write: IOPS=218, BW=875KiB/s (896kB/s)(24.9MiB/29101msec)
   bw (  KiB/s): min=  664, max= 1128, per=99.99%, avg=874.88, stdev=105.98, samples=58
   iops        : min=  166, max=  282, avg=218.69, stdev=26.51, samples=58
  cpu          : usr=0.69%, sys=2.13%, ctx=24369, majf=0, minf=25
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.8%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwt: total=19233,6367,0, short=0,0,0, dropped=0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: bw=2644KiB/s (2707kB/s), 2644KiB/s-2644KiB/s (2707kB/s-2707kB/s), io=75.1MiB (78.8MB), run=29101-29101msec
  WRITE: bw=875KiB/s (896kB/s), 875KiB/s-875KiB/s (896kB/s-896kB/s), io=24.9MiB (26.1MB), run=29101-29101msec

Disk stats (read/write):
    dm-2: ios=20525/6366, merge=0/0, ticks=1866868/447883, in_queue=2316909, util=99.91%, aggrios=20795/6441, aggrmerge=0/8, aggrticks=1877659/451264, aggrin_queue=2326646, aggrutil=99.84%
  sda: ios=20795/6441, merge=0/8, ticks=1877659/451264, in_queue=2326646, util=99.84%
```
### Seeker

```
Seeker v2.0, 2007-01-15, http://www.linuxinsight.com/how_fast_is_your_disk.html
Benchmarking /dev/sda [512000MB], wait 30 seconds.............................
Results: 354 seeks/second, 2.82 ms random access time
```
---

## Results From Capacity-Cas2 Disk Test

### Fio

```
test: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.1
Starting 1 process
test: Laying out IO file (1 file / 100MiB)

test: (groupid=0, jobs=1): err= 0: pid=6246: Wed Jul 18 18:55:09 2018
   read: IOPS=497, BW=1990KiB/s (2038kB/s)(75.1MiB/38663msec)
   bw (  KiB/s): min=  144, max= 3888, per=100.00%, avg=2016.91, stdev=780.31, samples=76
   iops        : min=   36, max=  972, avg=504.20, stdev=195.07, samples=76
  write: IOPS=164, BW=659KiB/s (675kB/s)(24.9MiB/38663msec)
   bw (  KiB/s): min=   56, max= 1272, per=100.00%, avg=666.17, stdev=259.56, samples=76
   iops        : min=   14, max=  318, avg=166.53, stdev=64.89, samples=76
  cpu          : usr=0.52%, sys=0.98%, ctx=21760, majf=0, minf=23
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=99.8%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwt: total=19233,6367,0, short=0,0,0, dropped=0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64
```

### Seeker

```
Seeker v2.0, 2007-01-15, http://www.linuxinsight.com/how_fast_is_your_disk.html
Benchmarking /dev/sda [512000MB], wait 30 seconds.............................
Results: 125 seeks/second, 7.95 ms random access time
```
---

# Expanse Internal Network Test

## Results From Net Test Expanse-Cas2(Server) -> Expanse-Cas1(Client)

### QPERF

```
tcp_bw:
    bw              =     920 MB/sec
    msg_rate        =      14 K/sec
    port            =  19,865
    time            =       5 sec
    timeout         =       5 sec
    send_cost       =     954 ms/GB
    recv_cost       =    2.11 sec/GB
    send_cpus_used  =    87.8 % cpus
    recv_cpus_used  =     194 % cpus
tcp_lat:
    latency        =    71.3 us
    msg_rate       =      14 K/sec
    port           =  19,865
    time           =       5 sec
    timeout        =       5 sec
    loc_cpus_used  =      89 % cpus
    rem_cpus_used  =     100 % cpus
```
---

# Capacity Internal Network Test

## Results From Net Test Capacity-Cas2(Server) -> Capacity-Cas1(Client)

```
tcp_bw:
    bw              =    1.23 GB/sec
    msg_rate        =    18.8 K/sec
    port            =  19,865
    time            =       5 sec
    timeout         =       5 sec
    send_cost       =     356 ms/GB
    recv_cost       =    1.03 sec/GB
    send_cpus_used  =      44 % cpus
    recv_cpus_used  =     127 % cpus
tcp_lat:
    latency        =    37.4 us
    msg_rate       =    26.7 K/sec
    port           =  19,865
    time           =       5 sec
    timeout        =       5 sec
    loc_cpus_used  =    28.4 % cpus
    rem_cpus_used  =    27.6 % cpus
```
---

# Expanse To Capacity Network Test

## Results From Net Test Expanse-Cas2(Server) -> Capacity-Cas2(Client)

```
tcp_bw:
    bw              =    84.3 MB/sec
    msg_rate        =    1.29 K/sec
    port            =  19,865
    time            =       5 sec
    timeout         =       5 sec
    send_cost       =    10.7 sec/GB
    recv_cost       =    4.27 sec/GB
    send_cpus_used  =    90.6 % cpus
    recv_cpus_used  =      36 % cpus
tcp_lat:
    latency        =     126 us
    msg_rate       =    7.93 K/sec
    port           =  19,865
    time           =       5 sec
    timeout        =       5 sec
    loc_cpus_used  =    80.8 % cpus
    rem_cpus_used  =    30.4 % cpus
```

---

# Comparison Between Capacity and Expanse

TODO?
