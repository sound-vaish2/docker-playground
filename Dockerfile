FROM docker:dind

LABEL org.opencontainers.image.title="docker-playground" \
      org.opencontainers.image.description="Self-hosted Docker playground: browser terminal + private Docker daemon + guided lessons" \
      org.opencontainers.image.licenses="MIT"

# Browser terminal (ttyd) and common CLI tools for exploring.
# docker CLI, compose and buildx already ship with the docker:dind base image.
RUN apk add --no-cache \
      bash bash-completion ttyd \
      curl wget git jq tree vim nano tmux htop bind-tools

# Disable TLS on the inner daemon: it is only reachable through the unix socket
# inside this container.
ENV DOCKER_TLS_CERTDIR="" \
    PLAYGROUND_PORT=7681 \
    PLAYGROUND_MODE=auto

COPY entrypoint.sh /usr/local/bin/playground-entrypoint.sh
COPY lesson.sh     /usr/local/bin/lesson
COPY bashrc        /etc/playground.bashrc
COPY motd          /etc/playground.motd
COPY lessons/      /opt/lessons/

RUN chmod +x /usr/local/bin/playground-entrypoint.sh /usr/local/bin/lesson \
 && mkdir -p /workspace

WORKDIR /workspace
VOLUME /var/lib/docker
EXPOSE 7681

HEALTHCHECK --interval=15s --timeout=3s --start-period=20s --retries=3 \
  CMD curl -fsS -o /dev/null "http://127.0.0.1:${PLAYGROUND_PORT}/" || \
      curl -fsS -o /dev/null -u "${TTYD_CREDENTIAL}" "http://127.0.0.1:${PLAYGROUND_PORT}/" || exit 1

ENTRYPOINT ["playground-entrypoint.sh"]
