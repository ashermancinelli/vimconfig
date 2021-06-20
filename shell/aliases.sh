if [[ $OSTYPE =~ darwin* ]]
then
    alias ls="ls -G"
else
    alias ls="ls --color=always"
fi

# Make aliases (yes, I am bad at typing)
alias maek=make
alias mkae=make
alias meak=make
alias amka=make
alias akme=make

# Git aliases
alias gs='git status'
alias gc='git commit'
alias ga='git add'
alias gr='git remote -v'
alias gb='git branch'
alias gp='git push'
alias gck='git checkout'
alias gg='git log --graph --color --oneline'
alias gd='git diff --color'
alias ge='git-explore'

# Module aliases
alias ml='module load'
alias ms='module list'
alias mr='module rm'
alias ma='module avail'

# https://unix.stackexchange.com/questions/6/what-are-your-favorite-command-line-features-or-tricks/67#67
shopt -s cdspell        # try to correct typos in path
shopt -s dotglob        # include dotfiles in path expansion
shopt -s hostcomplete   # try to autocomplete hostnames
