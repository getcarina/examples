FROM ubuntu:14.04

#ENV RS_USERNAME RS_USERNAME
#ENV RS_API_KEY RS_API_KEY
#ENV RS_REGION_NAME RS_REGION_NAME
#ENV DIRECTORY DIRECTORY
#ENV CONTAINER CONTAINER
#ENV SCHEDULE SCHEDULE - defaults to * * * * * if not set (every minute) for the cron setup.
#ENV NOCOMPRESSION NOCOMPRESSION

ADD https://ec4a542dbf90c03b9f75-b342aba65414ad802720b41e8159cf45.ssl.cf5.rackcdn.com/1.1.0-beta1/Linux/amd64/rack /usr/bin/rack

RUN apt-get -y install rsyslog ca-certificates

#ADD files/etc/crontab /etc/crontab
ADD files/bin/start-cron.sh /usr/bin/start-cron.sh
ADD files/bin/cron-job.sh /usr/bin/cron-job.sh
ADD files/bin/run-rack.sh /usr/bin/run-rack.sh
RUN chmod +x /usr/bin/start-cron.sh
RUN chmod +x /usr/bin/cron-job.sh
RUN chmod +x /usr/bin/run-rack.sh
RUN chmod +x /usr/bin/rack
RUN touch /var/log/cron.log

CMD /usr/bin/start-cron.sh