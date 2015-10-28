```
docker run -d -e WHWATCH_IMAGE_NAME="donschenck/productws:latest" --volumes-from swarm-data -p 5050:5000 --name watcher donschenck/whwatch:latest
```
