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

function modload()
{
    echo module purge
    module list 2>&1 \
        | tr ' ' '\n' \
        | awk '!/^[0-9]/' \
        | sort \
        | grep '/' \
        | sed 's/^/module load /'
}

function modstr()
{
    module list 2>&1 \
        | tr ' ' '\n' \
        | awk '!/^[0-9]/' \
        | sort \
        | grep '/' \
        | tr '\n' ' ' \
        | sed 's/^ +//' \
        | sed 's/ \+$//' \
        | sed 's/\//_/g' \
        | sed 's/ /-/g' \
        | sed 's/$/\n/g'
}

function mc()
{
    dirname="."
    editor="vim -c 'exe \"normal! gg/HEAD\" | normal n'"

    while [[ $# -gt 0 ]]
    do
        case $1 in
            -h|--help)
                echo Options:
                echo
                echo -d|--dirname
                echo -e|--editor
                echo -s|--search
                echo
                echo 'dirname default: .'
                echo 'editor default: vim'
                return 0
                ;;
            -d|--dirname)
                shift
                dirname=$1
                shift
                echo Using dirname $dirname
                ;;
            -e|--editor)
                shift
                editor=$1
                echo Using editor $editor
                shift
                ;;
            -s|--search)
                grep -r '^=\{7\}$' . || {
                echo 'No conflicts found'
            }
            return 0
            ;;
        *)
            echo Use -h for help
            return 1
            ;;
        esac
    done

    grep -r '^=\{7\}$' $dirname || {
        echo 'No conflicts found'
        return 0
    }

    files=$(grep -r '^=\{7\}$' $dirname \
        | cut -d':' -f1 \
        | sort \
        | uniq \
        | tr '\n' ' ')

    eval "$editor $files"
}

function vfind()
{
    editor="vim"
    dir=$(pwd)
    exp=""

    while [[ $# -gt 0 ]]
    do
        case $1 in
            -E|--editor)
                editor=$2
                shift; shift
                ;;
            -d|--directory)
                dir=$2
                shift; shift
                ;;
            -e|--expression)
                exp=$2
                shift; shift
                ;;
            *)
                echo Opions:
                echo
                echo '-E|--editor      [default: vim]'
                echo '-d|--directory   [default: .]'
                echo '-e|--expression  [default: ]'
                return 1
        esac
    done

    [ -z "$exp" ] && {
    echo 'Must pass expression'
    return 1
}

files=$(find $dir -regextype posix-extended -regex $exp \
    | tr '\n' ' ')
eval "$editor $files"
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
