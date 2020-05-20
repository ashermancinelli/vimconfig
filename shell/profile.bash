
profile()
{
  profilepath="$HOME/.profiles/$(uname -n)"
  [ -d $profilepath ] || mkdir -p $profilepath > /dev/null 2>&1
  current_profiles=/tmp/profile/$$
  [ -d $current_profiles ] || mkdir -p $current_profiles > /dev/null 2>&1

  create()
  {
    read -p 'Profile name: ' profilename
    [ -z "$profilename" ] && {
      echo "Please enter a name."
      return 1
    }
    echo Enter . on a single line to end input.
    while read -e -p "profile $profilename > " line
    do
      [ "$line" == "." ] && break
      echo $line >> $profilepath/$profilename
    done
    echo Created profile $profilename
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
          echo No profiles found.
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
          echo No profiles found.
          return 1
        else
          echo $profiles | tr ' ' '\n'
        fi
        shift
        ;;
      load)
        if [[ "$2" == "" ]]
        then
          echo Please specify name of profile.
          return 1
        fi
        source $profilepath/$2/load
        touch $current_profiles/$2
        shift; shift
        ;;
      unload)
        if [[ "$2" == "" ]]
        then
          echo Please specify name of profile.
          return 1
        fi
        source $profilepath/$2/unload
        [ -f $current_profiles/$2 ] && rm $current_profiles/$2
        shift; shift
        ;;
      help)
        usage
        return 0
        ;;
      show)
        cat $profilepath/$2
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
