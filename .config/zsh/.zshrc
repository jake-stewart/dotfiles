#  oooooooooooo          oooo        
# d'""""""d888'          `888        
#       .888P    .oooo.o  888 .oo.   
#      d888'    d88(  "8  888P"Y88b  
#    .888P      `"Y88b.   888   888  
#   d888'    .P o.  )88b  888   888  
# .8888888888P  8""888P' o888o o888o 
                                   
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
# PROGRAM CONFIGS {{{

# react
# export NODE_OPTIONS="--openssl-legacy-provider"

# homebrew
export HOMEBREW_NO_EMOJI=1

# java
# JAVA_VMS="$HOME/Library/Java/JavaVirtualMachines"
# export JAVA_HOME="$JAVA_VMS/openjdk-17.0.2/Contents/Home/"
# export JDTLS_HOME="/usr/local/Cellar/jdtls/1.11.0/libexec"

command_exists() {
    type "$1" &> /dev/null
}

# fnm
command_exists "fnm" && \
    eval "$(fnm env --use-on-cd)"

# time
[ `uname` = Darwin ] && MAX_MEMORY_UNITS=KB || MAX_MEMORY_UNITS=MB
TIMEFMT=$'\n'"%J  %U user %*Es total %P cpu %M $MAX_MEMORY_UNITS mem"

# }}}
# VI MODE {{{

# use vi bindings
bindkey -v

# Change cursor shape for different vi modes.
zle -N zle-keymap-select
function zle-keymap-select() {
    if [[ ${KEYMAP} == vicmd ]] ||
        [[ $1 = 'block' ]]; then
        echo -ne '\e[1 q'
    elif [[ ${KEYMAP} == viopp ]];then
        echo -ne '\e[3 q'
    elif [[ ${KEYMAP} == main ]] ||
        [[ ${KEYMAP} == viins ]] ||
        [[ ${KEYMAP} = '' ]] ||
        [[ $1 = 'beam' ]]; then
        echo -ne '\e[5 q'
    fi
}

# start prompt in insert mode
zle -N zle-line-init
zle-line-init() {
    zle -K viins
}

# Use beam shape cursor on startup
echo -ne '\e[5 q'

# use block shape cursor in programs
preexec() {
    echo -ne '\e[1 q'
}

# }}}
# KEYBINDINGS {{{

# allow backspace past insert start
bindkey "^?" backward-delete-char

# move cursor to start/end of line with gh/gl
bindkey -M vicmd gh beginning-of-line
bindkey -M vicmd gl end-of-line
bindkey -M vicmd gm vi-match-bracket

# make : act like opening commandline mode
commandline_mode() {
    zle kill-buffer;
    zle vi-insert;
}
zle -N commandline_mode
bindkey -M vicmd : commandline_mode
bindkey -M viopp -s l -

# }}}
# PLUGINS {{{

source "$HOME/.config/zsh/zsh-system-clipboard/zsh-system-clipboard.zsh"
source "$HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# }}}
# ZSH SYNTAX HIGHLIGHTING SETTINGS {{{

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

# }}}
# ZSH AUTOSUGGESTIONS SETTINGS {{{

ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=()
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=()

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^K' autosuggest-accept

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

# parse commands in prompt string
setopt PROMPT_SUBST
PROMPT='$(branch_name)$(basename $(pwd)) $ '

# prepend '[branch]' to the start of prompt if in git repo
branch_name() {
    branch=$(git symbolic-ref HEAD 2> /dev/null | sed 's:^refs/heads/::')
    [[ $branch != "" ]] && printf "%s" "[$branch] "
}

# show newline after every command except first & clear
skip_precmd() {
    precmd () {
        precmd() {
            echo
        }
    }
}

precmd() {
    printf '\x1b[H\x1b[2J'
    precmd() {
        echo
    }
}

