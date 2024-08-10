#!/usr/bin/env fish

function rf --description 'find files with ripgrep and fzf'
    rm -f /tmp/rg-fzf-{r,f}
    set rg_prefix "rg --column --line-number --no-heading --color=always --smart-case"
    test -n "$EDITOR"; or set EDITOR nvim
    fzf --disabled --query "$argv" \
        --prompt "ripgrep> " \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --delimiter : \
        --preview "bat --color=always {1} --highlight-line {2}" \
        --preview-window "+{2}+3/3,~3" \
        --header "Ctrl-T: Switch between ripgrep/fzf" \
        --bind "start:reload:$rg_prefix {q}" \
        --bind "change:reload:sleep 0.1; $rg_prefix {q} || true" \
        --bind 'ctrl-t:transform:not string match -q "*ripgrep*" "$FZF_PROMPT" &&
            echo "rebind(change)+change-prompt(ripgrep> )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r" ||
            echo "unbind(change)+change-prompt(fzf> )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"' \
        --bind "enter:become($EDITOR {1} +{2})"
end
