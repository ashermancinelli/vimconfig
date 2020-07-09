cat >>/dev/null <<EOF

Profile:

This program is for quickly modifying your user environment.
Scripts under your 'PROFILEPATH' will be sourced.
You may also set dependencies for a given profile with a comment at the top of your file.

E.g:

~~~~~~~~~~~~~~{sh}
# ~/.profiles/my_hostname/gawk-5/load
#DEPENDS:gcc-7.4.0
export PATH=/path/to/gawk-5/bin:$PATH
~~~~~~~~~~~~~~

This will first load gcc-7.4.0 before setting the environment vars for
your gawk-5 package.

EOF

CURRENT_PROFILES=""

profile()
{
  PROFILEHOME=$HOME/.profiles/
  PROFILEPATH=$PROFILEHOME/$(uname -n)
  [ -d $PROFILEPATH ] || mkdir -p $PROFILEPATH > /dev/null 2>&1
  CURRENT_PROFILES=$PROFILEHOME/loaded/$$
  [ -d $CURRENT_PROFILES ] || mkdir -p $CURRENT_PROFILES > /dev/null 2>&1

  red="\e[31m"
  green="\e[32m"
  white="\e[97m"
  magenta="\e[96m"
  yellow="\e[33m"

  realname()
  {
    basename $(realpath $*)
  }

  load_fn()
  {
    pf=$(realname $1)
    echo Loading $pf...
    source $PROFILEPATH/$pf/load
    touch $CURRENT_PROFILES/$pf
  }

  load()
  {
    for dep in $(grep -E '^#DEPENDS:' $PROFILEPATH/$1/load \
      | cut -f2 -d':' \
      | sed 's/\s\+//g')
    do
      profile load $dep
    done
    load_fn $1
  }

  unload_fn()
  {
    pf=$(realname $1)
    source $PROFILEPATH/$pf/unload
    [ -f $CURRENT_PROFILES/$pf ] && rm $CURRENT_PROFILES/$pf
  }

  unload()
  {
    pf=$(realname $1)
    for dep in $(grep -E '^#DEPENDS:' $PROFILEPATH/$1/load | cut -f2 -d':')
    do
      profile unload $dep
    done
    unload_fn $pf
  }

  usage()
  {
    cat <<EOD

    Usage:

    avail       Show all available profiles
    list        Show all currently loaded profiles
    load|add    Load a single profile
    rm|unload   Unload a profile
    help        Show this message
    show        Show profile
    cleanup     Clean up temporary files. Cannot be ran with multiple
                instances of profile being used at the same time.

    Profile path for current system is $PROFILEPATH

EOD
  }

  if [[ $# -eq 0 ]]
  then
    usage
    return 1
  fi

  while [[ $# -gt 0 ]]
  do
    case $1 in
      cleanup)
        find $(dirname $CURRENT_PROFILES) \
          -type d \
          -and -not -name $$ \
          -and -not -name '*loaded' \
          -exec rm -rf {} \;
        ;;
      list)
        ls $CURRENT_PROFILES/
        shift
        ;;
      avail)
        [ -f /tmp/short ] && rm /tmp/short
        [ -f /tmp/long ] && rm /tmp/long
        find $PROFILEPATH -type l | while read p; do [ -f $p/load ] && basename $p; done >> /tmp/short
        find $PROFILEPATH -type d | while read p; do [ -f $p/load ] && basename $p; done >> /tmp/long

        if [[ $(wc -l /tmp/long | awk '{print$1}') -eq 0 ]]
        then
          echo -e "$red No profiles found."
          return 1
        else
          echo -e "$yellow"
          printf '\n\t%-30s %s\n' 'Long Names:' 'Short Names:'
          echo -e "$magenta"
          paste /tmp/long /tmp/short | awk -F' ' '{printf "\t%-30s %s\n", $1, $2}'
          echo -e "$white"
        fi
        shift
        ;;
      load|add)
        if [[ -z "$2" ]]; then
          echo -e "$red Please specify name of profile."
          return 1
        fi

      	shift
      	while [[ $# -gt 0 ]]; do
          if [[ ! -d $PROFILEPATH/$1 ]]; then
            echo -e "$red Profile not found."
            return 1
          else
            load $1
          fi
      	  shift
      	done
      	return 1
        ;;
      rm|unload)
        if [[ -z "$2" ]]
        then
          echo -e "$red Please specify name of profile."
          return 1
        fi

        if [[ ! -d $PROFILEPATH/$2 ]]; then
          echo -e "$red Profile not found."
          return 1
        else
          unload $2
        fi
        shift; shift
        ;;
      help)
        usage
        return 0
        ;;
      show)
        echo
        echo -e "$green Load profile:"
        echo
        cat $PROFILEPATH/$2/load
        if [[ -f $PROFILEPATH/$2/unload ]]
        then
          echo
          echo -e "$red Unload profile:"
          echo
          cat $PROFILEPATH/$2/unload
          echo -e "$white"
        fi
        shift; shift
        ;;
      *)
        usage
        return 1
        ;;
    esac
  done
}

complete -W 'avail list add load unload rm help show cleanup' profile
