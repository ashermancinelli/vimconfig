cat >>/dev/null <<EOF

Profile:

This program is for quickly modifying your user environment.
Scripts under your 'profilepath' will be sourced.
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

current_profiles=""

profile()
{
  profilehome=$HOME/.profiles/
  profilepath=$profilehome/$(uname -n)
  [ -d $profilepath ] || mkdir -p $profilepath > /dev/null 2>&1
  current_profiles=$profilehome/loaded/$$
  [ -d $current_profiles ] || mkdir -p $current_profiles > /dev/null 2>&1

  red="\e[31m"
  green="\e[32m"
  white="\e[97m"

  load_fn()
  {
    echo Loading $1...
    source $profilepath/$1/load
    touch $current_profiles/$1
  }

  load()
  {
    for dep in $(grep -E '^#DEPENDS:' $profilepath/$1/load | cut -f2 -d':')
    do
      load_fn $dep
    done
    load_fn $1
  }

  unload_fn()
  {
    source $profilepath/$1/unload
    [ -f $current_profiles/$1 ] && rm $current_profiles/$1
  }

  unload()
  {
    for dep in $(grep -E '^#DEPENDS:' $profilepath/$1/load | cut -f2 -d':')
    do
      unload_fn $dep
    done
    unload_fn $1
  }

  usage()
  {
    cat <<EOD

    Usage:

    avail        Show all available profiles
    list         Show all currently loaded profiles
    load|add     Load a single profile
    rm|unload    Unload a profile
    help         Show this message
    show         Show profile

    Profile path for current system is $profilepath

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
      list)
          ls $current_profiles/
          shift
          ;;
      avail)
        profiles=$(ls "$profilepath")
        if [[ "$profiles" == "" ]]
        then
          echo -e "$red No profiles found."
          return 1
        else
          echo $profiles | tr ' ' '\n'
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
          if [[ ! -d $profilepath/$1 ]]; then
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
        if [[ "$2" == "" ]]
        then
          echo -e "$red Please specify name of profile."
          return 1
        fi

        if [[ ! -d $profilepath/$2 ]]; then
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
        cat $profilepath/$2/load
        echo
        echo -e "$red Unload profile:"
        echo
        cat $profilepath/$2/unload
        echo -e "$while"
        shift; shift
        ;;
      *)
        usage
        return 0
        ;;
    esac
  done
}

complete -W 'avail list load help show' profile
