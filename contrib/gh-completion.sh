#!bash
#
# bash completion support for the github gem.
#
# Written by Pedro Melo <melo@simplicidade.org>, October 1, 2009
#

function _gh_gem_completion()
{
  local commands partial

  commands='
    browse clone config create-from-local create
    fetch fetch_all fork home ignore info network
    pull-request pull track
  '

  partial=${COMP_WORDS[COMP_CWORD]}
  
  ## Debug
  # echo
  # echo "COMP_CWORD is '$COMP_CWORD'"
  # echo "COMP_LINE is '$COMP_LINE'"
  # echo "COMP_POINT is '$COMP_POINT'"
  # echo "COMP_WORDBREAKS is '$COMP_WORDBREAKS'"
  # echo "COMP_WORDS is '$COMP_WORDS'"

  COMPREPLY=( $( compgen -W "$commands" -- $partial ) )

  return 0
}

complete -F _gh_gem_completion -o default gh
