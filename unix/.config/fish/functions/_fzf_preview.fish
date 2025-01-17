#!/usr/bin/env fish

if test -f $argv
    if file -b $argv | grep -qE "(text|empty)"
        set -l cmd
        if command -q bat
            set cmd bat --color always
        else if command -q batcat
            set cmd batcat --color always
        else
            set cmd cat
        end
        $cmd $argv
    else
        file $argv
    end
else if test -d $argv
    command -q lsd
    and set -l cmd lsd --color always --tree --depth 1
    or set -l cmd ls --color=always -1
    $cmd $argv
else
    echo -e $argv
end
