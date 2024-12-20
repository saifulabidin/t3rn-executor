#!/bin/bash

print_banner() {
    curl -s https://raw.githubusercontent.com/dwisyafriadi2/logo/main/logo.sh | bash
}

print_banner
# Find and kill the ./executor process
PROCESS_INFO=$(pgrep -f "./executor")

if [ -z "$PROCESS_INFO" ]; then
    echo "Executor process not found. Nothing to stop."
else
    kill -9 $PROCESS_INFO
    echo "Executor process stopped. PID: $PROCESS_INFO"
fi
