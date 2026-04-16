# Branchify CLI acts as a bridge between user and backend environment management system.

#!/bin/bash

BACKEND="http://localhost:3000"

COMMAND=$1
BRANCH=$2

case "$COMMAND" in
# The status command fetches all environments from backend and displays them in formatted JSON.

    status)
        echo "Fetching environments..."
        curl -s "$BACKEND/env" | jq .
        ;;
# First check: If branch name not given then show error

    delete)
        if [ -z "$BRANCH" ]; then
            echo "Usage: ./branchify delete <branch>"
            exit 1
        fi

        # Converts:feature/login → feature_login

        SAFE_BRANCH=$(echo "$BRANCH" | tr '/' '_')

        echo "Deleting environment for branch: $BRANCH"

        # Delete command removes a specific branch environment by calling backend DELETE API.

        curl -s -X DELETE "$BACKEND/env/$SAFE_BRANCH" | jq .
        ;;

        # Stop command halts the environment without deleting it, allowing reuse later.

    stop)
        if [ -z "$BRANCH" ]; then
            echo "Usage: ./branchify stop <branch>"
            exit 1
        fi

        SAFE_BRANCH=$(echo "$BRANCH" | tr '/' '_')

        echo "Stopping environment for branch: $BRANCH"

        curl -s -X POST "$BACKEND/env/$SAFE_BRANCH/stop" | jq .
        ;;

        # If user enters wrong command then this will show the usage and improve user experience.

    *)
        echo ""
        echo "Branchify CLI"
        echo "-------------"
        echo "Usage:"
        echo "./branchify status"
        echo "./branchify stop <branch>"
        echo "./branchify delete <branch>"
        echo ""
        ;;
esac
