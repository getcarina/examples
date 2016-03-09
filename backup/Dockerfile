FROM rackspace/rack:1.1.1

RUN apk add --update bash

COPY files/bin/backup /usr/bin/backup

ENTRYPOINT ["/usr/bin/backup"]
