#!/bin/bash

BACKEND="http://localhost:3000"

COMMAND=$1
BRANCH=$2

case "$COMMAND" in

    status)
        echo "Fetching environments..."
        curl -s "$BACKEND/env" | jq .
        ;;

    delete)
        if [ -z "$BRANCH" ]; then
            echo "Usage: ./branchify delete <branch>"
            exit 1
        fi

        SAFE_BRANCH=$(echo "$BRANCH" | tr '/' '_')

        echo "Deleting environment for branch: $BRANCH"

        curl -s -X DELETE "$BACKEND/env/$SAFE_BRANCH" | jq .
        ;;

    stop)
        if [ -z "$BRANCH" ]; then
            echo "Usage: ./branchify stop <branch>"
            exit 1
        fi

        SAFE_BRANCH=$(echo "$BRANCH" | tr '/' '_')

        echo "Stopping environment for branch: $BRANCH"

        curl -s -X POST "$BACKEND/env/$SAFE_BRANCH/stop" | jq .
        ;;

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
