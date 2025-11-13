#!/bin/bash
# Author:  Jayant Danech
# Purpose:  Check the application status on port 85 first.

URL="http://localhost:85"
debuginfo() {
    echo "curl -s $URL"
    curl -s $URL
}

status=$(curl -s -o /dev/null -w "%{http_code}" $URL)

if [ "$status" -eq 200 ]; then
    echo "Health check passed. App is working."
    debuginfo
    exit 0
else
    echo "Health check FAILED. Returned status: $status"
    debuginfo
    exit 1
fi

