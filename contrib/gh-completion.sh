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

_gh_trace()
{
  if [ -n "$GH_TRACE_TO" ] ; then
    echo "$@" >> "$GH_TRACE_TO"
  fi
}

_gh_comp()
{
  local possible_comps=$1
  local partial=$2
  _gh_trace "Got possibles '$possible_comps', partial '$partial'"
  
  if [ -z "$partial" ] ; then
    partial=${COMP_WORDS[COMP_CWORD]}
    _gh_trace "No partial given, using last word '$partial'"
  fi
  
  COMPREPLY=( $( compgen -W "$possible_comps" -- $partial ))
}

_gh_comp_opts()
{
  local word_comps=$1
  local opts_comps=$2
  local partial=$3
  _gh_trace "Got words '$word_comps' and opts '$opts_comps', partial '$partial'"
  
  if [ -z "$partial" ] ; then
    partial=${COMP_WORDS[COMP_CWORD]}
    _gh_trace "No partial given, using last word '$partial'"
  fi
  
  case "$partial" in
    -*)  _gh_comp "$opts_comps" "$partial" ;;
    *)   _gh_comp "$word_comps" "$partial" ;;
  esac
}

_gh_next_word()
{
  local c=${1:-1} i
  
  while [ $c -lt $COMP_CWORD ]; do
    i="${COMP_WORDS[c]}"
    _gh_trace "  iter i='$i', c is '$c'"
    case "$i" in
      -*) ;; # ignore options before command
      *)  echo $i; break ;;
    esac
		c=$((++c))
  done
}

_gh_find_subcommand ()
{
	local c=$1 subcommands=$2
	_gh_trace "Find subcommand of '$2' (starts at $c)"

	while [ $c -lt $COMP_CWORD ]; do
		local word="${COMP_WORDS[c]}" sc
		_gh_trace "  iter check word '$word' at '$c'"
		for sc in $2; do
  		_gh_trace "    == '$sc'?"
			if [ "$sc" = "$word" ]; then
    		_gh_trace "Word '$word' is a subcommand"
				echo "$sc"
				return
			fi
		done
		c=$((++c))
	done
}

_gh_remote_users()
{
  git remote -v | egrep '//github.com/.+ \(fetch\)' | cut -f1
}

_gh_remote_user_branches()
{
  local user=$1
  git branch -r | grep "$user/" | cut -f2 -d/
}

_gh_browse_completion()
{
  local user=$( _gh_next_word $1 )
  
  if [ -z "$user" ] ; then
    local users=$( _gh_remote_users )
    _gh_trace "No users, complete from '$users'"
    _gh_comp "$users"
  else
    local branches=$( _gh_remote_user_branches $user )
    _gh_trace "Got user as '$user', complete from branches"
    _gh_comp "$branches"
	fi
}

_gh_clone_completion()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  _gh_trace "Completing 'clone', cur word is '$cur'"

	case "$cur" in
    -*) _gh_comp "--ssh"; return;;
	esac

  _gh_trace "The '$cur' is not an option, so don't complete"
	COMPREPLY=()
}

_gh_create_completion()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  _gh_trace "Completing 'create', cur word is '$cur'"

	case "$cur" in
    -*) _gh_comp "
          --rdoc
          --rst
          --markdown
          --mdown
          --textile
        "; return;;
	esac

  _gh_trace "The '$cur' is not an option, so don't complete"
	COMPREPLY=()
}

_gh_network_completion()
{
  local network_subcommands="web list fetch commits"
  ## TODO: figure out if this are 'network' command or 'commit' subcommand options
  local network_options="
    --applies --before --project --after --thisbranch --noapply
    --nocache --cache --sort --shas --author --common --limit
  "
  
  local subcommand=$( _gh_find_subcommand "$1" "$network_subcommands" )

  if [ -z "$subcommand" ] ; then
    local cur="${COMP_WORDS[COMP_CWORD]}"
    _gh_trace "No subcommand, try complete '$cur'"
    case "$cur" in
      -*) _gh_comp "$network_options" "$cur" ;;
      *)  _gh_comp "$network_subcommands" "$cur" ;;
    esac
    return
  fi
  
  _gh_trace "Got subcommand '$subcommand'"
  case "$subcommand" in
    ## TODO: gh could give us a list of all network users ;)
    ## FIXME: we should only match one user
    web)   users=$( _gh_remote_users ); _gh_comp_opts "$users" "$network_options" ;;
    *)     _gh_comp "$network_options" ;;
  esac
}

_gh_gem_completion()
{
  local c=1 command partial
  _gh_trace $( set | egrep '^COMP_(CWORD|WORDS|LINE|POINT)=' )
  
  while [ $c -lt $COMP_CWORD ]; do
    i="${COMP_WORDS[c]}"
    _gh_trace "  iter i='$i', c is '$c'"
    case "$i" in
      -*) ;; # ignore options before command
      *) command="$i"; c=$((++c)); break ;;
    esac
		c=$((++c))
  done
  
  if [ -z "$command" ] ; then
    _gh_trace "No command, complete from global list of commands"
    _gh_comp "$_gh_commands"
    return 0
  fi
  
  _gh_trace "Got command '$command', c is '$c'"
  case "$command" in
    browse)    _gh_browse_completion $c ;;
    clone)     _gh_clone_completion $c ;;
    create)    _gh_create_completion $c ;;
    network)   _gh_network_completion $c ;;
    *)         _gh_trace "Command not handled"; COMPREPLY=() ;;
  esac
  
  return 0
}

complete -F _gh_gem_completion gh

