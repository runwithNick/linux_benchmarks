#!/bin/bash

# Use sysbench to benchmark cpu
# sudo apt-get install sysbench

# Get number of cores in cpu
numCores=`grep -c ^processor /proc/cpuinfo`

sysbench --test=cpu --num-threads="$numCores" run
