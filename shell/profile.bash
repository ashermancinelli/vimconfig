
profile()
{
  profilepath="$HOME/.profiles/$(uname -n)"

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

    list    Show all available profiles
    load    Load a single profile
    new     Create a new profile
    help    Show this message

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
        profiles=$(ls "$profilepath")
        if [[ "$profiles" == "" ]]
        then
          echo No profiles found.
          return 1
        else
          echo $profiles
        fi
        shift
        ;;
      load)
        if [[ "$2" == "" ]]
        then
          echo Please specify name of profile.
          return 1
        fi
        source $profilepath/$2
        shift; shift
        ;;
      help)
        usage
        return 0
        ;;
      *)
        usage
        return 0
        ;;
    esac
  done
}
