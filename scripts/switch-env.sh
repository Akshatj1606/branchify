#!/bin/bash

BACKEND_URL="http://localhost:5000"

BRANCH=$(git branch --show-current)

TARGET_ENV="dev"

echo "--------------------------------"
echo "Current Git Branch: $BRANCH"
echo "--------------------------------"

# Map branch → environment
if [[ "$BRANCH" == "main" ]]; then
    TARGET_ENV="prod"
elif [[ "$BRANCH" == staging/* ]]; then
    TARGET_ENV="staging"
elif [[ "$BRANCH" == feature/* ]]; then
    TARGET_ENV="dev"
else
    TARGET_ENV="dev"
fi

echo "Mapped Environment: $TARGET_ENV"

# Detect install location
if [ -d ".branchify" ]; then
    BRANCHIFY_ROOT=".branchify"
else
    BRANCHIFY_ROOT="."
fi

ENV_FILE="$BRANCHIFY_ROOT/environments/$TARGET_ENV/.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "Environment config not found: $ENV_FILE"
    exit 1
fi

echo "Loading environment config..."
cat "$ENV_FILE"

echo ""

# Sanitize branch name for DB usage
SAFE_BRANCH=$(echo "$BRANCH" | tr '/' '_')

echo "Checking backend for existing environment..."

EXISTS=$(curl -s "$BACKEND_URL/env" | grep "\"$SAFE_BRANCH\"")

if [ -z "$EXISTS" ]; then
    echo "Creating environment..."

    RESPONSE=$(curl -s -X POST "$BACKEND_URL/env" \
        -H "Content-Type: application/json" \
        -d "{\"branch\":\"$SAFE_BRANCH\"}")

    echo "$RESPONSE"
else
    echo "Environment already exists."
fi

echo "--------------------------------"
echo "Environment ready for branch $BRANCH"
echo "--------------------------------"
