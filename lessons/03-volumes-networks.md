# Volumes and networks

## Volumes (persist data)
```
docker volume create data
docker run --rm -v data:/d alpine sh -c 'echo saved > /d/file'
docker run --rm -v data:/d alpine cat /d/file     # still there
docker volume ls
```

## Bind mounts (share a folder)
```
mkdir -p /workspace/site && echo '<h1>Hi</h1>' > /workspace/site/index.html
docker run -d --name site -p 8081:80 -v /workspace/site:/usr/share/nginx/html:ro nginx
curl localhost:8081
```

## Networks (containers talk by name)
```
docker network create appnet
docker run -d --name db --network appnet -e POSTGRES_PASSWORD=pw postgres:16-alpine
docker run --rm --network appnet alpine ping -c 2 db
docker network inspect appnet | jq '.[0].Containers'
```

## Clean up
```
docker rm -f site db
docker network rm appnet
docker volume rm data
```

Next: `lesson 4`   (press q to close this page)
