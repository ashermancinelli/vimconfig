
profile()
{
  profilepath="$HOME/.profiles/$(uname -n)"
  [ -d $profilepath ] || mkdir -p $profilepath > /dev/null 2>&1
  current_profiles=/tmp/profile/$$
  [ -d $current_profiles ] || mkdir -p $current_profiles > /dev/null 2>&1

  red="\e[31m"
  green="\e[32m"
  white="\e[97m"

  create()
  {
    read -p 'Profile name: ' profilename
    [ -z "$profilename" ] && {
      echo "Please enter a name."
      return 1
    }
    mkdir -p "$profilepath/$profilename"
    echo Enter . on a single line to end input.

    while read -e -p "load $profilename > " line
    do
      [ "$line" == "." ] && break
      echo $line >> "$profilepath/$profilename/load"
    done

    while read -e -p "unload $profilename > " line
    do
      [ "$line" == "." ] && break
      echo $line >> "$profilepath/$profilename/unload"
    done
    echo Created profile $profilename
  }

  load_fn()
  {
    source $profilepath/$1/load
    touch $current_profiles/$2
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
      load_fn $dep
    done
    unload_fn $1
  }

  usage()
  {
    cat <<EOD

    Usage:

    avail   Show all available profiles
    list    Show current profiles
    load    Load a single profile
    unload  Unload a profile
    new     Create a new profile
    help    Show this message
    show    Show profile

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
      new)
        create
        shift
        ;;
      list)
        profiles=$(ls "$current_profiles")
        if [[ "$profiles" == "" ]]
        then
          echo -e "$red No profiles found."
          return 1
        else
          echo $profiles | tr ' ' '\n'
        fi
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
      load)
        if [[ "$2" == "" ]]; then
          echo -e "$red Please specify name of profile."
          return 1
        fi

        if [[ ! -d $profilepath/$2 ]]; then
          echo -e "$red Profile not found."
          return 1
        else
          load $2
        fi
        shift; shift
        ;;
      unload)
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

complete -W 'avail list load new help show' profile
