#!/bin/bash

# Function to print the banner
print_banner() {
  clear
  echo -e """
    ____                       
   / __ \\____ __________ ______
  / / / / __ \`/ ___/ __ \`/ ___/
 / /_/ / /_/ (__  ) /_/ / /    
/_____/_\\__,_/____/\\__,_/_/      

    ____                       __
   / __ \\___  ____ ___  __  __/ /_  ______  ____ _
  / /_/ / _ \\/ __ \`__ \\/ / / / / / / / __ \\/ __ \`/
 / ____/  __/ / / / / / /_/ / / /_/ / / / / /_/ / 
/_/    \\___/_/ /_/ /_/\\__,_/_/\\__,_/_/ /_/\\__, /  
                                         /____/    

====================================================
     Automation         : Auto Install Node 
     Telegram Channel   : @dasarpemulung
     Telegram Group     : @parapemulung
====================================================
"""
}

# Function to display process message
process_message() {
    echo -e "\n\e[42m$1...\e[0m\n" && sleep 1
}

# Call the print_banner function
print_banner

# Function to check root/sudo
check_root() {
    process_message "Checking root privileges"
    if [ "$EUID" -ne 0 ]; then
        echo "Please run this script as root or use sudo."
        exit 1
    fi
}

# Function to download Executor binary
download_executor() {
    process_message "Downloading Executor binary"
    curl -sL "https://github.com/t3rn/executor-release/releases/latest/download/executor.tar.gz" -o executor.tar.gz
    process_message "Extracting Executor binary"
    tar -xzf executor.tar.gz
    echo "File extracted. Navigate to the 'executor' folder to proceed."
}

# Function to configure environment variables
configure_environment() {
    process_message "Configuring environment variables"

    # NODE_ENV
    read -p "Enter Node Environment (e.g., testnet): " NODE_ENV
    export NODE_ENV=${NODE_ENV:-testnet}
    echo "export NODE_ENV=$NODE_ENV" >> ~/.bashrc

    # LOG LEVEL
    export LOG_LEVEL=debug
    echo "export LOG_LEVEL=debug" >> ~/.bashrc
    export LOG_PRETTY=false
    echo "export LOG_PRETTY=false" >> ~/.bashrc

    # PROCESS ORDERS AND CLAIMS
    export EXECUTOR_PROCESS_ORDERS=true
    echo "export EXECUTOR_PROCESS_ORDERS=true" >> ~/.bashrc
    export EXECUTOR_PROCESS_CLAIMS=true
    echo "export EXECUTOR_PROCESS_CLAIMS=true" >> ~/.bashrc

    # PRIVATE KEY
    read -p "Enter your PRIVATE_KEY_LOCAL: " PRIVATE_KEY_LOCAL
    export PRIVATE_KEY_LOCAL=$PRIVATE_KEY_LOCAL
    echo "export PRIVATE_KEY_LOCAL=$PRIVATE_KEY_LOCAL" >> ~/.bashrc

    # NETWORKS
    echo "Specify the networks to enable (comma-separated, e.g., arbitrum-sepolia,base-sepolia):"
    read -p "Networks: " ENABLED_NETWORKS
    export ENABLED_NETWORKS=${ENABLED_NETWORKS:-'arbitrum-sepolia,base-sepolia'}
    echo "export ENABLED_NETWORKS='$ENABLED_NETWORKS'" >> ~/.bashrc

    # OPTIONAL RPC
    read -p "Do you want to add a custom RPC URL? (y/n): " ADD_RPC
    if [[ $ADD_RPC == "y" ]]; then
        read -p "Enter network name (e.g., arbt): " NETWORK_NAME
        read -p "Enter RPC URLs (comma-separated): " RPC_ENDPOINTS
        export RPC_ENDPOINTS_${NETWORK_NAME}=$RPC_ENDPOINTS
        echo "export RPC_ENDPOINTS_${NETWORK_NAME}='$RPC_ENDPOINTS'" >> ~/.bashrc
    fi

    # PROCESS VIA API OR RPC
    export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=true
    echo "export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=true" >> ~/.bashrc

    echo "Environment variables configured. Restart terminal or run 'source ~/.bashrc' to apply changes."
}

# Function to start Executor in the background
start_executor() {
    process_message "Starting Executor in the background"
    cd executor || exit

    # Run the executor using nohup in the background
    nohup ./executor > executor.log 2>&1 &
    EXECUTOR_PID=$!
    echo "Executor started with PID $EXECUTOR_PID"
    echo "Logs are being written to executor.log"
}

# Main function
main() {
    print_banner
    ##check_root
    download_executor
    configure_environment
    start_executor
    echo "Setup complete! The Executor is running in the background."
}

# Run the main function
main
