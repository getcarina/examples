FROM ubuntu:15.04

RUN apt-get update && apt-get install -y znc
RUN useradd znc

ADD docker-entrypoint.sh /entrypoint.sh
ADD znc.conf.default /znc.conf.default
RUN chmod 644 /znc.conf.default

EXPOSE 6667
ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
