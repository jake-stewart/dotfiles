show-cursor()   printf '\x1b[?25h'
hide-cursor()   printf '\x1b[?25l'
block-cursor()  printf '\x1b[1 q'
beam-cursor()   printf '\x1b[5 q'
clear-til-eol() printf '\x1b[0K'
clear-style()   printf '\x1b[m'

command-exists() {
    type "$1" &> /dev/null
}

trigger-precmd() {
    command-exists precmd && precmd
    for f in "${precmd_functions[@]}"; do
        "$f"
    done
}

trigger-preexec() {
    command-exists preexec && preexec
}

trigger-zle-line-init() {
    command-exists zle-line-init && zle-line-init
}

preexec() {
    for f in "${preexec_functions[@]}"; do
        eval "$f"
    done
}

zle -N zle-line-init
init_functions=()
zle-line-init() {
    for f in "${init_functions[@]}"; do
        eval "$f"
    done
}

ctrl() {
    printf "\\x$(printf "%.2x" \
        "$(($(printf "%d" "'$1") - 96))")"
}

# zsh has a concept of preexec -- a function called before every command
# it does not have a concept of postcmd.
# here, we use the precmd hook to introduce PostExec and PreCmd callbacks
postcmd() {}
skip-postcmd() {
    postcmd-handler() {
        postcmd-handler() {
            postcmd
            for f in "${postcmd_functions[@]}"; do
                eval "$f"
            done
        }
    }
}
skip-postcmd
precmd_functions+=(postcmd-handler)

override_functions=()
zle() {
    for f in "${override_functions[@]}"; do
        "$f"
    done
    builtin zle "$@"
}

