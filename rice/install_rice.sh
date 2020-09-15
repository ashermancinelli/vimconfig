#!/usr/bin/env bash

set -x 

# Make config directories
if [[ ! -d $HOME/.config ]]
then
  mkdir -p $HOME/.config
fi

for d in `ls config`
do
  cp -a config/$d $HOME/.config/
done

# Install dotfiles
for f in dot_*
do
  cp $f $(echo $HOME/$f | sed 's/dot_/./')
done

# Install perl Urxvt extensions
[ -d ext ] || mkdir ext
[ -d $HOME/.config/urxvt/ext ] || mkdir -p $HOME/.config/urxvt/ext
git clone https://github.com/muennich/urxvt-perls ext/urxvt-perls
for f in keyboard-select clipboard url-select
do
  find ./ext -name "$f" | while read fn; do
    cp $fn $HOME/.config/urxvt/ext/$(basename $fn)
  done
done
