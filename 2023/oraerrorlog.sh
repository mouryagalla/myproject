#!/bin/bash

# Define the path to the Oracle alert log file
ALERT_LOG_FILE=/path/to/alert.log

# Define the Telegraf InfluxDB Line Protocol output file
OUTPUT_FILE=/path/to/output.txt

# Define the metric name and tags for the alert log errors
METRIC_NAME=oracle_alert_log_errors
TAGS="type=alert_log"

# Filter the alert log file for error messages and output the metrics in the InfluxDB Line Protocol format
grep -E 'ORA-|error|failed' $ALERT_LOG_FILE | while read line; do
  timestamp=$(date -d "$(echo $line | awk '{print $1" "$2}')" +%s%N)
  message=$(echo $line | sed -e 's/"/\\"/g' -e 's/\//\\\//g')
  echo "${METRIC_NAME},${TAGS} message=\"${message}\" ${timestamp}" >> $OUTPUT_FILE
done