#!/bin/bash

# Save the current directory
ORIGINAL_DIR=$(pwd)

# Resolve the actual path of the script, following symlinks
SCRIPT_PATH=$(readlink -f "${BASH_SOURCE[0]}")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

# Check if the correct number of arguments are provided
if [ "$#" -ne 1 ] && [ "$#" -ne 2 ]; then
    echo "Usage: $0 <FUNCTION_PARAMS> [RPC_URL]"
    exit 1
fi

# Check if the current directory is different from the script directory
if [ "$ORIGINAL_DIR" != "$SCRIPT_DIR" ]; then
    # Change to the script directory
    cd "$SCRIPT_DIR" || exit
    SWITCHED=true
else
    SWITCHED=false
fi

# Call the appropriate forge script command based on the number of arguments
if [ "$#" -eq 1 ]; then
    forge script "$SCRIPT_DIR/script/CheckerScript.s.sol" --sig "getPoolInfo(address)" $1
else
    forge script "$SCRIPT_DIR/script/CheckerScript.s.sol" --sig "getPoolInfoWithRPC(address,string)" $1 $2
fi

# Return to the original directory if we switched
if [ "$SWITCHED" = true ]; then
    cd "$ORIGINAL_DIR" || exit
fi
