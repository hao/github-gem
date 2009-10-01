#!bash
#
# bash completion support for the github gem.
#
# Written by Pedro Melo <melo@simplicidade.org>, October 1, 2009
#

_gh_commands='
  browse clone config create-from-local create
  fetch fetch_all fork home ignore info network
  pull-request pull track
'

_gh_gem_completion()
{
  local c=1 command partial
  ## Debug
  # echo
  # set | egrep '^COMP_(CWORD|WORDS|LINE|POINT)='
  
  while [ $c -lt $COMP_CWORD ]; do
    i="${COMP_WORDS[c]}"
    # echo "  iter i='$i', c is '$c'"
    case "$i" in
      -*) ;; # ignore options before command
      *) command="$i"; break ;;
    esac
		c=$((++c))
  done
  
  # echo "Got command '$command', c is '$c'"  
  if [ -z "$command" ] ; then
    partial=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $( compgen -W "$_gh_commands" -- $partial ) )
  else
    COMPREPLY=''
  fi
  
  return 0
}

complete -F _gh_gem_completion -o default gh
