function _fzf_preview --description "Preview file or directory with fzf"
    if test -f $argv
        if file -b $argv | grep -qiE "(script|text|empty)"
            if _cmd_check --quiet bat
                set -f cmd bat --color always
            else if _cmd_check --quiet batcat
                set -f cmd batcat --color always
            else
                set -f cmd cat
            end
            $cmd $argv
        else
            file $argv
        end
    else if test -d $argv
        command -q lsd
        and set -f cmd lsd --color always --tree --depth 1
        or set -f cmd ls --color=always -1
        $cmd $argv
    else
        echo -e $argv
    end
end
