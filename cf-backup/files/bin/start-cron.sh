echo "${SCHEDULE:-* * * * *} root /usr/bin/cron-job.sh /usr/bin/run-rack.sh >> /var/log/cron.log 2>&1" > /etc/crontab
rsyslogd
cron
env > /etc/env.sh
touch /var/log/cron.log
tail -f /var/log/syslog /var/log/cron.log