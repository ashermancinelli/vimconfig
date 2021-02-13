if [ $TMUX ]; then
    source "$HOME/$(basename $SHELL)rc"
    clear
fi

function comp_inc_paths()
{
    if [ -z "$1" ]; then
        cmp="gcc"
    else
        cmp="$1"
    fi
    echo | $cmp -E -Wp,-v -
}

gentags()
{
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
  set -x
  $ctags_path/ctags -R --c++-kinds=+p --extra=+q --fields=+iaS $(pwd)
  set +x
}

init_cmake()
{
    if [ -z "$1" ]
    then
        srcdir=$(pwd)
    else
        srcdir=$(realpath $1) 
    fi

    mkdir -p \
        $srcdir/src/lib \
        $srcdir/src/driver \
        $srcdir/tests \
        $srcdir/build

    touch \
        $srcdir/CMakeLists.txt \
        $srcdir/build.sh \
        $srcdir/src/CMakeLists.txt \
        $srcdir/src/lib/CMakeLists.txt \
        $srcdir/src/driver/CMakeLists.txt \
        $srcdir/tests/CMakeLists.txt

    pushd ~/.vim/templates
    cat project.cmake warnings.cmake options-std17.cmake > $srcdir/CMakeLists.txt
    popd

    echo Finished creating cmake project in $srcdir
}

machine_env_file="$HOME/.$(uname -n)"
if [ -f "$machine_env_file" ]
then
    source $machine_env_file
fi

set -o emacs

# Add shell aliases
source $HOME/.shell/aliases.sh

export PYTHONSTARTUP=$HOME/.shell/startup.py
