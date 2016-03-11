#!/bin/sh -x
env $(cat /etc/env.sh | xargs -0) run-rack.sh >> /var/log/cron.log 2>&1
