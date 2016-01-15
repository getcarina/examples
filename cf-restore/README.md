# Rackspace Cloud Files restore Docker image

This image will download (restore) a Cloud Files container to a local directory once, using [rack](https://developer.rackspace.com/docs/rack-cli/ "rack").

Building the image:

```
docker build -t carinamarina/cf-restore cf-restore
```

Example run with bash:

```
docker run \
--name backup \  
--env RS_USERNAME='[redacted]' \ 
--env RS_API_KEY='[redacted]' \
--env RS_REGION_NAME='DFW' \
--env DIRECTORY='/config' \
--env CONTAINER='quassel-backup' \ 
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
--volumes-from quassel-data `
carinamarina/cf-backup
```

`RS_USERNAME` - Rackspace username

`RS_API_KEY` - Rackspace API key

`RS_REGION_NAME` - Rackspace region

`DIRECTORY` - Directory to restore to from the container

`CONTAINER` - The container name to download from

`--volumes-from` - the data volume container to mount

`NOCOMPRESSION` - set this to download full files instead of a compressed archive. Use the same setting as your backup setting, if using the cf-backup image