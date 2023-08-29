#  oooooooooooo          oooo        
# d'""""""d888'          `888        
#       .888P    .oooo.o  888 .oo.   
#      d888'    d88(  "8  888P"Y88b  
#    .888P      `"Y88b.   888   888  
#   d888'    .P o.  )88b  888   888  
# .8888888888P  8""888P' o888o o888o 

# UTILS {{{

command-exists() {
    type "$1" &> /dev/null
}

show-cursor()   printf '\x1b[?25h'
block-cursor()  printf '\x1b[1 q'
beam-cursor()   printf '\x1b[5 q'
light-grey()    printf '\x1b[90m'
clear-til-eol() printf '\x1b[0K'
clear-style()   printf '\x1b[m'

# }}}
# COMPATABILITY {{{

export COLORTERM="truecolor"
KEYTIMEOUT=1

# }}}
# ZSH SETTINGS {{{

# allow comments in prompt
setopt INTERACTIVE_COMMENTS

# history
setopt HIST_IGNORE_SPACE
HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=999999999
SAVEHIST=$HISTSIZE

# }}}
# EXPORTS {{{

export EDITOR=nvim
export PAGER=nvimpager_wrapper

# }}}
# PROGRAM CONFIGS {{{

# react
# export NODE_OPTIONS="--openssl-legacy-provider"

# homebrew
export HOMEBREW_NO_EMOJI=1

# yarn
alias yarn='yarn --emoji false'

# js-beautify
alias js-beautify='js-beautify -b end-expand'

# java
# JAVA_VMS="$HOME/Library/Java/JavaVirtualMachines"
# export JAVA_HOME="$JAVA_VMS/openjdk-17.0.2/Contents/Home/"
# export JDTLS_HOME="/usr/local/Cellar/jdtls/1.11.0/libexec"

# fnm
command-exists "fnm" && eval "$(fnm env --use-on-cd)"

# time
[ `uname` = Darwin ] && MAX_MEMORY_UNITS=KB || MAX_MEMORY_UNITS=MB
TIMEFMT=$'\n'"%J  %U user %*Es total %P cpu %M $MAX_MEMORY_UNITS mem"

# }}}
# VI MODE {{{

# vi bindings
bindkey -v

# vi cursor shape
zle -N zle-keymap-select
function zle-keymap-select() {
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

# start prompt in insert mode
zle -N zle-line-init
zle-line-init() {
    set-keymap main
}

# block cursor for programs
preexec() block-cursor

# }}}
# VI KEYBINDINGS {{{

# allow backspace past insert start
bindkey "^?" backward-delete-char

# move cursor to start/end of line with gh/gl
bindkey -M vicmd gh beginning-of-line
bindkey -M vicmd gl end-of-line
bindkey -M vicmd gm vi-match-bracket

# make : act like opening commandline mode
commandline-mode() {
    zle kill-buffer
    zle vi-insert
}
zle -N commandline-mode
bindkey -M vicmd ":" commandline-mode
bindkey -M viopp -s "l" "-"

# }}}
# PLUGINS {{{

source "$HOME/.config/zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh"
source "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

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
# ZSH AUTOSUGGESTIONS SETTINGS {{{

if [ -n "$ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE" ]; then
    ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=()
    ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=()

    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    bindkey '^K' autosuggest-accept
fi

# }}}
# PATH {{{

# add ~/.bin to path
[[ -d $HOME/.bin ]] && \
    export PATH="$HOME/.bin:$PATH"

[[ -d $HOME/.local/bin ]] && \
    export PATH="$HOME/.local/bin:$PATH"

[[ -d $HOME/.cargo/bin ]] && \
    export PATH="$HOME/.cargo/bin:$PATH"

[[ -d $HOME/.dotnet/tools ]] && \
    export PATH="$HOME/.dotnet/tools:$PATH"

# }}}
# PROMPT {{{

setopt PROMPT_SUBST

branch_name() {
    branch=$(git symbolic-ref HEAD 2> /dev/null | sed 's:^refs/heads/::')
    [[ $branch != "" ]] && printf "%s" "[$branch] "
}

PROMPT='$(branch_name)$(basename "$(pwd)") $ '

display-prompt() {
    eval "printf \"$1$PROMPT$2\""
}

# }}}
# POST EXEC {{{

# zsh has a concept of preexec -- a function called before every command
# it does not have a concept of postcmd.
# here, we use the precmd hook to introduce PostExec and PreCmd callbacks
PreCmd() {}
PostExec() {}
skipPostExec() {
    precmd() {
        PreCmd
        precmd() {
            PostExec
            PreCmd
        }
    }
}

# echo new line after each command
PostExec() echo

# ignore the first precmd for post exec since no command has executed
skipPostExec

# }}}
# ACCEPT LINE {{{

accept-math-line() {
    # execute the expression using python
    echo
    python3 -c "print(${BUFFER})"
    # save history and accept an empty line make it usable
    print -s "$BUFFER"
    BUFFER=""
    zle .accept-line
    # do not print a newline with PostExec since accept-line already does this
    skipPostExec
}

accept-line () {
    if [[ "$BUFFER" =~ "^[0-9()].*" ]]; then
        # if the commandline is a mathematical expression, evaluate it
        accept-math-line
    elif [[ "$BUFFER" = "" ]]; then
        # if it is empty, redisplay the prompt two lines down. this is much
        # faster than accepting an empty line since it avoids all the
        # processing zsh has to do after a command has executed
        display-prompt "\n\n"
    else
        # otherwise, accept the line normally
        zle .accept-line
    fi
}

zle -N accept-line accept-line

# }}}
# TRAPINT {{{

# display ^C when hitting ctrl-c
TRAPINT() { 
    SIGINT=2
    if [[ "$1" == "$SIGINT" ]] && zle; then
        zle end-of-line
        light-grey
        printf "^C"
        clear-til-eol
        clear-style
        echo
        zle kill-buffer
        echo
        display-prompt
        set-keymap main
        return 0
    else
        return ${128+$1}
    fi
}

# }}}
# AUTOCOMPLETION {{{

# case insensitive completion
setopt nocaseglob
setopt no_list_ambiguous
setopt complete_in_word

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:]}={[:upper:]} r:|?=**'

