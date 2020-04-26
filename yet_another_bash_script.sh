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
### variables
################################################################################
VERBOSE=${VERBOSE:-0}
STAMP=${STAMP:-$(date +%s)}



################################################################################
### FUNCTIONS
################################################################################

# check if command is available
function installed {
  command -v "${1}" >/dev/null 2>&1
}

# die and exit with code 1
function die {
  >&2 echo "Fatal: ${@}"
  exit 1
}


################################################################################
### MAIN
################################################################################


# check for required commands
deps=(curl nc dig)
for dep in "${deps[@]}"; do
  installed "${dep}" || die "Missing '${dep}'"
done

# use printf instead of echo command
my_array=(uno due tre)
printf '%s\n' "VERBOSE=${VERBOSE}"
printf '%s %s\n' "VERBOSE=${VERBOSE}" "STAMP=${STAMP}"
printf '%s\n' "my_array=${my_array[*]}"



# exit
exit 0
