#!/usr/bin/env bash

cp vimrc_base ~/.vimrc

[ -d ~/.vim/templates ] || mkdir ~/.vim/templates

for i in $(ls templates)
do
    cp templates/$i ~/.vim/templates/$i
done

for i in $(ls *.vim)
do
    cp $i ~/.vim/$i
done
