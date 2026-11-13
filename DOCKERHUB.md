# Docker Playground

A ready-to-use Docker sandbox that runs on your own computer. Start one container, open your browser, and you get a terminal with a **private Docker daemon** where you can run containers, build images, and try Docker Compose without touching your real Docker setup.

- Runs locally and uses your own CPU, RAM and disk. Nothing is hosted remotely.
- Browser terminal at `http://localhost:7681`
- Includes the Docker CLI, Docker Compose and Buildx
- Includes four guided lessons: type `lesson` in the terminal
- Works on Linux, macOS (Intel and Apple Silicon) and Windows with Docker Desktop
- Reset anytime: delete two volumes and start fresh

---

## Quick start

**Requirements:** Docker installed on your machine (Docker Desktop or Docker Engine).

```bash
docker run -d --name docker-playground --privileged \
  -p 7681:7681 -p 8080-8089:8080-8089 \
  -v playground-docker:/var/lib/docker \
  -v playground-work:/workspace \
  YOUR_DOCKERHUB_USER/docker-playground
```

Then:

1. Open **http://localhost:7681** in your browser.
2. Wait a few seconds while the private Docker daemon starts. If the page doesn't load straight away, refresh it.
3. Type `docker run hello-world` to check that everything works.
4. Type `lesson` to see the guided lessons.

On Windows PowerShell, put the command on one line or replace each `\` line ending with a backtick (`` ` ``).

### Using Docker Compose instead

Save this as `docker-compose.yml`, then run `docker compose up -d`:

```yaml
services:
  playground:
    image: YOUR_DOCKERHUB_USER/docker-playground:latest
    container_name: docker-playground
    privileged: true
    ports:
      - "7681:7681"
      - "8080-8089:8080-8089"
    volumes:
      - playground-docker:/var/lib/docker
      - playground-work:/workspace
    restart: unless-stopped

volumes:
  playground-docker:
  playground-work:
```

---

## What each part of the command does

