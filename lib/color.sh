#!/bin/bash

black="\e[0;30m"
red="\e[0;31m"
green="\e[0;32m"
yellow="\e[0;33m"
blue="\e[0;34m"
magenta="\e[0;35m"
cyan="\e[0;36m"
light_gray="\e[0;37m"
gray="\e[0;90m"
light_red="\e[0;91m"
light_green="\e[0;92m"
light_yellow="\e[0;93m"
light_blue="\e[0;94m"
light_magenta="\e[0;95m"
light_cyan="\e[0;96m"
white="\e[0;97m"
reset="\e[0m"

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
        echo -e "${color}${text}${reset_color}"
    else
        echo -en "${color}${text}${reset_color}"
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
