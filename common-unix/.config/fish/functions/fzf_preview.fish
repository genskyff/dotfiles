#!/usr/bin/env fish

if test -f $argv[1]
    if file -b $argv[1] | grep -qE "(text|empty)"
        command -v bat 2>&1 1>/dev/null
        and bat --color=always $argv[1]
        or batcat --color=always $argv[1]
    else
        file $argv[1]
    end
else if test -d $argv[1]
    lsd --tree --depth 1 $argv[1]
else
    echo -e $argv[1]
end
