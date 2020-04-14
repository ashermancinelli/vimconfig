#!/usr/bin/env bash

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

rm ~/.vimrc

which ctags
if [ $? -ne 0 ]; then
    echo
    echo Ctags not found...
    echo
else
    echo
    echo Generating Ctags...
    echo
    [ -f ./tags ] && rm ./tags
    touch ./tags
    while read pth
    do
        find $pth -name '*.h' | \
             ctags -f ./tags \
             --verbose \
             --append \
             --c++-kinds=+p \
             --fields=+iaS \
             --extra=+q \
             --language-force=C++ \
             -I _GLIBCXX_NOEXCEPT \
             -L -
    done < ./tags-paths
    mv ./tags ~/.vim/tags
    echo 'set tags=~/.vim/tags,tags;' > ~/.vimrc

fi

cat vimrc_base >> ~/.vimrc

