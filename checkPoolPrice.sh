#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 1 ] && [ "$#" -ne 2 ]; then
    echo "Usage: $0 <FUNCTION_PARAMS> [RPC_URL]"
    exit 1
fi

# Call the appropriate forge script command based on the number of arguments
if [ "$#" -eq 1 ]; then
    forge script script/CheckerScript.s.sol --sig "getPoolInfo(address)" $1
else
    forge script script/CheckerScript.s.sol --sig "getPoolInfoWithRPC(address,string)" $1 $2
fi