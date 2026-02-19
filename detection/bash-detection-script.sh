#!/bin/bash
LOG="/var/log/auth.log"
THRESHOLD=10
TIME_WINDOW=8  # seconds

# Extract failed attempts per IP
grep "Failed password" $LOG | awk '{print $9}' | sort | uniq -c | while read count ip
do
    if [ $count -ge $THRESHOLD ]; then
        echo "[ALERT] Possible brute force from $ip ($count attempts)"
    fi
done
