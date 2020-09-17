#!/bin/sh

shellcheck $0

set -o errexit
set -o nounset
set -o pipefail

cleanup()
{
  case $1 in
  0)
    echo Clean exit
    ;;
  *)
    echo "Got error: $*"
    exit $1
    ;;
  esac
}

trap clenup 0 SIGHUP SIGINT SIGQUIT SIGABRT SIGTERM

