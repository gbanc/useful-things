#!/bin/bash

# Directory where the log file will be stored
LOG_DIR="$HOME/work_logs"
LOG_FILE="$LOG_DIR/work_hours.log"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Function to log current date and time with a custom message
log_time() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Function to calculate and echo total time spent since the last 'start'
calculate_and_echo_total() {
    # Extract the last start time
    start_time=$(grep "Work started" "$LOG_FILE" | tail -1 | awk '{print $1, $2}')

    # Current time
    end_time=$(date '+%Y-%m-%d %H:%M:%S')

    # Calculate total time using date command
    start_sec=$(date -d "$start_time" +%s)
    end_sec=$(date -d "$end_time" +%s)
    total_sec=$((end_sec - start_sec))
    
    # Convert total seconds to hours, minutes, and seconds
    ((h=total_sec/3600))
    ((m=(total_sec%3600)/60))
    ((s=total_sec%60))

    # Echo total time
    echo "Total Time: $h hour(s) $m minute(s) $s second(s)"
}

# Main script logic
case "$1" in
    start)
        log_time "Work started"
        ;;
    end)
        log_time "Work ended"
        calculate_and_echo_total # Echo the total time since the last 'start'
        ;;
    endblock)
        log_time "End of time block"
        ;;
    total)
        calculate_and_echo_total # Separate option to just calculate and echo the total without logging 'end'
        ;;
    *)
        echo "Usage: $0 {start|end|endblock|total}"
        exit 1
        ;;
esac
