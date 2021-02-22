#!/bin/bash
  
# turn on bash's job control
set -m
  
# Start the primary process and put it in the background
/opt/dcm4chee/bin/run.sh &
  
# Start and configure the cron process
/usr/sbin/cron
echo "$CRON_TASK" | crontab -



# now we bring the primary process back into the foreground
# and leave it there
fg %1