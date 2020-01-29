#!/usr/bin/env bash

cp vimrc_base ~/.vimrc

[ -d ~/.vim ] || mkdir ~/.vim

[ -d ~/.vim/autoload ] || curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

[ -d ~/.vim/templates ] || mkdir ~/.vim/templates

for i in $(ls templates)
do
    cp templates/$i ~/.vim/templates/$i
done

for i in $(ls *.vim)
do
    cp $i ~/.vim/$i
done
