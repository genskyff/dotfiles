#!/usr/bin/env fish

if test -f $argv
    if file -b $argv | grep -qE "(text|empty)"
        command -q bat; and set bat bat; or set bat batcat
        $bat --color always $argv
    else
        file $argv
    end
else if test -d $argv
    lsd --color always --tree --depth 1 $argv
else
    echo -e $argv
end
