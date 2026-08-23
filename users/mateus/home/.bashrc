#
# ~/.bashrc
#
[[ $- != *i* ]] && return

# ==== Funções ====
run() {
if [[ -z "$1" ]]; then
printf 'Comando: run <aplicativo>\n' >&2
return 1
fi

if ! command -v "$1" >/dev/null 2>&1; then
printf 'Aplicativo inválido: %s\n' "$1" >&2
return 127
fi

"$@" </dev/null >/dev/null 2>&1 &
disown
exit
}

_run() {
local cur="${COMP_WORDS[COMP_CWORD]}"
COMPREPLY=( $(compgen -c -- "$cur" | sort -u) )
}

complete -F _run run

ex() {
[[ -f "$1" ]] || {
echo "'$1' arquivo inválido."
return 1
}

case "$1" in
*.tar.bz2) tar xjf "$1" ;;
*.tar.gz) tar xzf "$1" ;;
*.bz2) bunzip2 "$1" ;;
*.rar) unrar x "$1" ;;
*.gz) gunzip "$1" ;;
*.tar) tar xf "$1" ;;
*.tbz2) tar xjf "$1" ;;
*.tgz) tar xzf "$1" ;;
*.zip) unzip "$1" ;;
*.Z) uncompress "$1" ;;
*.7z) 7z x "$1" ;;
*) echo "'$1' não é um formato suportado." ;;
esac
}

# ==== Aliases e Readline ====
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ls='ls -A1 --color=auto'
alias grep='grep --color=auto'
alias '..'='cd ..'
alias start='niri-session'
alias rmcache='rm -rf "$HOME"/.cache/*'

alias nrebuild='sudo nixos-rebuild switch --flake "$HOME"/Repos/System#pc --show-trace'
alias nupdate='nix flake update --flake "$HOME"/Repos/System'
alias ngc='sudo nix-collect-garbage'
alias ngcall='sudo nix-collect-garbage -d'
alias nopt='sudo nix-store --optimise'

alias qsbin='quickshell -p "$HOME"/Repos/System/users/mateus/home/.config/quickshell/';
alias qsstart='systemctl start --user quickshell.service';
alias qsstatus='systemctl status --user  quickshell.service';
alias qsrestart='systemctl restart --user quickshell.service';
alias qsstop='systemctl stop --user quickshell.service';

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
