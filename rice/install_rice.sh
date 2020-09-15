#!/usr/bin/env bash

set -x 

if [[ ! -d $HOME/.config ]]
then
  mkdir -p $HOME/.config
fi

for d in `ls config`
do
  cp -a config/$d $HOME/.config/
done

for f in dot_*
do
  cp $f $(echo $HOME/$f | sed 's/dot_/./')
done
