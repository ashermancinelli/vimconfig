#!/usr/bin/env bash

if [[ $# -gt 0 ]]
then
    echo 'All arguments will be discarded'
fi

read -p 'Number of make jobs: ' n_jobs
n_jobs=${n_jobs:-1}

if [ -z "$INSTALL_LOCAL" ]
then
    read -p 'Set install prefix? [yn] ' y
    if [ "$y" == y ]
    then
        read -e -p "Enter prefix: " tmp
        install_prefix="${tmp/\~/$HOME}"
    else
        install_prefix="$HOME/.local"
    fi

    realpath $install_prefix || {
        echo "Instal prefix $install_prefix not found."
        exit 1
    }
else
    install_prefix=$INSTALL_LOCAL
fi

[ -d external ] || mkdir external
install_prefix="$(realpath $install_prefix)"
echo Using install prefix $install_prefix

export PATH="$PATH:$install_prefix/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$install_prefix/lib:$install_prefix/lib64"

read -p "Install vim defaults? [yn] " y
if [ "$y" == "y" ]
then
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
fi

read -p 'Install Dash? [yn] ' y
if [ "$y" == "y" ]
then
    echo
    echo 'Installing dash from source...'
    echo
    wget http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.10.2.tar.gz \
        -O external/dash.tar.gz
    pushd external
    tar -xvzf dash.tar.gz
    pushd $(ls | grep dash | grep -v tar)

    read -p "Install dash to $install_prefix? [yn] " y
    if [ "$y" == "y" ]
    then
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
    else
        make clean
        ./configure || \
        {
            echo Error configuring dash installation.
            exit 1
        }
        make -j $n_jobs || \
        {
            echo Error making dash...
            exit 1
        }
        echo
        echo 'Dash built'
        echo
    fi
    popd; popd
else
    echo
    echo 'Skipping dash installation'
    echo
fi

if type tmux
then
    echo
    echo Found tmux
    echo
else
    read -p 'Install tmux? [yn] ' y
    if [ "$y" == "y" ]; then
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
    fi
fi

echo
echo Loading default tmux config...
echo
cp tmux.conf $HOME/.tmux.conf

if type zsh
then
    echo
    echo Found zsh
    echo
else
    read -p 'Install zsh?' y
    if [ "$y" == "y" ]; then
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
    fi
fi

which ctags
if [ $? -ne 0 ]; then
    echo
    echo Ctags not found...
    echo
else
    read -p 'Generate new ctags? [yn] ' y
    if [ "$y" == "y" ]; then
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
            find $pth -name '*' | grep -E '\.(h|hpp)$' | \
                 ctags -f ./tags-file \
                 --verbose \
                 --append \
                 --c++-kinds=+p \
                 --fields=+iaS \
                 --extra=+q \
                 --language-force=C++ \
                 -I _GLIBCXX_NOEXCEPT \
                 -L -
        done < "./tags/$(uname -n)"
        mv ./tags-file $HOME/.vim/tags
        echo "set tags=$(realpath $HOME/.vim/tags),tags;" >> $HOME/.vimrc
    fi
fi

read -p 'Install oh-my-zsh? [yn] ' y
if [ "$y" == "y" ]
then
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    if [ ! -d $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting ]
    then
        git clone \
            https://github.com/zsh-users/zsh-syntax-highlighting.git \
            $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting
    fi
fi

read -p 'Install oh-my-bash? [yn] ' y
if [ "$y" == "y" ]
then
    [ -d $HOME/.oh-my-bash ] || \
        git clone git://github.com/ohmybash/oh-my-bash.git $HOME/.oh-my-bash
fi

rc="$(realpath $HOME/.$(basename $SHELL)rc)"
read -p "Default shell is $SHELL, default rc is $rc. Set different rc path? [yn] " y
if [ "$y" == "y" ]; then
    read -e -p 'Enter new rc path > ' rc
    rc=$(realpath "${rc/\~/$HOME}")
fi

echo '' > $rc

echo "vimconfigpath=$(realpath ./)" >> $rc

read -p "Install baserc to $rc? [yn] " y
if [ "$y" == "y" ]
then
    echo
    echo "Adding baserc to $rc"
    echo
    cat ./shell/baserc.sh >> $rc
fi

read -p "Add zshrc to $rc? [yn] " y
if [ "$y" == "y" ]
then
    echo
    echo "Adding zshrc to $rc"
    echo
    if [ ! -d $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]
    then
        git clone \
            https://github.com/zsh-users/zsh-autosuggestions \
            ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
    cat ./shell/zshrc.sh >> $rc
fi

read -p "Add oh-my-bash rcfile to $rc? [yn] " y
if [ "$y" == "y" ]
then
    echo
    echo "Adding oh-my-bash rcfile to $rc"
    echo
    cat ./shell/ohmybashrc.sh >> $rc
fi

read -p "Add $HOME/.local/ to PATH? [yn] " y
if [ "$y" == "y" ]
then
    echo 'export PATH=$PATH:$HOME/.local/bin' >> $rc
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.local/lib' >> $rc
fi

echo
echo All done!
echo
