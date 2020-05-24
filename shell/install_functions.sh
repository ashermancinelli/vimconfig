
install_zsh()
{
    echo
    echo Installing Zsh from source...
    echo
    pushd external
    wget -O zsh.tar.xz https://sourceforge.net/projects/zsh/files/latest/download
    [ -d zsh ] || mkdir zsh
    tar xf zsh.tar.xz -C zsh --strip-components 1
    pushd zsh
    ./configure \
        --prefix=$install_prefix \
        CPPFLAGS="-I$install_prefix/include" \
        LDFLAGS="-L$install_prefix/lib"
    make -j $n_jobs
    make install
    popd; popd

    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    if [ ! -d $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting ]
    then
        git clone \
            https://github.com/zsh-users/zsh-syntax-highlighting.git \
            $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting
    fi

    if [ ! -d $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]
    then
        git clone \
            https://github.com/zsh-users/zsh-autosuggestions \
            ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
    cat ./shell/zshrc.sh >> $rc
}

install_base()
{
    cat ./shell/baserc.sh >> $rc
    [ -d $HOME/.shell/ ] || mkdir -p $HOME/.shell
    cp ./shell/* $HOME/.shell/
}

install_bash()
{
    [ -d $HOME/.oh-my-bash ] || \
        git clone git://github.com/ohmybash/oh-my-bash.git $HOME/.oh-my-bash
    cat ./shell/ohmybashrc.sh >> $rc
}

install_ctags()
{
    [ -f "./tags/$(uname -n)" ] || {
        echo
        echo "./tags/$(uname -n) tags file not found"
        echo
        exit 1
    }
    echo
    echo Generating Ctags...
    echo
    [ -f ./tags-file ] && rm ./tags-file
    touch ./tags-file
    while read pth
    do
        echo "Searching path $pth for tags."
        find $pth -name '*' | \
            grep -E '\.(h|hpp)$' | \
            ctags -f ./tags-file \
            --verbose \
            --append \
            --fields=+iaSmKz \
            --extra=+q \
            --c++-kinds=cdefgmstuv \
            --c-kinds=cdefgmstuv \
            --language-force="c++" \
            --langmap=c++:+.tcc. \
            -I "_GLIBCXX_BEGIN_NAMESPACE_VERSION _GLIBCXX_END_NAMESPACE_VERSION _GLIBCXX_VISIBILITY+" \
            -L -
    done < "./tags/$(uname -n)"
    mv ./tags-file $HOME/.vim/tags
    rm $HOME/.ctags
    cat > $HOME/.ctags <<EOD
--recurse=yes
--exclude=.git
--exclude=vendor/*
--exclude=node_modules/*
--exclude=db/*
--exclude=log/*
EOD
}


install_vim()
{
    cp vimrc_base $HOME/.vimrc
    [ -d $HOME/.vim ] || mkdir $HOME/.vim

    cp addressbook $HOME/.vim/
    mkdir -p $HOME/.vim/syntax $HOME/.vim/after/syntax

    wget https://raw.githubusercontent.com/bfrg/vim-cuda-syntax/master/syntax/cuda.vim \
      -P ~/.vim/syntax/cuda.vim

    # echo 'syntax match cudaKernelAngles "<<<\_.\{-}>>>"' > $HOME/.vim/after/syntax/cuda.vim
    echo 'highlight link cudaKernelAngles Operator' >> $HOME/.vim/after/syntax/cuda.vim
    echo 'highlight link cudaStorageClass Statement' >> $HOME/.vim/after/syntax/cuda.vim

    if [ ! -d $HOME/.vim/autoload ]
    then
        curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        vim +PlugInstall +q! +q!
    fi

    [ -d $HOME/.vim/templates ] || mkdir $HOME/.vim/templates

    for i in $(ls templates)
    do
        cp templates/$i $HOME/.vim/templates/$i
    done

    for i in $(ls *.vim)
    do
        cp $i $HOME/.vim/$i
    done
}

install_tmux()
{
    echo
    echo Installing tmux from tarball...
    echo
    wget https://github.com/tmux/tmux/releases/download/3.0/tmux-3.0.tar.gz \
        -O external/tmux-3.0.tar.gz || echo 'Check tmux url'
    pushd external
    tar -xvgf ./external/tmux-3.0.tar.gz
    pushd tmux-3.0
    ./configure \
        --prefix=$install_prefix \
        CPPFLAGS="-I$install_prefix/include" \
        LDFLAGS="-L$install_prefix/lib"
    make -j $n_jobs
    make install
    popd
    popd

    echo
    echo Loading default tmux config...
    echo
    cp tmux.conf $HOME/.tmux.conf
}

install_dash()
{
    echo
    echo 'Installing dash from source...'
    echo
    wget http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.10.2.tar.gz \
        -O external/dash.tar.gz
    pushd external
    tar -xvzf dash.tar.gz
    pushd $(ls | grep dash | grep -v tar)

    make clean
    ./configure --bindir=$install_prefix/bin --mandir=$install_prefix/share/man || \
    {
        echo Error configuring dash installation.
        exit 1
    }
    make -j $n_jobs || \
    {
        echo Error making dash...
        exit 1
    }
    make install || \
    {
        echo Error installing dash...
        exit 1
    }
    echo
    echo 'Dash installed'
    echo
    popd; popd
}