| Option | Purpose |
|---|---|
| `-d` | Run in the background. |
| `--name docker-playground` | A fixed name, so you can run `docker stop docker-playground`. |
| `--privileged` | Required. It lets the container run its own Docker daemon. See [Security](#security). |
| `-p 7681:7681` | Opens the browser terminal on your machine. |
| `-p 8080-8089:8080-8089` | Lets you reach web apps you start inside the playground. |
| `-v playground-docker:/var/lib/docker` | Keeps your images and containers when the playground is stopped or restarted. |
| `-v playground-work:/workspace` | Keeps the files you create in `/workspace`. |

---

## Using the playground

### The guided lessons

| Command | Opens |
|---|---|
| `lesson` | The list of lessons |
| `lesson 1` | Containers: run, inspect, stop, clean up |
| `lesson 2` | Images: build your own with a Dockerfile |
| `lesson 3` | Volumes and networks |
| `lesson 4` | Docker Compose: multi-container apps |

Press `q` to close a lesson.

### Try a web server

Inside the playground terminal:

```bash
docker run -d --name web -p 8080:80 nginx
curl localhost:8080
```

To see it in your own browser, open **http://localhost:8080**. Ports **8080 to 8089** are available for this. If you publish an app on a port outside that range, it is reachable from inside the playground but not from your browser.

### Shortcuts in the terminal

| Shortcut | Same as |
|---|---|
| `d` | `docker` |
| `dc` | `docker compose` |
| `dps` | A tidy table of running containers |
| `ll` | `ls -lah` |

Tab-completion works for `docker` commands.

### Installed tools

`bash`, `git`, `curl`, `wget`, `jq`, `vim`, `nano`, `tmux`, `htop`, `tree`, `dig` and `nslookup`.

---

## Managing the playground

| Task | Command (run on your own machine, not inside the playground) |
|---|---|
| Stop | `docker stop docker-playground` |
| Start again | `docker start docker-playground` |
| View startup logs | `docker logs docker-playground` |
| Check health | `docker ps` (look for `healthy`) |
| **Reset everything** | `docker rm -f docker-playground && docker volume rm playground-docker playground-work` |
| Update to the latest image | `docker pull YOUR_DOCKERHUB_USER/docker-playground`, then remove and re-run the container. Your volumes are kept. |

### Limit how much of your computer it uses

Add limits to the `docker run` command:

```bash
--memory 4g --cpus 2
```

On Docker Desktop (macOS and Windows), the playground is also bounded by the memory and CPU assigned to Docker in **Settings > Resources**. If large builds or many containers fail with out-of-memory errors, raise those values.

### Password-protect the terminal

```bash
-e TTYD_CREDENTIAL=myuser:mypassword
```

### Only allow access from your own machine

Bind the terminal port to localhost so other devices on your network can't reach it:

```bash
-p 127.0.0.1:7681:7681
```

---

## Environment variables

| Variable | Default | Description |
|---|---|---|
| `PLAYGROUND_PORT` | `7681` | Port the terminal listens on inside the container. If you change it, change the `-p` mapping to match. |
| `TTYD_CREDENTIAL` | not set | `user:password` to require a login for the terminal. |
| `PLAYGROUND_MODE` | `auto` | `auto`, `dind` or `host`. See below. |

### Modes

| Mode | Behavior |
|---|---|
| `auto` | Uses your real Docker if `/var/run/docker.sock` is mounted into the container. Otherwise it starts a private daemon. |
| `dind` | Always starts a private, isolated daemon. **Recommended for learning.** Requires `--privileged`. |
| `host` | Controls your real Docker daemon through the mounted socket. Containers you create appear on your machine and are not isolated. The lessons assume `dind`, and bind-mount paths in `host` mode refer to your machine, so some will not work as written. |

To force the isolated mode explicitly, add `-e PLAYGROUND_MODE=dind`.

---

## Security

- **`--privileged` gives the container broad access to the host kernel.** Use this image on a personal or development machine. Do not run it on a shared or production server.
- **The terminal gives full control of the playground.** Anyone who can reach port 7681 can use it. If your machine is on a network you don't fully trust, bind the port to localhost or set `TTYD_CREDENTIAL`, as shown above.
- **Don't mount `/var/run/docker.sock`** unless you want `host` mode. Doing so lets anything inside the playground control your real Docker daemon.
- Containers inside the playground have internet access, and they download images from public registries. Treat what you pull and run like anything else you download.

---

## Troubleshooting

| Problem | What to try |
|---|---|
| Page at `localhost:7681` doesn't load | Wait 10 to 20 seconds and refresh. Check `docker logs docker-playground`. |
| Log says "Docker daemon failed to start" | You probably left out `--privileged`. Re-create the container with it. |
| "port is already allocated" | Another program uses 7681 (or 808x). Map a different host port, for example `-p 9000:7681`, then open `http://localhost:9000`. |
| Image pulls fail inside the playground | The playground needs internet access. Check your network, proxy and VPN settings. |
| An app on port 8080 isn't reachable from my browser | Make sure you published it with `-p 8080:<container-port>` and that the port is within 8080 to 8089. |
| Out of space or memory | Run `docker system prune -a` inside the playground, or reset it (see **Managing the playground**). On Docker Desktop, increase the disk and memory allotted to Docker. |
| Starting over | Use the **Reset everything** command above. |

---

## Notes and limitations

- Because it runs Docker inside Docker, performance is a little lower than running Docker directly, and the first start takes a few seconds.
- Each playground has its own image cache, so images are downloaded again, even if you already have them on your machine.
- Some features that need direct access to host hardware, such as GPUs, are not set up in this image.
- Intended for learning and experimenting, not for running production workloads.

---

## Supported architectures

`linux/amd64` and `linux/arm64`. Docker pulls the right one automatically for your machine, including Apple Silicon Macs.

## Tags

| Tag | Meaning |
|---|---|
| `latest` | The most recent release |
| `x.y.z` | A specific version, for example `1.0.0` |

## Feedback

Questions, bugs or ideas for new lessons? Add your repository or contact link here.
