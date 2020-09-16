
cat >>/dev/null <<EOD

Each install function presumes it will be called from the top-level directory
of this repo. There are various commands that have relatives paths which 
assume as much.

These define which commands may be passed to the top-level configure script.

EOD

install_zsh()
{
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
    cp ./shell/.clang-format ~/.clang-format
    cat ./shell/baserc.sh >> $rc
    [ -d $HOME/.shell/ ] || mkdir -p $HOME/.shell
    cp ./shell/* $HOME/.shell/
    for f in ./shell/*; do
      [[ -f ./shell/$f ]] && cp ./shell/$f $HOME/.shell/$f
    done
}

install_bash()
{
    [ -d $HOME/.oh-my-bash ] || \
        git clone git://github.com/ohmybash/oh-my-bash.git $HOME/.oh-my-bash
    cat ./shell/ohmybashrc.sh >> $rc
    cat ./shell/gitconfig > ~/.gitconfig
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

    for path in $(echo $PATH | tr ':' '\n'); do
      if [[ -f $path/ctags ]]; then
          if [[ $($path/ctags --version | grep Exuberant | wc -l) -eq 1 ]]; then
            ctags_path=$path
            echo "Found valid ctags at $path"
            break
          fi
      fi
    done
    if [[ -z "$ctags_path" ]]; then echo 'Could not find exuberant ctags...'; exit 1; fi
    
    [ -f ./tags-file ] && rm ./tags-file
    touch ./tags-file
    while read pth
    do
        echo "Searching path $pth for tags."
        find $pth -name '*' | grep -E '\.(h|hpp)$' | $ctags_path/ctags -f ./tags-file \
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
    cp vimfiles/vimrc_base $HOME/.vimrc
    [ -d $HOME/.vim ] || mkdir $HOME/.vim

    mkdir -p $HOME/.vim/syntax $HOME/.vim/after/syntax

    if [ -f ~/.vim/autoclose.vim ]
    then
      curl "https://www.vim.org/scripts/download_script.php?src_id=10873" > ~/.vim/autoclose.vim
    fi

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

    for i in $(ls vimfiles/*.vim)
    do
      cp $i $HOME/.vim/$(basename $i)
    done
}

install_tmux()
{
    echo
    echo Loading default tmux config...
    echo
    cp ./shell/tmux.conf $HOME/.tmux.conf
    if [[ ! -d ~/.tmux/plugins ]]
    then
      mkdir -p ~/.tmux/plugins
    fi

    if [[ ! -d ~/.tmux/plugins/tpm ]]
    then
      git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
}

install_emacs()
{
  ver=$(emacs --version | head -n 1 | cut -f3 -d' ' | cut -f1 -d.)
  if [[ $ver -lt 24 ]]
  then
    echo
    echo "Emacs version too low. Please use a newer version"
    echo "($ver < 24)"
    echo
  fi
  EMACS_HOME=$HOME/.emacs.d
  [ -d $EMACS_HOME ] || mkdir $EMACS_HOME
  cp ./shell/init.el $EMACS_HOME/init.el

  for path in $(echo $PATH | tr ':' '\n'); do
    if [[ -f $path/ctags ]]; then
        if [[ $($path/ctags --version | grep Exuberant | wc -l) -eq 1 ]]; then
          ctags_path=$path
          echo "Found valid ctags at $path"
          break
        fi
    fi
  done
  if [[ -z "$ctags_path" ]]; then echo 'Could not find exuberant ctags...'; return 1; fi
    
  [ -f ./tags-file ] && rm ./tags-file
  touch ./tags-file
  while read pth
  do
      echo "Searching path $pth for tags."
      $ctags_path/ctags -e -R --append -f ./tags-file $pth
  done < "./tags/$(uname -n)"
  mv ./tags-file $HOME/.emacs.d/tags
}

install_profiles()
{
  for i in profiles/*
  do 
    dn="$HOME/.profiles/$(basename $i)"
    if [ ! -d $dn ] 
    then
      mkdir $dn
      cp -R $i/* $dn
    fi
  done
}

install_modules()
{
  if type module; then
    if [[ $(module 2>&1 | grep GNU | wc -l) -gt 0 ]]; then
      echo "module use -a $cwd/modules/gnu/$(uname -n)" >> $HOME/.$(uname -n)
    else
      echo "module use -a $cwd/modules/luamod/$(uname -n)" >> $HOME/.$(uname -n)
    fi
  fi
}

install_rice()
{
  if [[ ! -v cwd ]]
  then
    echo Must set CWD in configure script...
    exit 1
  fi
  pushd $cwd/rice
  cat <<EOD

  NOTE: If you are only installing the rice, you can also just cd
  into $cwd/rice and run the install script there.

EOD
  ./install_rice.sh
  popd
}

install_fresh()
{
  pushd ~
  mkdir installs tarballs trash workspace
  touch $HOME/".$(uname -n)"
  wget https://raw.githubusercontent.com/dylanaraps/pfetch/master/pfetch -O $HOME/tarballs/pfetch
  wget https://raw.githubusercontent.com/6gk/fet.sh/master/fet.sh -O $HOME/tarballs/fet.sh
  curl https://sh.rustup.rs > $HOME/tarballs/rustup.sh

  for i in rustup.sh fet.sh pfetch
  do
    chmod +x $HOME/tarballs/$i
  done
  popd
}
