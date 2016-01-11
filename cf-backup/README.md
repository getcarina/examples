# Cloudfiles backup image

This image will upload (backup) a directory to cloudfiles every minute using cron and rack.

Building the image:

```
docker build -t carinamarina/cf-backup cf-backup
```

Example run:

```
docker run -e RS_USERNAME='[redacted]' -e RS_API_KEY='[redacted]' -e RS_REGION_NAME='DFW' -e VOLUME='/config' -e CONTAINER='quassel-backup' --volumes-from quassel-data --name backup carinamarina/cf-backup
```

`RS_USERNAME` - Rackspace username

`RS_API_KEY` - Rackspace API key

`RS_REGION_NAME` - Rackspace region

`VOLUME` - Directory to backup from the container

`CONTAINER` - The container name to upload to

`--volumes-from` - the data volume container to mount