display-prompt() {
    date="$(date +%H:%M) "
    branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null \
        | sed 's:^refs/heads/::')
    [[ "$branch" != "" ]] && branch="%F{green}[$branch]%f "
    [ "$ZSH_DEPTH" -gt 1 ] && nested="%F{red}[$ZSH_DEPTH]%f "
    dir="$(basename "$(pwd)") "
    printf "%s$ " "${nested}${branch}${date}${dir}"
}

setopt PROMPT_SUBST
PROMPT='$(display-prompt)'

set-minute-timeout() {
    seconds="$(date +%S)"
    TMOUT="$((60 - $seconds + 1))"
}

function TRAPALRM() {
    zle reset-prompt
    set-minute-timeout
}

precmd_functions+=(set-minute-timeout)

set-prompt-marker() {
    printf '\x1b]133;A\x1b\\'
}
init_functions+=(set-prompt-marker)

