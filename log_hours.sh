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

# Function to calculate and echo total time based on start/end pairs
calculate_and_echo_total() {
    local total_sec=0
    local start_time=""
    local end_time=""
    local in_session=false

    while IFS= read -r line; do
        if [[ "$line" =~ "Work started" ]]; then
            start_time=$(echo "$line" | awk '{print $1, $2}')
            in_session=true
        elif [[ "$line" =~ "Work ended" ]] && [ "$in_session" = true ]; then
            end_time=$(echo "$line" | awk '{print $1, $2}')
            start_sec=$(date -d "$start_time" +%s)
            end_sec=$(date -d "$end_time" +%s)
            total_sec=$((total_sec + (end_sec - start_sec)))
            in_session=false
        fi
    done < "$LOG_FILE"

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
        ;;
    total)
        calculate_and_echo_total
        ;;
    *)
        echo "Usage: $0 {start|end|total}"
        exit 1
        ;;
esac

