# tcadmin(8) completion                                    -*- shell-script -*-

# /usr/share/bash-completion/completions/umount/tcadmin

#
# Trinity Core worldserver administrative command bash completion hook.
#
# Author: Nicola Worthington
#         <nicolaw@tfb.net>
#         https://nicolaw.uk/tcadmin
#         https://github.com/neechbear/tcadmin
#
# MIT License
#
# Copyright (c) 2017 Nicola Worthington <nicolaw@tfb.net>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

# complete $TC* variables for --arguments
_tc_env_var()
{
  local quoted
  _quote_readline_by_ref "${1:-}" quoted
  local cur="${COMP_WORDS[COMP_CWORD]}"
  [[ -n "$quoted" ]] && COMPREPLY=( $( compgen -W "$quoted" -- $cur ) )
  return 0
}

# return command root
_tc_cmd_root()
{
  local cmd_root=""
  local i
  for i in ${!COMP_WORDS[*]} ; do
    # first index (0) is the actuall command name (tcadmin)
    [[ $i -eq 0 ]] && continue

    local arg="${COMP_WORDS[$i]}"

    # skip arguments that start with a - as they're not commands
    if [[ "$arg" == "-"* ]] ; then
      continue

    # if the first real argument doesn't start with a -, then we have no dash
    # arguments (as they must always come first before commands), so we just
    # slurp in all the arguments.
    elif [[ $i -eq 1 ]] ; then
      cmd_root="${COMP_WORDS[@]:1:$COMP_CWORD}"
      break

    # if the previous argument was a dash argument (without =) then this is the
    # value of that argument, not a command, so we will skip
    elif [[ "${COMP_WORDS[i-1]}" =~ ^--?[a-zA-Z0-9]+$ ]] ; then
      continue

    # append the current argument
    elif [[ $i -ne $COMP_CWORD ]] ; then
      cmd_root="${cmd_root:+$cmd_root }$arg"
    fi
  done
  echo "$cmd_root"
}

# complete available worldserver commands
_tc_available_commands()
{
  local cmd_root="$(_tc_cmd_root)"
  local cur="${COMP_WORDS[COMP_CWORD]}"
  if [[ "$(type -t get_available_commands)" == "function" ]] ; then
    COMPREPLY=( $( compgen -W \
        "$(get_filtered_subcommands "$cmd_root" | cut -d' ' -f1 | sort -u)" \
        -- $cur ) )
  fi
  return 0
}

# complete tcadmin
_tcadmin()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"

  # source in tcadmin
  local tcadmin="$(type -P tcadmin 2>/dev/null)"
  if [[ -r "$tcadmin" ]] ; then
    source "$tcadmin" || true
  elif [[ -r "tcadmin" && -x "tcadmin" ]] ; then
    source "tcadmin" || true
  fi
 
  # complete a database or soap credential
  case "$prev" in
    -dbhost|--dbhost) _tc_env_var "$TCDBHOST"; return 0 ;;
    -dbport|--dbport) _tc_env_var "$TCDBPORT"; return 0 ;;
    -dbuser|--dbuser) _tc_env_var "$TCDBUSER"; return 0 ;;
    -dbpass|--dbpass) _tc_env_var "$TCDBPASS"; return 0 ;;
    -dbbane|--dbname) _tc_env_var "$TCDBNAME"; return 0 ;;
    -soaphost|--soaphost) _tc_env_var "$TCSOAPHOST"; return 0 ;;
    -soapport|--soapport) _tc_env_var "$TCSOAPPORT"; return 0 ;;
    -soapuser|--soapuser) _tc_env_var "$TCSOAPUSER"; return 0 ;;
    -soappass|--soappass) _tc_env_var "$TCSOAPPASS"; return 0 ;;
  esac
 
  # completing an option
  if [[ "$cur" == -* ]]; then
    COMPREPLY=( $( compgen -W "$(_parse_help tcadmin)" -- $cur ) )

  # completing a command
  else
    _tc_available_commands
  fi
}
complete -F _tcadmin tcadmin

