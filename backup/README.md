# Back up Container Data

This image will create an archive file of a single directory in a data volume, and will either upload the archive to a Rackspace Cloud Files container or output the contents of the archive to `stdout`.

### Build the image

```
docker build -t carinamarina/backup .
```

### Usage

```bash
docker run [OPTIONS] carinamarina/backup <COMMAND> <ARG...>
```

`COMMAND` can be one of `backup` or `restore`.

`backup` accepts several arguments:

* `-c, --container` The name of the Cloud Files container in which to store the backup. Ignored if `--stdout` is used.
* `-h, --help` Show help information
* `-s, --source` The source directory for the backup. All files in this directory will be added to the archive.
* `--stdout` Output the archive to stdout instead of uploading it to a Cloud Files container.
* `-z, --zip` Compress the archive using gzip.

`restore` accepts the following arguments:

* `-c, --container <name>` Name of a Cloud Files container
* `-d, --destination <path>` Restore destination for archive contents
* `-h, --help` Show help information
* `-o, --object <name>` Name of archive object in a container
* `--stdin`  Read from stdin instead of Cloud Files
* `-z, --zip` Use gzip to uncompress archive

### Examples

#### Back up a data volume container to Rackspace Cloud Files

Assume you've created a container named `mysql-data` with a data volume at `/data`. Also assume that you have set the environment variables `RS_USERNAME`, `RS_API_KEY`, and `RS_REGION_NAME` to your Rackspace username, Rackspace API key, and preferred Rackspace region, respectively. To upload the contents of the data volume to Cloud Files, run the following command:

```bash
$ docker run \
  --rm \
  --env RS_USERNAME=${RS_USERNAME} \
  --env RS_API_KEY=${RS_API_KEY} \
  --env RS_REGION_NAME=${RS_REGION_NAME} \
  --volumes-from mysql-data \
  carinamarina/backup \
  backup \
  --source /data/ \
  --container mysql-backups \
  --zip

tar: removing leading '/' from member names
Successfully uploaded object [2016/03/09/20-06-data.tar.gz] to container [mysql-backups]
```

Note that the uploaded object is named with the following format:

`{{ year }}/{{ month }}/{{ day }}/{{ hour }}-{{ minute }}-{{ pathToSource }}.tar.gz`

#### Back up a data volume container locally

If you don’t have a Rackspace cloud account or if you want to do something with your backups other than upload them to Cloud Files, you can pipe the contents of the backup archive to your local filesystem:

```bash
$ docker run \
  --rm \
  --volumes-from mysql-data \
  carinamarina/backup \
  backup \
  --source /data/ \
  --stdout \
  --zip \
  > mysql-backup.tar.gz
```

This will create a file named `mysql-backup.tar.gz` in the directory from which you ran the command. Note the use of `> mysql-backup.tar.gz`, which redirects the output of the command (the contents of the compressed archive) directly to a file.

#### Restore a backup from Cloud Files

Assume that you have set the environment variables `RS_USERNAME`, `RS_API_KEY`, and `RS_REGION_NAME` to your Rackspace username, Rackspace API key, and preferred Rackspace region, respectively. To download the backup from Cloud Files and write them to `/data/`, run the following command:

```bash
$ docker run \
  --rm \
  --env RS_USERNAME=${RS_USERNAME} \
  --env RS_API_KEY=${RS_API_KEY} \
  --env RS_REGION_NAME=${RS_REGION_NAME} \
  --volumes-from mysql-data \
  carinamarina/backup \
  restore \
  --container mysql-backups \
  --object 2016/03/10/01-30-data.tar.gz \
  --destination /data/ \
  --zip
Reading and unzipping archive...
Done.
```

#### Restore a local backup

If you have a backup archive on your local machine, you can restore it by piping it into the `docker run` command:

```bash
$ docker run \
  --rm \
  --interactive \
  --volumes-from mysql-data \
  carinamarina/backup \
  restore \
  --destination /data/ \
  --stdin \
  --zip \
  < mysql-backup.tar.gz
Reading and unzipping archive...
Done.
```
