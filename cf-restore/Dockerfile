FROM ubuntu:14.04

#ENV RS_USERNAME RS_USERNAME
#ENV RS_API_KEY RS_API_KEY
#ENV RS_REGION_NAME RS_REGION_NAME
#ENV VOLUME VOLUME
#ENV CONTAINER CONTAINER
#ENV NOCOMPRESSION NOCOMPRESSION

ADD https://ec4a542dbf90c03b9f75-b342aba65414ad802720b41e8159cf45.ssl.cf5.rackcdn.com/1.1.0-beta1/Linux/amd64/rack /usr/bin/rack
ADD files/bin/run-rack.sh /usr/bin/run-rack.sh

RUN apt-get -y install ca-certificates

RUN chmod +x /usr/bin/rack
RUN chmod +x /usr/bin/run-rack.sh

CMD run-rack.sh