# Containers: run, inspect, stop, clean up

## Run something
```
docker run hello-world
docker run -d --name web -p 8080:80 nginx
curl localhost:8080
```

## Look around
```
docker ps                 # running containers
docker ps -a              # include stopped
docker logs web
docker exec -it web sh    # shell inside (type 'exit' to leave)
docker stats --no-stream
```

## Stop and clean up
```
docker stop web
docker rm web
docker container prune -f
```

## Try it
- Run `docker run --rm alpine cat /etc/os-release`. What does --rm do?
- Start `docker run -d --memory 64m --cpus 0.5 nginx` and check with `docker stats`.

Next: `lesson 2`   (press q to close this page)
