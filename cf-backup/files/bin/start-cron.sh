#!/bin/sh -x
echo "${SCHEDULE:-* * * * *} root /usr/bin/cron-job.sh >> /var/log/cron.log 2>&1" > /etc/crontab
rsyslogd
cron
#env | grep -v '$SCHEDULE' | sed 's/\(.*\)=\(.*\)/\1="\2"/' > /etc/env.sh
env | grep -v SCHEDULE > /etc/env.sh
touch /var/log/cron.log
tail -f /var/log/syslog /var/log/cron.log