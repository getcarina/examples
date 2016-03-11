# Rackspace Cloud Files backup Docker image

This image will upload (backup) a directory to Cloud Files every minute using cron and [rack](https://developer.rackspace.com/docs/rack-cli/ "rack"). If you want to provide a different schedule, set the SCHEDULE environment variable to the cron string you want (defaults to * * * * *).

Building the image:

```
docker build -t carinamarina/cf-backup cf-backup
```

Example run. Bash:

```
docker run \
--name backup \ 
--env RS_USERNAME='[redacted]' \ 
--env RS_API_KEY='[redacted]' \
--env RS_REGION_NAME='DFW' \
--env DIRECTORY='/config' \
--env CONTAINER='quassel-backup' \
--env SCHEDULE='*/2 * * * *' \ 
--volumes-from quassel-data \
carinamarina/cf-backup
```

PowerShell:

```
docker run `
--name backup ` 
--env RS_USERNAME='[redacted]' ` 
--env RS_API_KEY='[redacted]' `
--env RS_REGION_NAME='DFW' `
--env DIRECTORY='/config' `
--env CONTAINER='quassel-backup' `
--env SCHEDULE='*/2 * * * *' ` 
--volumes-from quassel-data `
carinamarina/cf-backup
```

`RS_USERNAME` - Rackspace username

`RS_API_KEY` - Rackspace API key

`RS_REGION_NAME` - Rackspace region

`DIRECTORY` - Directory to backup from the container

`CONTAINER` - The container name to upload to

`SCHEDULE` - (optional) cron schedule string

`NOCOMPRESSION` - set this to 'true' to upload individual files instead of a single compressed archive. Defaults to using a single compressed archive by default. Not using an archive will also ignore hidden files in $DIRECTORY.

`--volumes-from` - the data volume container to mount