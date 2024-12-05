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
