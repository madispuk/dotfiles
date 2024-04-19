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

# use exa if available
if [[ -x "$(command -v exa)" ]]; then
  alias ll="exa --icons --git --long"
  alias l="exa --icons --git --all --long"
else
  alias l="ls -lah ${colorflag}"
  alias ll="ls -lFh ${colorflag}"
fi

alias vim="nvim"
