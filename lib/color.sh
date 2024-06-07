#!/bin/bash

ok_color="\033[0;32m"
error_color="\033[0;31m"
warn_color="\033[0;33m"
info_color="\033[0;36m"
bold_color="\033[0;35m"
reset_color="\033[0m"

function print_with_color() {
  local color="$1"
  local newline=1
  local text

  if [[ "$2" == "-n" ]]; then
    newline=0
    text="${@:3}"
  else
    text="${@:2}"
  fi

  if [[ "$newline" -eq 0 ]]; then
    echo -en "${color}${text}${reset_color}"
  else
    echo -e "${color}${text}${reset_color}"
  fi
}

function ok() {
  print_with_color "$ok_color" "$@"
}

function error() {
  print_with_color "$error_color" "$@"
}

function warn() {
  print_with_color "$warn_color" "$@"
}

function info() {
  print_with_color "$info_color" "$@"
}

function bold() {
  print_with_color "$bold_color" "$@"
}
