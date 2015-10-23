```
docker run -d \
  --volumes-from swarm-data \
  -p 5000:5000 \
  --name watcher \
  <imageName>
```
