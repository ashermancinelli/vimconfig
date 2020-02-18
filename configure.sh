#!/usr/bin/env bash

cp vimrc_base ~/.vimrc

[ -d ~/.vim ] || mkdir ~/.vim

if [ ! -d ~/.vim/autoload ]
then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "Run :PlugInstall when you first load up."
fi

[ -d ~/.vim/templates ] || mkdir ~/.vim/templates

for i in $(ls templates)
do
    cp templates/$i ~/.vim/templates/$i
done

for i in $(ls *.vim)
do
    cp $i ~/.vim/$i
done

zshrc=$(cat <<'EOF'
if [ -d \$HOME/.oh-my-zsh ]
then
    export ZSH="\$HOME/.oh-my-zsh"
    source \$ZSH/oh-my-zsh.sh

    ZSH_THEME="refined"
    plugins=(
        git 
        colored-man-pages 
        zsh-autosuggestions 
        zsh-syntax-highlighting
    )

    bindkey '^ ' autosuggest-accept
fi

alias python=python3
alias pip="python3 -m pip"

alias dc="docker-compose"
alias dcu="docker-compose up"
alias dcb="docker-compose build"
alias dcd="docker-compose down"

if which vim.my
then
    alias vim=vim.my
fi
EOF
)
