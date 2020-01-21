#!/usr/bin/env bash

cp vimrc_base ~/.vimrc

for i in $(ls *.vim *template*)
do
    cp $i ~/.vim/$i
done
