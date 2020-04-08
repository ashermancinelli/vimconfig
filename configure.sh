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
    ./configure \
        --prefix=$HOME/.local \
        CPPFLAGS="-I$HOME/.local/include" \
        LDFLAGS="-L$HOME/.local/lib"
    make -j 8
    make install
    popd
    popd
fi

echo
echo Loading default tmux config...
echo
cp tmux.conf $HOME/.tmux.conf

which zsh
if [ $? -ne 0 ]; then
    echo
    echo Installing Zsh from source...
    echo
    pushd external
    wget -O zsh.tar.xz https://sourceforge.net/projects/zsh/files/latest/download
    [ -d zsh ] || mkdir zsh
    tar xf zsh.tar.xz -C zsh --strip-components 1
    pushd zsh
    ./configure \
        --prefix=$HOME/.local \
        CPPFLAGS="-I$HOME/.local/include" \
        LDFLAGS="-L$HOME/.local/lib"
    make -j 8
    make install
    popd; popd
fi

echo
echo Setting up shell rc
echo
case "$SHELL" in
    *zsh )
        echo
        echo Found Zshell as default!
        echo
        ;;
    * )
        echo
        echo Zsh not found... Creating RC file to start Zsh on login.
        echo Not loading defaults.
        echo
        cat redirectrc > "$HOME/.$(basename $SHELL)rc"
        ;;
esac

cat baserc zshrc > $HOME/.zshrc
