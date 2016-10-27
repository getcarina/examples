```
docker run -d -e WHWATCH_IMAGE_NAME="donschenck/productws:latest" -e DB_IP="104.130.0.7" -e DB_PORT="32769" --volumes-from swarm-data -p 5050:5000 --name watcher donschenck/whwatch:latest
```
