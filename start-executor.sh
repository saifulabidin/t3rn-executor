#!/bin/bash

# Function to print the banner
print_banner() {
    curl -s https://raw.githubusercontent.com/dwisyafriadi2/logo/main/logo.sh | bash
}

# Display the banner
print_banner

# Start the executor process in the background with nohup
process_message() {
    echo -e "\n\e[42m$1...\e[0m\n"
    sleep 1
}

process_message "Starting Executor in the Background"

# Ensure the correct path for HOME_DIR
if [ "$EUID" -ne 0 ]; then
    HOME_DIR="/home/$USER"
else
    HOME_DIR="/root"
fi

# Ensure executor binary exists
if [ ! -f "$HOME_DIR/executor/executor/bin/executor" ]; then
    echo "Error: Executor binary not found at $HOME_DIR/executor/executor/bin/executor"
    exit 1
fi

# Start the executor process
cd "$HOME_DIR/executor/executor/bin" || exit
nohup ./executor > "$HOME_DIR/executor/executor.log" 2>&1 &
EXECUTOR_PID=$!

# Display the status
if ps -p $EXECUTOR_PID > /dev/null; then
    echo "Executor started successfully with PID: $EXECUTOR_PID"
    echo "Logs are being written to: $HOME_DIR/executor/executor.log"
else
    echo "Failed to start Executor. Check logs for details."
fi
