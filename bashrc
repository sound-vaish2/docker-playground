[ -f /etc/profile ] && . /etc/profile
[ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

export PS1='\[\e[1;36m\]playground\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '
export HISTSIZE=5000

alias ll='ls -lah'
alias d='docker'
alias dc='docker compose'
alias dps='docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"'
alias lessons='lesson'

command -v docker >/dev/null && source <(docker completion bash 2>/dev/null) 2>/dev/null

cat /etc/playground.motd
echo "Mode: ${PLAYGROUND_MODE:-unknown}"
echo