complete-word() {
  _main_complete
  compstate[list]='list'
  local word=$PREFIX$SUFFIX
  (( compstate[unambiguous_cursor] <= ${#word} )) && compstate[insert]='menu'
}

bindkey '^I' complete-word

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
    num_files=$(ls | wc -l | sed 's/ //g')
    if [[ $num_files -gt 20 ]]; then
        echo "$num_files item(s)"
    else
        ls --color=auto
    fi
    [ -n "$TMUX" ] && tmux refresh-client -S
}
alias cd=cdls

# }}}
# CATLS {{{

catls() {
    if [[ "$#" -eq "2" ]]; then
        [[ -f "$1" ]] && cat "$2" || ls --color=auto "$2"
    else
        [[ "$1" = "cat" ]] && cat "${@:2}" || ls --color=auto "${@:2}"
    fi
}
alias cat="catls cat"
alias ls="catls ls"

# }}}
# LFCD {{{

lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
    ls
}
alias lf=lfcd

# }}}
# JFIND {{{

expand-home() {
    expanded=$1
    expanded=${expanded/\~/$HOME}
    expanded=${expanded/\$HOME/$HOME}
    echo "$expanded"
}

jfind_source() {
    if [ -n "$TMUX" ]; then
        ~/.config/tmux/popup-jfind-source.sh
    else
        ~/.config/jfind/jfind-source.sh
    fi
    dest=$(expand-home $(cat ~/.cache/jfind_out))
    if [ -d "$dest" ]; then
        BUFFER="cd '$dest'"
        zle accept-line
    elif [ -f "$dest" ]; then
        BUFFER="$EDITOR '$dest'"
        zle accept-line
    fi
}

zle -N jfind_source
bindkey -M vicmd '' jfind_source
bindkey '' jfind_source

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

tmux_wrapper() {
    if [[ "$#" -gt 0 ]]; then
        tmux "$@"
    else
        if tmux ls -F "#S" 2>/dev/null | grep "^main$" &>/dev/null; then
            tmux attach -t main
        else
            color=$(awk '/^main/{print $2}' ~/.config/tmux/sessions)
            tmux new -s main \
                "tmux set-environment session_color '$color'; zsh"
        fi
    fi
}
alias tmux=tmux_wrapper

# }}}
# CLEAR {{{

_clear=$(which clear)
clear() {
    skipPostExec
    $_clear
    tmux clear-history
}

# }}}
# REPEAT COMMAND {{{

# escape + k + enter = normal mode, load last history item, run it
# sometimes i type it too fast and type k + escape + enter
# this allows a single 'k' to run the previous command to solve this
repeat_command() {
    eval $(history | tail -n1 | awk '{$1=""; print $0}')
}
alias k=' repeat_command'

# }}}
# MK/MV CD {{{

mkcd() {
    mkdir "$1" && cd "$1"
}

mvcd() {
    mv $@ && cd "$@[-1]"
}


# }}}
# ALIASES {{{

alias vi=nvi
alias vim=nvim

# }}}

# vim: foldmethod=marker
