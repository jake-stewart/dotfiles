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
        shift -p init_functions
        source "$ZDOTDIR/config/config.zsh"
        skip-postcmd
        trigger-precmd
        trigger-zle-line-init
    }
    init_functions+=(on-lazy-load)
}

lazy-load
beam-cursor
