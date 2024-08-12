#!/usr/bin/env fish

if test -f $argv
    if file -b $argv | grep -qE "(text|empty)"
        command -qv bat
        and bat --color always $argv
        or batcat --color always $argv
    else
        file $argv
    end
else if test -d $argv
    lsd --color always --tree --depth 1 $argv
else
    echo -e $argv
end
