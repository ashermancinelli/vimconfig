#!/usr/bin/env bash

cp vimrc_base ~/.vimrc

[ -d ~/.vim ] || mkdir ~/.vim

if [ ! -d ~/.vim/autoload ]
then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +PlugInstall +q! +q!
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

type go
if [ $? -gt 0 ]; then
    echo 'Go not found... Not installing prologic/ed'
else
    echo
    echo Installing prologic/ed...
    echo

    test -d external || mkdir external
    pushd external
    git clone https://github.com/prologic/ed
    cd ed
    go build
    cp ed ~/.local/bin
    popd
fi

type tmux
if [ $? -ne 0 ]; then
    echo
    echo Installing tmux from tarball...
    echo
    wget https://github.com/tmux/tmux/releases/download/3.0/tmux-3.0.tar.gz \
        -O external/tmux-3.0.tar.gz || echo 'Check tmux url'
    pushd external
    tar -xvgf ./external/tmux-3.0.tar.gz
    pushd tmux-3.0
    ./configure --prefix=$HOME/.local
    make
    make install
    popd
    popd
fi

echo
echo Loading default tmux config...
echo
cp tmux.conf $HOME/.tmux.conf

echo
echo Setting up shell rc
echo
case "$SHELL" in
    *zsh )
        echo
        echo Found Zshell
        echo
        cat baserc zshrc > $HOME/.zshrc
        ;;
    *bash )
        echo
        echo Found Bash
        echo
        cat baserc bashrc > $HOME/.bashrc
        ;;
    * )
        echo
        echo Shell type not found...
        echo Not loading defaults.
        echo
esac
