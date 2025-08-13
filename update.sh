#!/bin/bash
#
# DESCRIPTION:
# A script to perform system updates and health checks for Debian-based systems.
# Designed to be run periodically via cron.
#
# USAGE:
# ./update.sh
# It's recommended to run this script with sudo privileges for system updates.
#
# AUTHOR: Shawn Falconbury
# CREATED: 01 June 2021
# REVISED: 29 June 2025

# --- Configuration ---
# Exit immediately if a command exits with a non-zero status.
set -e
# Treat unset variables as an error when substituting.
set -u
# Pipelines return the exit status of the last command to exit with a non-zero status,
# or zero if no command exited with a non-zero status.
set -o pipefail

# --- Variables ---
LOG_DIR=~/logs/update
# Use a more standard ISO 8601 date format.
LOG_FILE="${LOG_DIR}/update-check-$(date +"%Y-%m-%d").log"

# --- Functions ---

# Function to log messages with a timestamp.
log() {
    # Appends a timestamp to the message and writes to the log file.
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $*"
}

# Function to create a section header in the log.
log_header() {
    log "----------------------------------------------------------------------"
    log "$1"
    log "----------------------------------------------------------------------"
}

# Ensure log directory exists
setup_logging() {
    if [ ! -d "${LOG_DIR}" ]; then
        echo "Creating log directory at ${LOG_DIR}"
        mkdir -p "${LOG_DIR}"
    fi
}

# Perform system health checks (disk, memory, network).
perform_system_health_checks() {
    log_header "File System Check"
    df -hP | grep --color=never -E 'Filesystem|/dev/sd' || log "No /dev/sd devices found."

    log_header "Memory Check"
    free -h

    log_header "Active Connections"
    nmcli connection show --active

    log_header "Network Speed Test"
    if command -v speedtest &> /dev/null; then
        speedtest
    else
        log "speedtest-cli is not installed. Skipping speed test."
    fi
}

# Run system updates.
run_system_updates() {
    log_header "System Updates (apt-get update)"
    sudo apt-get update -y

    log_header "System Upgrades (apt-get upgrade)"
    sudo apt-get upgrade -y

    log_header "Cleaning Up (apt-get autoremove)"
    sudo apt-get autoremove -y

    log_header "Snap Package Refresh"
    if command -v snap &> /dev/null; then
        sudo snap refresh
    else
        log "snap is not installed. Skipping snap refresh."
    fi
}

# --- Main Execution ---

# First, ensure the log directory exists.
# We do this before the exec redirect so that the echo command can be seen on the console if it's the first time.
setup_logging

# Redirect all output from this point to the log file.
exec >> "${LOG_FILE}" 2>&1

log_header "UPDATE SCRIPT - STARTED"

perform_system_health_checks
run_system_updates

log_header "Update checks completed for $(date)"
log_header "END OF SCRIPT"
