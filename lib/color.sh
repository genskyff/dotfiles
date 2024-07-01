#!/bin/bash

black="\033[0;30m"
red="\033[0;31m"
green="\033[0;32m"
yellow="\033[0;33m"
blue="\033[0;34m"
magenta="\033[0;35m"
cyan="\033[0;36m"
light_gray="\033[0;37m"
gray="\033[0;90m"
light_red="\033[0;91m"
light_green="\033[0;92m"
light_yellow="\033[0;93m"
light_blue="\033[0;94m"
light_magenta="\033[0;95m"
light_cyan="\033[0;96m"
white="\033[0;97m"
reset="\033[0m"

ok_color="$light_green"
error_color="$light_red"
warn_color="$light_yellow"
info_color="$light_blue"

function print_with_color() {
    local color="$1"
    local newline=true
    local text=""

    if [[ "$2" == "-n" ]]; then
        newline=false
        text="${@:3}"
    else
        text="${@:2}"
    fi

    if $newline; then
        echo -e "${color}${text}${reset}"
    else
        echo -en "${color}${text}${reset}"
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
