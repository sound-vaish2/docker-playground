# Docker Compose: multi-container apps

## Define a stack
```
mkdir -p /workspace/stack && cd /workspace/stack
cat > compose.yaml <<'EOF'
services:
  web:
    image: nginx:alpine
    ports: ["8082:80"]
    depends_on: [cache]
  cache:
    image: redis:alpine
    volumes: [cachedata:/data]
volumes:
  cachedata:
EOF
```

## Run it
```
docker compose up -d
docker compose ps
docker compose logs -f --tail 20     # Ctrl+C to stop following
curl localhost:8082
```

## Change and tear down
```
docker compose exec cache redis-cli ping
docker compose down            # keep volumes
docker compose down -v         # remove volumes too
```

## Try it
- Add a third service and scale one: `docker compose up -d --scale web=3` (remove the fixed host port first).

You have finished the basics. Explore: `docker buildx`, `docker system df`, `docker context`.
(press q to close this page)
