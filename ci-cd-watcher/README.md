```
docker run -d -e WHWATCH_IMAGE_NAME="donschenck/productws:latest" --volumes-from swarm-data -p 5000:5000 --name watcher donschenck/whwwatch:latest
```
