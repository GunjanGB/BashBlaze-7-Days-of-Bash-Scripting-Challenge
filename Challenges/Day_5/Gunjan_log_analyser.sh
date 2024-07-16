#!/bin/bash

log_file=$1

# Check if the log file exists
if [ ! -f "$log_file" ]; then
    echo "Log file not found!"
    exit 1
fi

# Variables
timestamp=$(date '+%Y-%m-%d %H:%M:%S')
report_file="log_summary_$(date '+%Y%m%d').txt"
error_keyword="ERROR"
critical_keyword="CRITICAL"

# Error Count
error_count=$(grep -c "$error_keyword" "$log_file")

# Critical Events
critical_events=$(grep -n "$critical_keyword" "$log_file")

# Top 5 Error Messages
declare -A error_messages
while read -r line; do
    if [[ "$line" == *"$error_keyword"* ]]; then
        error_message=$(echo "$line" | awk -F"$error_keyword" '{print $2}')
        ((error_messages["$error_message"]++))
    fi
done < "$log_file"

# Sort and get top 5 error messages
top_errors=$(for key in "${!error_messages[@]}"; do echo "${error_messages[$key]} $key"; done | sort -rn | head -5)

# Summary Report
total_lines=$(wc -l < "$log_file")
{
    echo "Log Analysis Report - $timestamp"
    echo "Log File: $log_file"
    echo "Total Lines Processed: $total_lines"
    echo "Total Error Count: $error_count"
    echo
    echo "Top 5 Error Messages:"
    echo "$top_errors"
    echo
    echo "Critical Events:"
    echo "$critical_events"
} > "$report_file"

# Print the report location
echo "Summary report generated: $report_file"

# Optional: Move the log file to an archive directory
archive_dir="./archive"
mkdir -p "$archive_dir"
mv "$log_file" "$archive_dir"

echo "Log file archived to: $archive_dir"
