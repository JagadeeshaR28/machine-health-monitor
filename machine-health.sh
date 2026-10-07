#!/usr/bin/env bash

# Machine Health Monitor
# Monitors CPU, Memory, and Disk usage.
# Threshold: 60%
# Usage:
#   ./machine-health.sh
#   ./machine-health.sh explain

THRESHOLD=60

# Get CPU usage
# On Ubuntu, top provides idle percentage. We calculate busy %.
cpu_idle=$(top -bn1 | awk '/^%Cpu/ {print $8}' | tail -n 1)
cpu_usage=$(awk -v idle="$cpu_idle" 'BEGIN { printf "%.0f", 100 - idle }')

# Get Memory usage
mem_usage=$(free | awk '/^Mem:/ {printf "%.0f", ($3/$2)*100}')

# Get Disk usage for root filesystem
disk_usage=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

# Determine overall health
status="healthy"
reasons=()

if [ "$cpu_usage" -ge "$THRESHOLD" ]; then
    status="unhealthy"
    reasons+=("CPU usage is ${cpu_usage}% (threshold: ${THRESHOLD}%)")
fi

if [ "$mem_usage" -ge "$THRESHOLD" ]; then
    status="unhealthy"
    reasons+=("Memory usage is ${mem_usage}% (threshold: ${THRESHOLD}%)")
fi

if [ "$disk_usage" -ge "$THRESHOLD" ]; then
    status="unhealthy"
    reasons+=("Disk usage is ${disk_usage}% (threshold: ${THRESHOLD}%)")
fi

# No parameter => print only healthy/unhealthy
if [ "$#" -eq 0 ]; then
    echo "$status"
    exit 0
fi

# Explain mode
if [ "$1" = "explain" ]; then
    echo "Machine health status: $status"

    if [ "$status" = "healthy" ]; then
        echo "CPU usage: ${cpu_usage}%"
        echo "Memory usage: ${mem_usage}%"
        echo "Disk usage: ${disk_usage}%"
        echo "Reason: All monitored resources are below the 60% threshold, so the machine is healthy."
    else
        echo "CPU usage: ${cpu_usage}%"
        echo "Memory usage: ${mem_usage}%"
        echo "Disk usage: ${disk_usage}%"
        echo "Reason:"
        for reason in "${reasons[@]}"; do
            echo " - $reason"
        done
    fi
else
    echo "Usage: $0 [explain]"
    exit 1
fi
