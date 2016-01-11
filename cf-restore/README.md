# Cloudfiles restore image

This image will download (restore) a cloudfiles container to a local directory once, using cron and rack.

Building the image:

```
docker build -t carinamarina/cf-restore cf-restore
```

Example run:

```
docker run -e RS_USERNAME='[redacted]' -e RS_API_KEY='[redacted]' -e RS_REGION_NAME='DFW' -e VOLUME='/config' -e CONTAINER='quassel-backup' --volumes-from quassel-data --name backup carinamarina/cf-backup
```

`RS_USERNAME` - Rackspace username

`RS_API_KEY` - Rackspace API key

`RS_REGION_NAME` - Rackspace region

`VOLUME` - Directory to restore to from the container

`CONTAINER` - The container name to download from

`--volumes-from` - the data volume container to mount