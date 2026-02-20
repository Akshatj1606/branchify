#!/bin/bash

BRANCH=$1
TARGET_ENV="dev"

echo "----------------------------"
echo "Current Git Branch: $BRANCH"
echo "----------------------------"

# Branch mapping
if [[ "$BRANCH" == "main" ]]; then 
  TARGET_ENV="prod"
elif [[ "$BRANCH" == staging/* ]]; then
  TARGET_ENV="staging"
elif [["$BRANCH" == feature/* ]]; then
  TARGET_ENV="dev"
else
  TARGET_ENV="dev"
fi

echo "Mapped Environment: $TARGET_ENV"

#demo

if [ -f "environments/$TARGET_ENV/.env" ]; then
    echo "Environment config found."
    cat "environments/$TARGET_ENV/.env"
else
    echo "Error: Config not found!"
fi

echo "------------------------------"
echo "Environment switch  complete."
echo "------------------------------"
  
