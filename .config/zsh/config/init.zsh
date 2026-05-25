#       ╷               ╭─ ·    
# ╶─╮╭─╮├─╮   ╭─╮╭─╮┌─╮╶┼─╶╮ ╭─╮
# ╭─╯╰─╮│ │   │  │ ││ │ │  │ │ │
# ╰─╴╰─╯╵ ╵   ╰─╯╰─╯╵ ╵ ╵ ╶┴╴╰─┤
#                            ╰─╯

export ZSH_DEPTH="$((ZSH_DEPTH + 1))"
export COLORTERM="truecolor"
KEYTIMEOUT=1

source "$ZDOTDIR/config/util.zsh"
source "$ZDOTDIR/config/prompt.zsh"

function lazy-load() {
    function on-lazy-load() {
        array-remove init_functions on-lazy-load
        source "$ZDOTDIR/config/config.zsh"
        trigger-zle-line-init
    }
    init_functions+=(on-lazy-load)
    skip-postcmd
    trigger-precmd
}

lazy-load
beam-cursor
