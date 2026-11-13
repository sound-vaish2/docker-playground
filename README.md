# Docker Playground

A ready-to-use Docker sandbox in a single image. Run it, open a browser, and you get a terminal
with its own private Docker daemon, a full Docker CLI (with Compose and Buildx), and guided lessons.
It runs on your own machine and uses your CPU, RAM and disk. Nothing is hosted remotely.

## Quick start (users)

```bash
docker run -d --name docker-playground --privileged \
  -p 7681:7681 -p 8080-8089:8080-8089 \
  -v playground-docker:/var/lib/docker \
  -v playground-work:/workspace \
  YOUR_DOCKERHUB_USER/docker-playground
```

Open <http://localhost:7681>, then type `lesson`.

Or with Compose: edit the image name in `docker-compose.yml`, then run `docker compose up -d`.

| What | How |
|---|---|
| Stop / start | `docker stop docker-playground` / `docker start docker-playground` |
| Reset everything | `docker rm -f docker-playground && docker volume rm playground-docker playground-work` |
| Limit resources | add `--memory 4g --cpus 2` to `docker run` |
| Password protect | add `-e TTYD_CREDENTIAL=user:password` |
| See a web app you started inside | publish it on a port in 8080-8089 (e.g. `docker run -d -p 8080:80 nginx`), then open `http://localhost:8080` on your machine |

## Modes

| `PLAYGROUND_MODE` | Behaviour |
|---|---|
| `auto` (default) | Uses the host's Docker if `/var/run/docker.sock` is mounted, otherwise starts a private daemon |
| `dind` | Always a private, isolated daemon. Needs `--privileged`. **Recommended.** |
| `host` | Controls your real Docker daemon through the mounted socket. Containers you create appear on your host, and the playground can then affect everything on it. |

In `host` mode, bind mounts such as `-v /workspace/site:...` refer to paths on the host, not in the playground, so some lessons will not behave as written.

## Security notes

- `--privileged` gives the container wide access to the host kernel. Use this image on machines you control, for learning, and not on shared servers.
- The terminal is open to anyone who can reach port 7681. Bind it to localhost (`-p 127.0.0.1:7681:7681`) or set `TTYD_CREDENTIAL` if the machine is reachable by others.
- Docker Desktop (Mac/Windows) supports privileged containers, and no extra setup is needed.

## Build and publish (maintainer)

```bash
cd docker-playground
docker build -t YOUR_DOCKERHUB_USER/docker-playground .      # local test
./publish.sh YOUR_DOCKERHUB_USER 1.0.0                       # multi-arch push (amd64 + arm64)
```

## What's inside

- Docker Engine, CLI, Compose and Buildx (from the official `docker:dind` image)
- A browser terminal ([ttyd](https://github.com/tsl0922/ttyd)) on port 7681
- Tools: bash, git, curl, jq, vim, nano, tmux, htop, tree
- Four lessons in `/opt/lessons`: containers, images, volumes and networks, Compose
