#!/usr/bin/env bash

rc="$(realpath $HOME/.$(basename $SHELL)rc)"
install_prefix="$HOME/.local"
installs=()
source 'shell/install_functions.sh'

usage()
{
  cat <<EOD

  Usage:

  -p|--prefix         Sets install prefix. Default: $install_prefix
  -s|--shell-rc-path  Path to RC file for given shell. Default: $rc
  -i|--install        One or more of the following list, separated by commas with no spaces:
                        dash
                        zsh
                        bash
                        tmux
                        ctags
                        vim

EOD
}

while [[ $# -gt 0 ]]
do
  case $1 in
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
