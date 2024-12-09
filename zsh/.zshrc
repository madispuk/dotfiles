export ZSH=$DOTFILES/zsh

if [[ -d $DOTFILES/zsh/functions ]]; then
    for func in $DOTFILES/zsh/functions/*(:t); autoload -U $func
fi

########################################################
# Configuration
########################################################

# initialize autocomplete
autoload -U compinit add-zsh-hook
compinit

## Add $DOTFILES/bin to PATH if it's not already included
if [[ ":$PATH:" != *":$HOME/$DOTFILES/bin:"* ]]; then
    export PATH="$HOME/$DOTFILES/bin:$PATH"
fi

# define the code directory
# This is where my code exists and where I want the `c` autocomplete to work from exclusively
if [[ -d ~/dev ]]; then
    export CODE_DIR=~/dev
fi

# display how long all tasks over 10 seconds take
export REPORTTIME=10
export KEYTIMEOUT=1              # 10ms delay for key sequences

setopt NO_BG_NICE
setopt NO_HUP                    # don't kill background jobs when the shell exits
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS
setopt LOCAL_TRAPS
setopt PROMPT_SUBST

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY          # write the history file in the ":start:elapsed;command" format.
setopt HIST_REDUCE_BLANKS        # remove superfluous blanks before recording entry.
setopt SHARE_HISTORY             # share history between all sessions.
setopt HIST_IGNORE_ALL_DUPS      # delete old recorded entry if new entry is a duplicate.

setopt COMPLETE_ALIASES

# make terminal command navigation sane again
bindkey "^[[1;5C" forward-word                      # [Ctrl-right] - forward one word
bindkey "^[[1;5D" backward-word                     # [Ctrl-left] - backward one word
bindkey '^[^[[C' forward-word                       # [Ctrl-right] - forward one word
bindkey '^[^[[D' backward-word                      # [Ctrl-left] - backward one word
bindkey '^[[1;3D' beginning-of-line                 # [Alt-left] - beginning of line
bindkey '^[[1;3C' end-of-line                       # [Alt-right] - end of line
bindkey '^[[5D' beginning-of-line                   # [Alt-left] - beginning of line
bindkey '^[[5C' end-of-line                         # [Alt-right] - end of line
bindkey '^?' backward-delete-char                   # [Backspace] - delete backward
bindkey '^Y' kill-line                              # [Ctrl-y] - remove until end of line
if [[ "${terminfo[kdch1]}" != "" ]]; then
    bindkey "${terminfo[kdch1]}" delete-char        # [Delete] - delete forward
else
    bindkey "^[[3~" delete-char                     # [Delete] - delete forward
    bindkey "^[3;5~" delete-char
    bindkey "\e[3~" delete-char
fi
bindkey "^A" vi-beginning-of-line
bindkey -M viins "^F" vi-forward-word               # [Ctrl-f] - move to next word
bindkey -M viins "^E" vi-add-eol                    # [Ctrl-e] - move to end of line
bindkey "^J" history-beginning-search-forward
bindkey "^K" history-beginning-search-backward

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# default to file completion
zstyle ':completion:*' completer _expand _complete _files _correct _approximate

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''


########################################################
# Plugin setup
########################################################

export ZPLUGDIR="$CACHEDIR/zsh/plugins"
[[ -d "$ZPLUGDIR" ]] || mkdir -p "$ZPLUGDIR"

source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source <(fzf --zsh)

if [[ -x "$(command -v fnm)" ]]; then
    eval "$(fnm env --use-on-cd)"
fi

[[ -e ~/.terminfo ]] && export TERMINFO_DIRS=~/.terminfo:/usr/share/terminfo

########################################################
# Setup
########################################################

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--color bg:-1,bg+:-1,fg:-1,fg+:#feffff,hl:#993f84,hl+:#d256b5,info:#676767,prompt:#676767,pointer:#676767"

# add color to man pages
export MANROFFOPT='-c'
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_md=$(tput bold; tput setaf 6)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)

# prefer zoxide over z.sh
if [[ -x "$(command -v zoxide)" ]]; then
    eval "$(zoxide init zsh --cmd cd --hook pwd)"
fi

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
else # macOS `ls`
    colorflag="-G"
fi

# If a ~/.zshrc.local exists, source it
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
# If a ~/.localrc zshrc exists, source it
[[ -a ~/.localrc ]] && source ~/.localrc

 export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

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

add-zsh-hook precmd () {
    print -P "\n\e[1m%F{075}%~\e[0m "
}

export PROMPT='%(?.%F{006}.%F{009})$PROMPT_SYMBOL%f '

########################################################
# Aliases
########################################################
#
# reload zsh config
alias reload!='RELOAD=1 source ~/.zshrc'

# jump up in dir tree
alias ..='cd ..'
alias ...='cd ../..'
alias ....="cd ../../.."
alias .....="cd ../../../.."

# pretty print some cmds
alias grep='grep --color=auto'
alias df='df -h' # disk free, in Gigabytes, not bytes
alias du='du -h -c' # calculate disk usage for a folder

# list the PATH separated by new lines
alias lpath='echo $PATH | tr ":" "\n"'

# recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"

alias cat='bat'

# use eza if available
if [[ -x "$(command -v eza)" ]]; then
  alias ll="eza --icons --git --long"
  alias l="eza --icons --git --all --long"
else
  alias l="ls -lah ${colorflag}"
  alias ll="ls -lFh ${colorflag}"
fi

alias vim="nvim"

alias gs="git s"
alias glog="git l"
alias gb="git branch"
alias gl="git pull"
