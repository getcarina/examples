rsyslogd
cron
env > /etc/env.sh
touch /var/log/cron.log
tail -f /var/log/syslog /var/log/cron.log
