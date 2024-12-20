#!/bin/bash

print_banner() {
    curl -s https://raw.githubusercontent.com/dwisyafriadi2/logo/main/logo.sh | bash
}

print_banner

# Check if the ./executor process is running
PROCESS_INFO=$(pgrep -f "./executor")

if [ -z "$PROCESS_INFO" ]; then
    echo "Executor not activated."
else
    echo "Executor activated. PID: $PROCESS_INFO"
fi
