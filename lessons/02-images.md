# Images: build your own with a Dockerfile

## Create a tiny app
```
mkdir -p /workspace/hello && cd /workspace/hello
cat > app.py <<'EOF'
print("Hello from my own image!")
EOF
cat > Dockerfile <<'EOF'
FROM python:3-alpine
WORKDIR /app
COPY app.py .
CMD ["python", "app.py"]
EOF
```

## Build and run
```
docker build -t hello-py .
docker run --rm hello-py
```

## Inspect
```
docker images
docker history hello-py
docker image inspect hello-py | jq '.[0].Config'
```

## Try it
- Change app.py, rebuild, and watch which layers are cached.
- Add a `.dockerignore` file and see what changes.
- Convert to a multi-stage build to shrink the image.

Next: `lesson 3`   (press q to close this page)