# make ctrl+c print ^C
TRAPINT() { 
    if [ "${KEYMAP}" = "main" -o "${KEYMAP}" = "viins" -o "${KEYMAP}" = "vicmd" -o "${KEYMAP}" = "viopp" ]; then
        zle end-of-line
        echo "\e[90m^C\e[K\e[m"
        zle kill-buffer
        echo -n "\r\e[K"
        return 128
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
  _main_complete;
  compstate[list]='list';
  local word=$PREFIX$SUFFIX
  (( compstate[unambiguous_cursor] <= ${#word} )) && compstate[insert]='menu';
}

bindkey '^I' complete-word

# }}}
# FUNCTIONS {{{

alias ls='ls --color=auto'

sane() {
    stty sane
    printf "\x1b[?25h"
}

mkcd() {
    mkdir "$1" && cd "$1"
}

expand_home() {
    expanded=$1
    expanded=${expanded/\~/$HOME}
    expanded=${expanded/\$HOME/$HOME}
    echo "$expanded"
}

jfind_source() {
    if [ -n "$TMUX" ]; then
        ~/.config/tmux/popup-jfind-source.sh
    else
        ~/.config/jfind/jfind-source.sh ~/.cache/jfind_out
    fi
    dest=$(expand_home $(cat ~/.cache/jfind_out))
    if [ -d "$dest" ]; then
        skip_precmd
        zle kill-buffer
        print -s "cd '$dest'"
        echo "cd \e[32m'$dest'\e[0m"
        cd "$dest";
        [ "$dest" = "$HOME/Downloads" ] && ls -trl || ls
        zle accept-line
    elif [ -f "$dest" ]; then
        skip_precmd
        zle kill-buffer
        print -s "$EDITOR '$dest'"
        echo "$EDITOR \e[32m'$dest'\e[0m"
        $EDITOR "$dest"
        zle accept-line
    fi
}

zle -N jfind_source
bindkey -M vicmd '' jfind_source
bindkey '' jfind_source

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

cd_wrapper() {
    if [[ "$1" = "-" ]]; then
        printf "cd: "
        cd -
        ls
        [ -n "$TMUX" ] && tmux refresh-client -S
        return
    fi
    [ ! -n "$1" ] && 1=$HOME
    [ ! -e "$1" ] && echo "cd: no such file or directory: $1" > /dev/stderr && return
    [ ! -d "$1" ] && echo "cd: not a directory: $1" > /dev/stderr && return
    cd "$1" && ls && [ -n "$TMUX" ] && tmux refresh-client -S 
}

mvcd() {
    mv $@ && cdls "$@[-1]"
}

catls() {
    if [[ "$#" -eq "1" ]]; then
        [[ -f "$1" ]] && cat "$1" || ls "$1";
    else
        cat "$@"
    fi
}

lscat() {
    if [[ "$#" -eq "1" ]]; then
        [[ -f "$1" ]] && cat "$1" || ls "$1";
    else
        ls "$@"
    fi
}

whatis() {
    [[ $? -eq 1 ]] && echo "Usage: whatis {command}" && exit 1;
    for arg in $@; do
        man -P cat $arg \
            | awk 'name==1{print $0; exit} /N.*A.*M.*E[^A-Za-z]*$/{name=1}' \
            | sed 's/^[ \t]*//g'
    done
}

repeat_last_command() {
    $(history | tail -n1 | awk '{$1=""; print $0}')
}

tmux_wrapper() {
    if [[ "$#" -gt 0 ]]; then
        tmux "$@"
    else
        if tmux list-sessions -F "#S" 2>/dev/null | grep "^main$" &>/dev/null; then
            tmux attach -t main
        else
            color=$(awk '/^main/{print $2}' ~/.config/tmux/sessions)
            tmux new -s main \
                "tmux set-environment session_color '$color'; zsh"
        fi
    fi
}

# }}}
# ALIASES {{{

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias k=' repeat_command'
alias vi=nvi
alias vim=nvim
alias cd=cd_wrapper
alias tmux=tmux_wrapper
alias netcli=/Applications/NetLinkz/peer/netcli
alias clear="skip_precmd; clear"
alias jmatrix="jmatrix --bg '#262832' --trail 12"
alias lf=lfcd
alias ls=lscat
alias cat=catls
alias js-beautify='js-beautify -b end-expand'
alias yarn='yarn --emoji false'
alias ctags="`brew --prefix`/bin/ctags"

# }}}
# EXPORTS {{{

export EDITOR=nvim
export PAGER=nvimpager_wrapper

# }}}

# vim: foldmethod=marker
