#!/bin/bash

# Go through each log set in logs/_Completed_Runs
# For example, go into _capacity_result_1
# Create metrics for cpuLogs, then fioLogs, then netTest Logs, then seekerLogs.
# Do that for all completed runs.

# This should be the directory where the logs directory begins.
HOMEDIR=~/Desktop/linux_benchmarks

# Go into first capacity run
cd ${HOMEDIR}/logs/_Completed_Runs/_capacity_results_1
RUNTYPE=`basename "$PWD" | cut -f1 -d":" | tr -d '[_]'`

Data=""

# METRICS FOR CPULOGS
# go into cpuLogs
cd cpuLogs

# ----- CPU DATA -----
LOGTYPE=`basename "$PWD"`

#Get events per second
METRICNAME=`grep -i "events per second" capacity-cas1.invidi.com.log | cut -f1 -d":" | tr -d '[:space:]'`
METRICNAME="bench.${RUNTYPE}.${LOGTYPE}.${METRICNAME}"
echo $METRICNAME
metricDataPoint=`grep -i "events per second" capacity-cas1.invidi.com.log | cut -d: -f2- | tr -d '[:space:]'`
Data="${Data} ${METRICNAME} ${metricDataPoint}"$'\n'
#echo $Data

#Get total time
METRICNAME=`grep -i "total time" capacity-cas1.invidi.com.log | cut -f1 -d":" | tr -d '[:space:]'`
METRICNAME="bench.${RUNTYPE}.${LOGTYPE}.${METRICNAME}"
echo $METRICNAME
metricDataPoint=`grep -i "total time" capacity-cas1.invidi.com.log | cut -d: -f2- | tr -d '[:space:]' | sed '$ s/.$//'`
Data="${Data} ${METRICNAME} ${metricDataPoint}"$'\n'
#echo $Data

#Get total number of events
METRICNAME=`grep -i "total number of events" capacity-cas1.invidi.com.log | cut -f1 -d":" | tr -d '[:space:]'`
METRICNAME="bench.${RUNTYPE}.${LOGTYPE}.${METRICNAME}"
echo $METRICNAME
metricDataPoint=`grep -i "total number of events" capacity-cas1.invidi.com.log | cut -d: -f2- | tr -d '[:space:]'`
Data="${Data} ${METRICNAME} ${metricDataPoint}"$'\n'
#echo $Data

#Get Latency min
METRICNAME=`grep -i "min" capacity-cas1.invidi.com.log | cut -f1 -d":" | tr -d '[:space:]'`
METRICNAME="bench.${RUNTYPE}.${LOGTYPE}.latency${METRICNAME}"
echo $METRICNAME
metricDataPoint=`grep -i "min" capacity-cas1.invidi.com.log | cut -d: -f2- | tr -d '[:space:]'`
Data="${Data} ${METRICNAME} ${metricDataPoint}"$'\n'
#echo $Data

#Get Latency avg
METRICNAME=`grep -i "avg:" capacity-cas1.invidi.com.log | cut -f1 -d":" | tr -d '[:space:]'`
METRICNAME="bench.${RUNTYPE}.${LOGTYPE}.latency${METRICNAME}"
echo $METRICNAME
metricDataPoint=`grep -i "avg:" capacity-cas1.invidi.com.log | cut -d: -f2- | tr -d '[:space:]'`
Data="${Data} ${METRICNAME} ${metricDataPoint}"$'\n'
#echo $Data

#Get Latency max
METRICNAME=`grep -i "max" capacity-cas1.invidi.com.log | cut -f1 -d":" | tr -d '[:space:]'`
METRICNAME="bench.${RUNTYPE}.${LOGTYPE}.latency${METRICNAME}"
echo $METRICNAME
metricDataPoint=`grep -i "max" capacity-cas1.invidi.com.log | cut -d: -f2- | tr -d '[:space:]'`
Data="${Data} ${METRICNAME} ${metricDataPoint}"$'\n'
#echo $Data

#Get Latency 95th percentile
METRICNAME=`grep -i "95th percentile" capacity-cas1.invidi.com.log | cut -f1 -d":" | tr -d '[:space:]'`
METRICNAME="bench.${RUNTYPE}.${LOGTYPE}.latency${METRICNAME}"
echo $METRICNAME
metricDataPoint=`grep -i "95th percentile" capacity-cas1.invidi.com.log | cut -d: -f2- | tr -d '[:space:]'`
Data="${Data} ${METRICNAME} ${metricDataPoint}"$'\n'
#echo $Data

#Get Latency sum
METRICNAME=`grep -i "sum" capacity-cas1.invidi.com.log | cut -f1 -d":" | tr -d '[:space:]'`
METRICNAME="bench.${RUNTYPE}.${LOGTYPE}.latency${METRICNAME}"
echo $METRICNAME
metricDataPoint=`grep -i "sum" capacity-cas1.invidi.com.log | cut -d: -f2- | tr -d '[:space:]'`
Data="${Data} ${METRICNAME} ${metricDataPoint}"$'\n'
#echo $Data

#Get Threads fairness events
METRICNAME=`grep -i "events (avg" capacity-cas1.invidi.com.log | cut -f1 -d":" | tr -d '[:space:]' | cut -f1 -d":" | tr -d '[/stdde]'`
METRICNAME="bench.${RUNTYPE}.${LOGTYPE}.threadsfairness${METRICNAME}"
echo $METRICNAME
metricDataPoint=`grep -i "events (" capacity-cas1.invidi.com.log | cut -d: -f2- | tr -d '[:space:]'`
Data="${Data} ${METRICNAME} ${metricDataPoint}"$'\n'
#echo $Data

#Get Threads fairness eexecution time
METRICNAME=`grep -i "execution time" capacity-cas1.invidi.com.log | cut -f1 -d":" | tr -d '[:space:]'`
METRICNAME="bench.${RUNTYPE}.${LOGTYPE}.threadsfairness${METRICNAME}"
echo $METRICNAME
metricDataPoint=`grep -i "execution time" capacity-cas1.invidi.com.log | cut -d: -f2- | tr -d '[:space:]'`
Data="${Data} ${METRICNAME} ${metricDataPoint}"$'\n'
#echo $Data
