#!/usr/bin/env bash

rc="$(realpath $HOME/.$(basename $SHELL)rc)"
cwd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
install_prefix="$HOME/.local"
installs=()
source 'shell/install_functions.sh'

usage()
{
  cat <<EOD

  Usage:

  -p|--prefix         Sets install prefix. Default: $install_prefix
  -s|--shell-rc-path  Path to RC file for given shell. Default: $rc
  -d|--default        Installs ctags, vim, and bash
  --show              Show installation script for pacakge
  -i|--install        One or more of the following list, separated by commas with no spaces:

$(grep install_ shell/install_functions.sh \
  | grep -v base \
  | cut -f2 -d_ \
  | sed -e 's/[\(\)]//g' -e 's/^/       /')

EOD
}

if [[ $# -eq 0 ]]
then
  usage
  exit 1
fi

default=0
while [[ $# -gt 0 ]]
do
  if [[ $default == 1 ]]; then break; fi

  case $1 in
    -d|--default)
      installs=$(echo "ctags,vim,bash" | tr ',' '\n')
      default=1
      ;;
    -i|--install)
      installs=$(echo $2 | tr ',' '\n')
      shift; shift
      ;;
    -s|--shell-rc-path)
      rc=$2
      shift; shift
      ;;
    -p|--prefix)
      install_prefix=$2
      shift; shift
      ;;
    --show)
      opt=$2
      awk "/install_$opt/"'{
        nesting=0
        if(index($0,"{")!=0) nesting++;
        print
        getline
        for(;;) {
          print $0;
          if(index($0,"{")!=0) nesting++;
          if(index($0,"}")!=0) nesting--;
          if(nesting==0) break;
          getline
        }
      }' ./shell/install_functions.sh
      exit
      shift; shift
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

for install in $installs
do
  echo
  echo Installing $install
  echo
  eval "install_$install"
done
install_base

echo
echo All done!
echo
