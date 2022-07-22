#!/usr/bin/env bash
set -e

# Description: Provides a bright, colourful output wrapper for scripts
# Author:      Raymond Walker <raymond.walker@greenpeace.org>

# See: https://unix.stackexchange.com/questions/9957/how-to-check-if-bash-can-print-colours
# Check if stdout is a terminal
if test -t 1; then
  # Check that it supports colours
  ncolors=$(tput colors)

  if test -n "$ncolors" && test "$ncolors" -ge 8; then
    bold="$(tput bold)"
    # underline="$(tput smul)"
    standout="$(tput smso)"
    normal="$(tput sgr0)"
    # black="$(tput setaf 0)"
    red="$(tput setaf 1)"
    green="$(tput setaf 2)"
    yellow="$(tput setaf 3)"
    # blue="$(tput setaf 4)"
    # magenta="$(tput setaf 5)"
    cyan="$(tput setaf 6)"
    # white="$(tput setaf 7)"
  fi
fi

_title() {
  printf "${cyan:-""}*** ${bold:-""}%s${normal:-""}\n" "$*"
}

_good() {
  printf "${green:-""}  * ${normal:-""}%s\n" "$*"
}

_error() {
  printf >&2 "\n${red:-""}${standout:-""}[ERROR]${normal:-""} ${red:-""}%s${normal:-""}\n\n" "$*"
  exit 1
}

_warning() {
  printf >&2 "  ${yellow:-""}* ${bold:-""}[WARNING] ${normal:-""}%s\n" "$*"
}

export -f _title
export -f _good
export -f _error
export -f _warning
