#!/usr/bin/env fish

if test -f $argv
    if file -b $argv | grep -qE "(text|empty)"
        command -v bat 2>&1 1>/dev/null
        and bat --color=always $argv
        or batcat --color=always $argv
    else
        file $argv
    end
else if test -d $argv
    lsd --tree --depth 1 $argv
else
    echo -e $argv
end
