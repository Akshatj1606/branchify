# This script runs automatically when you switch Git branches

#!/bin/bash

BACKEND_URL="http://localhost:3000"

# Gets current Git branch
BRANCH=$(git branch --show-current)
# Default environment = dev
TARGET_ENV="dev"

echo "--------------------------------"
echo "Current Git Branch: $BRANCH"
echo "--------------------------------"

# Map branch → environment
if [[ "$BRANCH" == "main" || "$BRANCH" == "master" ]]; then
    TARGET_ENV="prod"
elif [[ "$BRANCH" == staging/* ]]; then
    TARGET_ENV="staging"
elif [[ "$BRANCH" == feature/* ]]; then
    TARGET_ENV="dev"
else
    TARGET_ENV="dev"
fi

echo "Mapped Environment: $TARGET_ENV"

# Locate Environment File

BRANCHIFY_ROOT=".branchify"
ENV_FILE="$BRANCHIFY_ROOT/environments/$TARGET_ENV/.env"

# Does this env file exist?
if [ ! -f "$ENV_FILE" ]; then
    echo "❌ Environment config not found: $ENV_FILE"
    exit 1
fi

echo "Applying environment configuration..."

# Apply config to project
cp "$ENV_FILE" ".env"

echo "✅ .env updated from $TARGET_ENV configuration"

# Sanitize branch name
SAFE_BRANCH=$(echo "$BRANCH" | tr '/' '_')

echo "Checking backend for existing environment..."

# Calls backend --> Filters using jq --> Checks:Does this branch environment already exist?

EXISTS=$(curl -s "$BACKEND_URL/env" | jq -r ".[] | select(.branch == \"$SAFE_BRANCH\") | .branch")

# If environment NOT found:
if [ -z "$EXISTS" ]; then
    echo "Creating environment..."

    # call backend --> create env and Allocate resources

    RESPONSE=$(curl -s -X POST "$BACKEND_URL/env" \
        -H "Content-Type: application/json" \
        -d "{\"branch\":\"$SAFE_BRANCH\"}")

    echo "$RESPONSE"

# If exists → skip creation
else
    echo "Environment already exists."
fi

echo "--------------------------------"
echo "Environment ready for branch $BRANCH"
echo "--------------------------------"
