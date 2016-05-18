# znc-docker

## Create conf file

This step is optional, since users might have their own conf files already. If not, to create one: 

```bash
$ docker run -it carinamarina/znc-mkconf
```

## Run data container

```
$ docker run --detach \
  --name znc-conf \
  --volume /data \
  alpine true
```

```
$ docker cp znc.conf znc-conf:/data
```

## Run ZNC container

```bash
$ docker run --detach \
  --publish 6697:6697 \
  --name znc \
  --volumes-from znc-conf \
  carinamarina/znc /data
```
