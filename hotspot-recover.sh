#!/bin/bash

LOG_PATH="$HOME/logs/hotspot-recover.log"
mkdir -p "$(dirname "$LOG_PATH")"

VERBOSE=false
NO_SLEEP=false

# Parse arguments
for arg in "$@"; do
    case "$arg" in
        --no-sleep|-ns)
            NO_SLEEP=true
            ;;
        -v|--verbose)
            VERBOSE=true
            ;;
    esac
done

# Logging function
log() {
    echo "$@" >> "$LOG_PATH"
    if [ "$VERBOSE" = true ]; then
        echo "$@"
    fi
}

hotrun() {
    local retries=0
    local max_retries=5
    local recovery_attempted=false

    log "========================================================"

    if [ "$NO_SLEEP" = false ]; then
        sleep 10
    fi

    log "hi ${USER} $(date '+%H:%M:%S')"

    HOTSPOT_NAME="Hotspot"

    if ! nmcli connection show | grep -q "$HOTSPOT_NAME"; then
        log "❌ Hotspot connection not found."
        log "========================================================"
        return 1
    fi

    log "✔ Hotspot connection exists."

    while [ $retries -lt $max_retries ]; do
        if nmcli connection show --active | grep -q "$HOTSPOT_NAME"; then
            log "ℹ Hotspot is already active."
            log "========================================================"
            return 0
        fi

        log "⏳ Hotspot exists but not active. Attempting to start... (try $((retries+1))/$max_retries)"
        nmcli connection up "$HOTSPOT_NAME" >> "$LOG_PATH" 2>&1

        if [ $? -eq 0 ]; then
            log "✅ Hotspot started successfully."
            log "========================================================"
            return 0
        fi

        log "⚠ Attempt $((retries+1)) failed."
        ((retries++))
        sleep 1
    done

    if [ "$recovery_attempted" = false ]; then
        log "⏸ All $max_retries attempts failed. Waiting 10 seconds before final try..."
        sleep 10
        recovery_attempted=true
        # Call recursively with no-sleep, preserving verbosity
        "$0" --no-sleep ${VERBOSE:+--verbose}
        return $?
    else
        log "❌ Final recovery attempt failed. Giving up."
        log "========================================================"
        return 1
    fi
}

hotrun

