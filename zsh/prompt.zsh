autoload -Uz vcs_info
autoload -Uz add-zsh-hook
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats ' %b'

exists() {
  command -v "$1" >/dev/null 2>&1
}

bold() {
    echo -n "%B$1%b"
}

write() {
    local color content bold
    [[ -n "$1" ]] && color="%F{$1}" || color="%f"
    [[ -n "$2" ]] && content="$2" || content=""

    [[ -z "$2" ]] && content="$1"

    echo -n "$color"
    echo -n "$content"
    echo -n "%{%b%f%}"
}

is_git() {
    [[ $(command git rev-parse --is-inside-work-tree 2>/dev/null) == true ]]
}

PROMPT_SYMBOL='▷'

# indicate a job (for example, vim) has been backgrounded
# If there is a job in the background, display a ✱
suspended_jobs() {
    local sj
    sj=$(jobs 2>/dev/null | tail -n 1)
    if [[ $sj == "" ]]; then
        echo ""
    else
        echo "%{%F{208}%}✱%f"
    fi
}

node_prompt() {
    [[ -f package.json || -d node_modules ]] || return

    local version=''
    local node_icon='\ue718'

    if exists node; then
        version=$(node -v 2>/dev/null)
    fi

    [[ -n version ]] || return

    write '029' "$node_icon $version"
}

git_status_done() {
    # $3 is the stdout of the git_status command
    RPROMPT="$3 $(suspended_jobs)"
    zle reset-prompt
}

async_init
async_start_worker vcs_info
async_register_callback vcs_info git_status_done

add-zsh-hook precmd () {
    print -P "\n\e[1m%F{075}%~\e[0m $(node_prompt)"
    async_job vcs_info "$PWD"
}


export PROMPT='%(?.%F{006}.%F{009})$PROMPT_SYMBOL%f '
export RPROMPT="$(suspended_jobs)"
