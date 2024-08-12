#!/usr/bin/env fish

function rf --description "find with ripgrep and fzf"
    set pattern "-g !Applications -g !Library"
    set rg_prefix "rg -L --line-number --no-heading --color always --smart-case $pattern"
    set toggle '
        if string match -q "*ripgrep*" "$FZF_PROMPT"
            echo "unbind(change)+change-prompt(fzf> )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"
        else
            echo "rebind(change)+change-prompt(ripgrep> )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r"
        end
    '
    test -n $EDITOR; or set EDITOR nvim
    command -qv bat; and set bat bat; or set bat batcat
    fzf --height 100% --disabled --query "$argv" \
        --prompt "ripgrep> " \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --delimiter : \
        --preview "$bat --color always {1} --highlight-line {2}" \
        --preview-window "up,border-bottom,+{2}+3/3,~3" \
        --bind "start:toggle-preview+reload:$rg_prefix {q}" \
        --bind "change:reload:sleep 0.1; $rg_prefix {q} || true" \
        --bind "alt-t:transform:fish -c '$toggle'" \
        --bind "enter:become($EDITOR {1} +{2})"
    rm -f /tmp/rg-fzf-{r,f}
end
