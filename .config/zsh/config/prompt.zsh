regenerate-prompt() {
    local nested="" branch="" date="$(date +%H:%M) "
    local dir="$(basename "$(pwd)") "
    local ref=$(git rev-parse --abbrev-ref HEAD 2>/dev/null | sed 's:^refs/heads/::')
    [[ -n "$ref" ]] && branch="[$ref] "
    [ "$ZSH_DEPTH" -gt 1 ] && nested="[$ZSH_DEPTH] "
    PROMPT_LENGTH=${#:-${nested}${branch}${date}${dir}$ }
    [[ -n "$ref" ]] && branch=$'%{\e[32m%}'"${branch}"$'%{\e[0m%}'
    [ "$ZSH_DEPTH" -gt 1 ] && nested=$'%{\e[31m%}'"${nested}"$'%{\e[0m%}'
    PROMPT="${nested}${branch}${date}${dir}$ "
}

precmd_functions+=(regenerate-prompt)

set-minute-timeout() {
    seconds="$(date +%S)"
    TMOUT="$((60 - $seconds + 1))"
}

function TRAPALRM() {
    regenerate-prompt
    zle reset-prompt
    set-minute-timeout
}

precmd_functions+=(set-minute-timeout)

set-prompt-marker() {
    printf '\n\x1b[A\x1b[s\x1b]133;A\x1b\\\x1b[u\x1b[%dG' "$((PROMPT_LENGTH + 1))"
}
# precmd_functions+=(set-prompt-marker)
init_functions+=(set-prompt-marker)

