#!/bin/zsh

# ZSH SETTINGS {{{

# allow comments in prompt
setopt INTERACTIVE_COMMENTS

# history
setopt HIST_IGNORE_SPACE
HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# }}}
# PROGRAM CONFIGS {{{

# fnm
command-exists "fnm" && eval "$(fnm env --use-on-cd --log-level error)"

# time
[ `uname` = Darwin ] && MAX_MEMORY_UNITS=KB || MAX_MEMORY_UNITS=MB
TIMEFMT=$'\n'"%J  %U user %*Es total %P cpu %M $MAX_MEMORY_UNITS mem"

# }}}
# VI MODE {{{

# vi bindings
bindkey -v

# vi cursor shape
zle -N zle-keymap-select
zle-keymap-select() {
    case "$KEYMAP" in
        main) beam-cursor  ;;
        *)    block-cursor ;;
    esac
    show-cursor
}

set-keymap() {
    zle -K "$1"
    zle-keymap-select
}

set-keymap-main() {
    zle && set-keymap main
}

init_functions+=(set-keymap-main)
preexec_functions+=(block-cursor)

# }}}
# VI KEYBINDINGS {{{

bind() {
    bindkey -M viins "$1" "$2"
    bindkey -M vicmd "$1" "$2"
}

# allow backspace past insert start
bindkey "^?" backward-delete-char

# move cursor to start/end of line with gh/gl
bindkey -M vicmd gh beginning-of-line
bindkey -M vicmd gl end-of-line
bindkey -M vicmd ga vi-add-eol
bindkey -M vicmd gm vi-match-bracket
bindkey -M vicmd t vi-yank

previous-prompt() {
    if [ -n "$TMUX" ]; then
        tmux copy-mode
        tmux send-keys -X previous-prompt
    fi
}
zle -N previous-prompt
bind '\e[A' previous-prompt

# make : act like opening commandline mode
commandline-mode() {
    zle kill-buffer
    zle vi-insert
}
zle -N commandline-mode
bindkey -M vicmd ":" commandline-mode

# the '-' is supposed to mimic '_' in vim
# however it is bugged for the first column
line-text-object() {
  MARK=0
  CURSOR=$#BUFFER
  REGION_ACTIVE=1
}
zle -N line-text-object
bindkey -M viopp "l" line-text-object

autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
    for c in {a,i}{\',\",\`}; do
        bindkey -M $m $c select-quoted
    done
done

autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
    for c in {a,i}${(s..)^:-'()[]{}<>bB\'}; do
        bindkey -M $m $c select-bracketed
    done
done

wrap-sub-shell() {
    while [[ "$BUFFER" = "" ]]; do
        zle up-history
    done
    BUFFER=" \$($BUFFER)"
    zle beginning-of-line
    set-keymap main
}
zle -N wrap-sub-shell
bindkey -M vicmd "$" wrap-sub-shell

# }}}
# VI INCREMENT {{{

VI_INCREMENT_PYTHON='''
import sys, re
_, cur, dir, buf = sys.argv
for m in re.finditer("(-?\\d+)", buf):
    if m.span()[1] <= int(cur): continue
    if "\n" in buf[int(cur):m.span()[1]]: break
    n = str(int(m.group(0)) + int(dir))
    buf = buf[:m.span()[0]] + n + buf[m.span()[1]:]
    print(m.span()[0] + len(n) - 1, f"[{buf}]", sep="\n")
'''

vi-increment-decrement() {
    exec 3< <(python3 -c "$VI_INCREMENT_PYTHON" "$CURSOR" "$1" "$BUFFER")
    read cursor <&3
    local buffer="$(cat <&3)"
    if [[ -n "$buffer" ]]; then
        BUFFER="${buffer:1:-1}"
        CURSOR="$cursor"
    fi
}

vi-increment() {
    vi-increment-decrement "1"
}

vi-decrement() {
    vi-increment-decrement "-1"
}

zle -N vi-increment
zle -N vi-decrement

bindkey -M vicmd `ctrl a` vi-increment
bindkey -M vicmd `ctrl x` vi-decrement

# }}}
# PLUGINS {{{

source "$ZDOTDIR/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh"
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# }}}
# ZSH SYSTEM CLIPBOARD SETTINGS {{{

# if buffer is empty then strip newlines from paste
smart-paste() {
    if [[ "$BUFFER" = "" ]]; then
        zle zsh-system-clipboard-vicmd-vi-put-before
        BUFFER="$(printf "%s" "$BUFFER")"
    else
        zle zsh-system-clipboard-vicmd-vi-put-after
    fi
}
zle -N smart-paste
bindkey -M vicmd p smart-paste

# }}}
# ZSH SYNTAX HIGHLIGHTING SETTINGS {{{

if [ -n "$ZSH_HIGHLIGHT_VERSION" ]; then
    ZSH_HIGHLIGHT_STYLES[comment]='fg=red'
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=green'
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=green'
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=green'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=green'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=green'
    ZSH_HIGHLIGHT_STYLES[command]='none'
    ZSH_HIGHLIGHT_STYLES[builtin]='none'
    ZSH_HIGHLIGHT_STYLES[precommand]='fg=yellow'
    ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=magenta'
    ZSH_HIGHLIGHT_STYLES[redirection]='fg=cyan,bold'
    ZSH_HIGHLIGHT_STYLES[arg0]='none'
    ZSH_HIGHLIGHT_STYLES[path]='none'
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=magenta'
fi

# }}}
# HOOKS {{{

save-history() {
    fc -W
}
postcmd_functions+=(echo)
postcmd_functions+=(save-history)

# }}}
# ACCEPT LINE {{{

accept-math-line() {
    expr.py "$1"
}

last-download() {
    echo "$HOME/Downloads/$(ls -t "$HOME/Downloads" | head -1)"
}

accept-dl-line() {
    eval "$(echo "$1" | sd '\$DL\b' '"$(last-download)"')"
}

read-cursor-position() {
  print -n '\e[6n' > /dev/tty
  IFS='[;' read -rd R _ "$1" "$2" < /dev/tty
}

read-all-input() {
    local buffer=""
    local char
    while true; do
        if read -t 0 -k 1 char < /dev/tty; then
            buffer="${buffer}${char}"
        else
            break
        fi
    done
    eval "$1"'="$buffer"'
}

reset-executing() {
    unset EXECUTING
}
precmd+=(reset-executing)

accept-dummy-line() {
    EXECUTING=1
    buffer="$BUFFER"
    BUFFER=""
    zle reset-prompt
    zle -R
    print -s "$buffer"
    trigger-zle-line-init
    echo "$buffer"
    command-exists preexec && preexec
    stty echo < /dev/tty
    stty icanon < /dev/tty
    "$1" "$buffer"
    stty -echo < /dev/tty
    stty -icanon < /dev/tty
    local input
    read-all-input input
    local row
    local col
    read-cursor-position row col
    if [ "$col" -gt 1 ]; then
        echo "\e[7m%\e[0m"
    fi
    zle .accept-line
    print -n '\e[A'
    zle -U "$input"
}

accept-line () {
    if [[ "$BUFFER" = "k" ]]; then
        BUFFER="$(history \
                | tail -n1 \
                | sed -E 's/^( |\t)*[0-9]*( |\t)*//')"
    fi
    if [[ "$BUFFER" = "" ]]; then
        echo
        trigger-precmd
        zle redisplay
        zle -R
        trigger-zle-line-init
    elif [[ "$BUFFER" =~ "^\\(*[0-9]" ]]; then
        accept-dummy-line accept-math-line
    elif [[ "$BUFFER" =~ '\$DL' ]]; then
        accept-dummy-line accept-dl-line
    else
        zle .accept-line
    fi
}

zle -N accept-line accept-line

# }}}
# SIGINT HANDLER {{{

sigint-handler() {
    if [ -z "$EXECUTING" ]; then
        if zle; then
            buffer="$BUFFER"
            zle kill-buffer
            zle -R
            printf '\x1b[90m'
            printf "$buffer"
            trigger-precmd
            clear-style
        fi
    else
        unset EXECUTING
    fi
}

register-sigint-handler() {
    function TRAPINT() {
        sigint-handler
        return 130
    }
}
register-sigint-handler
override_functions+=(register-sigint-handler)

# }}}
# FOCUS EVENTS {{{

on-focus() {
    zle reset-prompt
}

on-blur() {}

zle -N on-focus
zle -N on-blur

bind "\e[I" on-focus
bind "\e[O" on-blur

register-focus-events() {
    print -n '\e[?1004h'
}

unregister-focus-events() {
    print -n '\e[?1004l'
}

precmd_functions+=(register-focus-events)
preexec_functions+=(unregister-focus-events)

# }}}
# AUTOCOMPLETION {{{

# case insensitive completion
setopt nocaseglob
setopt no_list_ambiguous
setopt complete_in_word

autoload -U compinit && compinit
zstyle ':completion:*' complete-options true
zstyle ':completion:*' matcher-list '' \
    'm:{[:lower:]}={[:upper:]}' \
    'm:{[:lower:]}={[:upper:]} r:|?=**'

# }}}
# CDLS {{{

PREVIOUS_CD="$HOME"
cdls() {
    if [[ "$1" = "-" ]]; then
        echo "cd: $PREVIOUS_CD"
        cdls "$PREVIOUS_CD"
        return
    elif [[ "$1" = "" ]]; then
        cdls "$HOME"
        return
    elif [ ! -e "$1" ]; then
        echo "cd: no such file or directory: $1" > /dev/stderr
        return
    elif [ ! -d "$1" ]; then
        echo "cd: not a directory: $1" > /dev/stderr
        return
    fi
    PREVIOUS_CD=$(pwd)
    cd "$1" || return
    local num_files=$(ls | wc -l | sed 's/ //g')
    if [[ $num_files -gt 20 ]]; then
        echo "$num_files item(s)"
    else
        ls --color=auto
    fi
    [ -n "$TMUX" ] && tmux refresh-client -S
}

# }}}
# CATLS {{{

catls() {
    if [[ "$#" -eq "2" ]]; then
        if [[ -f "$2" ]]; then
            if [[ "$2" == *.png || "$2" == *.jpg ]]; then
                icat "$2"
            else
                cat "$2"
            fi
        else
            ls --color=auto "$2"
        fi
    else
        [[ "$1" = "cat" ]] && cat "${@:2}" || ls --color=auto "${@:2}"
    fi
}
alias cat="catls cat"
alias ls="catls ls"

# }}}
# LFCD {{{

lfcd () {
    local tmp="$(mktemp)"
    ~/.local/bin/lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        local dir="$(cat "$tmp")"
        \rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
alias lf=lfcd

# }}}
# JFIND {{{

expand-home() {
    local expanded="$1"
    expanded="${expanded/\~/$HOME}"
    expanded="${expanded/\$HOME/$HOME}"
    echo "$expanded"
}

jfind-source() {
    if [ -n "$TMUX" ]; then
        ~/.config/tmux/popup-jfind-source.sh
    else
        ~/.config/jfind/jfind-source.sh
    fi
    local dest=$(expand-home $(cat ~/.cache/jfind_out))
    if [ -d "$dest" ]; then
        BUFFER="cd '$dest'"
        zle accept-line
    elif [ -f "$dest" ]; then
        BUFFER="$EDITOR '$dest'"
        zle accept-line
    fi
}

zle -N jfind-source
bind `ctrl f` jfind-source

jfind-history() {
    if [ -n "$TMUX" ]; then
        ~/.config/tmux/popup-jfind-zsh-history.sh "$BUFFER"
    else
        ~/.config/jfind/jfind-zsh-history.sh "$BUFFER"
    fi
    local output=$(cat ~/.cache/jfind_out)
    if [ -n "$output" ]; then
        BUFFER="$output"
        zle .end-of-line
        set-keymap vicmd
    fi
}

zle -N jfind-history
bind `ctrl r` jfind-history

jfind-complete() {
    local last_char="${BUFFER: -1}"
    if [ "$last_char" = " " ]; then
        word=""
    else
        word=$(echo "$BUFFER" | awk '{print $NF}')
    fi
    if [ -n "$TMUX" ]; then
        ~/.config/tmux/popup-jfind-zsh-complete.sh "$word"
    else
        ~/.config/jfind/jfind-zsh-complete.sh "$word"
    fi
    local output=$(cat ~/.cache/jfind_out)
    if [ -n "$output" ]; then
        if [ "$word" = "" ]; then
            BUFFER="$BUFFER$output"
        else
            BUFFER=$(echo "$BUFFER" | sed "s/$word$/$output/")
        fi
        zle .end-of-line
        set-keymap vicmd
    fi
}

zle -N jfind-complete
bind `ctrl n` jfind-complete

# }}}
# WHATIS {{{

whatis() {
    [[ "$#" -eq 0 ]] && echo "Usage: whatis {command}" && return
    for arg in $@; do
        MANWIDTH=1000 man -P cat $arg \
            | head -20 \
            | grep -m 1 -E '^.*( |\t)+[–-]( |\t)+' \
            | sed -E "s/^.*( |\t)+[–-]( |\t)+/$arg - /"
    done
}

# }}}
# TMUX WRAPPER {{{

tmux() {
    if [[ "$#" -gt 0 ]]; then
        command tmux "$@"
    else
        local session="scratch"
        if command tmux ls -F "#S" 2>/dev/null | grep "^$session$" &>/dev/null; then
            ZSH_DEPTH=0 tmux attach -t "$session"
        else
            local color=$(awk "/^$session/"'{print $2}' ~/.config/tmux/sessions)
            ZSH_DEPTH=0 command tmux new -s "$session" \
                "tmux set-environment session_color '$color'; zsh"
        fi
    fi
}

# }}}
# CLEAR {{{

clear() {
    skip-postcmd
    command clear
    [ -n "$TMUX" ] && tmux clear-history
}

# }}}
# MK/MV CD {{{

mkdir() {
    command mkdir "$@"
    [ "$?" = 0 -a "$#" = 1 ] && LAST_MKDIR="$(realpath "$1")"
}

enter() {
    [ -z "$LAST_MKDIR" ] && exit 1
    cd "$LAST_MKDIR"
}

mkcd() {
    mkdir "$1" && cd "$1"
}

mvcd() {
    mv $@ && cd "$@[-1]"
}

dl() {
    (cd ~/Downloads && realpath "$(ls -t ~/Downloads | head -1)")
}
dl='"$(\cd ~/Downloads && realpath "$(ls -t ~/Downloads | head -1)")"'

argc() {
    echo "$#"
}

# }}}
# ALIASES {{{

yarn() echo "yarn sucks"
alias js-beautify='js-beautify -b end-expand'
alias massren="massren -d ''"
alias npx="EDITOR='$HOME/.config/tmux/popup-nvim.sh' npx"
alias python3="python3 -q"

alias vi=nvi
alias vim=nvim
alias mv="mv -i"
alias cd=cdls
alias rg="rg --smart-case --max-columns=1000"
alias rm="urm"

alias "q"=exit
alias "q!"=exit
alias ":q"=exit
alias ":q!"=exit

pager() "$PAGER"
editor() "$EDITOR"

# }}}
# INPLACE SED {{{

ised() {
    if [ "$1" = "undo" ]; then
        find . -type f -iname "*.sed.bak" -exec \
            bash -c 'mv {} $(basename -- {} .sed.bak)' \;
    elif [ "$1" = "confirm" ]; then
        find . -type f -iname "*.sed.bak" -exec rm {} \;
    else
        xargs -I{} sed -i ".sed.bak" -E "$1" {}
    fi
}

# }}}
# ZIP {{{

unzip() {
    if [ ! -e "$1" ]; then
        echo "not found: $1" > /dev/stderr
        return
    fi
    local outputDirectory="$(basename "$1" .zip)"
    if [ -e "$outputDirectory" ]; then
        echo "exists: $outputDirectory" > /dev/stderr
        return
    fi
    command unzip -d "$outputDirectory" "$1"
    if [ "$(ls "$outputDirectory" | wc -l)" -eq 1 ] && [ -d "$outputDirectory/$outputDirectory" ]; then
        echo "flattening..."
        tmp="$(mktemp -d)"
        trap 'rm -rf -- "$tmp"' EXIT
        mv "$outputDirectory/$outputDirectory/" "$tmp"
        mv "$tmp/$outputDirectory/"* "$outputDirectory"
    fi
}

zip() {
    if [ "$#" -ne 1 ]; then
        command zip "$@"
    else
        if [ ! -e "$1" ]; then
            echo "not found: $1" > /dev/stderr
            return
        fi
        if [ -e "$1.zip" ]; then
            echo "exists: $1.zip" > /dev/stderr
            return
        fi
        command zip -r "$1.zip" "$1"
    fi
}

# }}}
# DIFF {{{

diff() {
    if [ "$#" -eq 2 -a -f "$1" -a -f "$2" ]; then
        command diff -duw "$@" | page
    else
        command diff "$@"
    fi
}

# }}}
