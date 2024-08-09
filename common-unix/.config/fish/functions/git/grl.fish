#!/usr/bin/env fish

function grl --description "git reflog with format"
    _git_check; or return 1
    git reflog --color=always --date="format:%Y-%m-%d %H:%M:%S" --format="%C(auto)%cd %h%d %gs"
end
