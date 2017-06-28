FROM rackspace/rack:1.1.1

RUN apk add --update --no-cache bash
RUN apk add --update --no-cache pigz

COPY files/bin/ /usr/bin/

ENTRYPOINT ["/usr/bin/entrypoint"]
