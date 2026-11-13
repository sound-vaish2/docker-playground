#!/bin/bash
# Starts (or attaches to) a Docker daemon, then serves a terminal in the browser.
#
# PLAYGROUND_MODE:
#   auto    - use the host socket if /var/run/docker.sock is mounted, otherwise start a private daemon (DinD)
#   dind    - always start a private daemon (needs --privileged)
#   host    - require the mounted host socket; no private daemon
set -u

PORT="${PLAYGROUND_PORT:-7681}"
MODE="${PLAYGROUND_MODE:-auto}"
SOCK=/var/run/docker.sock

if [ "$MODE" = "auto" ]; then
  if [ -S "$SOCK" ]; then MODE=host; else MODE=dind; fi
fi

case "$MODE" in
  host)
    if [ ! -S "$SOCK" ]; then
      echo "PLAYGROUND_MODE=host but $SOCK is not mounted (-v /var/run/docker.sock:/var/run/docker.sock)" >&2
      exit 1
    fi
    echo "Mode: HOST - commands act on the host's Docker daemon."
    ;;
  dind)
    echo "Mode: SANDBOX - starting a private Docker daemon..."
    dockerd-entrypoint.sh >/var/log/dockerd.log 2>&1 &
    for _ in $(seq 1 60); do
      docker info >/dev/null 2>&1 && break
      sleep 1
    done
    if ! docker info >/dev/null 2>&1; then
      echo "Docker daemon failed to start. Did you run with --privileged?" >&2
      tail -n 30 /var/log/dockerd.log >&2
      exit 1
    fi
    ;;
  *)
    echo "Unknown PLAYGROUND_MODE '$MODE' (use auto|dind|host)" >&2
    exit 1
    ;;
esac

export PLAYGROUND_MODE="$MODE"

TTYD_ARGS=(-W -p "$PORT" -t fontSize=15 -t 'theme={"background":"#1e1e2e"}')
[ -n "${TTYD_CREDENTIAL:-}" ] && TTYD_ARGS+=(-c "$TTYD_CREDENTIAL")

echo "Playground ready: open http://localhost:${PORT} (mapped host port)"
exec ttyd "${TTYD_ARGS[@]}" bash --rcfile /etc/playground.bashrc -i
