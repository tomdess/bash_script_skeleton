#!/usr/bin/env bash

################################################################################
### TOP LEVEL COMMENTS
# [...]
# 
# TODO(tom): Handle the unlikely edge cases (bug ####)
#
#

################################################################################
### global settings
################################################################################

# set -e catches and makes fatal many types of (otherwise silent) failure
# set -u makes expansions of undefined variables fatal, which catches the
#  classic case of rm -rf "${PERFIX}/usr/bin"
# set -o pipefail extends -e by making any failure anywhere in a pipeline fatal,
#  rather than just the last command
set -euo pipefail

# enable extended pathname expansion (e.g. $ ls !(*.jpg|*.gif))
shopt -s extglob

# min bash 4 version
[[ "${BASH_VERSINFO[0]}" -lt 4 ]] && die "Bash >=4 required"

################################################################################
### variables and defaults
################################################################################
VERBOSE=${VERBOSE:-0}
STAMP=${STAMP:-$(date +%s)}
my_file=""


################################################################################
### FUNCTIONS
################################################################################

# check if command is available
function installed {
  command -v "${1}" >/dev/null 2>&1
}

# die and exit with code 1
function die {
  >&2 printf '%s %s\n' "Fatal: " "${@}"
  exit 1
}

# usage function
function usage {
  usage="$(basename "$0") [-h] [-f file] -- program with a file parameter

where:
    -h  show this help text
    -f  gives the filename"
  printf '%s\n' "${usage}"  
}


################################################################################
### MAIN
################################################################################


# check for required commands
deps=(curl nc dig)
for dep in "${deps[@]}"; do
  installed "${dep}" || die "Missing '${dep}'"
done

# parse options
while getopts ':hf:' option; do
  case "$option" in
    h) usage
       exit
       ;;
    f) my_file=$OPTARG
       ;;
    :) printf 'missing argument for -%s\n' "$OPTARG" >&2
       usage
       exit 1
       ;;
   \?) printf 'illegal option: -%s\n' "$OPTARG" >&2
       usage
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))

# deal with required options (getopts cannot do that)
# die if file argument is empty
[[ -z "${my_file}" ]] && die "Filename is required (-f option)"

# use printf instead of echo command
my_array=("Given file: " "${my_file}")
printf '%s\n' "${my_array[*]}"

# remaining options
printf '%s %s\n' "Remaining arguments: " "${@}"

# exit
exit 0
