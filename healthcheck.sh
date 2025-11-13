#!/bin/bash
# Author:  Jayant Danech
# Purpose:  Check the application status on port 85 first.

URL="http://localhost:85"

status=$(curl -s -o /dev/null -w "%{http_code}" $URL)

if [ "$status" -eq 200 ]; then
    echo "Health check passed. App is working."
    echo "curl $URL"
    curl $URL
    exit 0
else
    echo "Health check FAILED. Returned status: $status"
    echo "curl $URL"
    curl $URL
    exit 1
fi

