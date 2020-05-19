if [[ $OSTYPE =~ darwin* ]]
then
    alias ls="ls -G"
else
    alias ls="ls --color=always"
fi

alias pip="python3 -m pip"
alias mkae=make
alias gs='git status'
alias gc='git commit'
alias ga='git add'
alias gr='git remote -v'
alias gb='git branch'
alias gp='git push'
alias gck='git checkout'
alias gg='git log --graph --color --oneline'
alias gd='git diff --color'

