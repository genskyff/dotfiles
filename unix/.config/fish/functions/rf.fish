#!/usr/bin/env fish

function rf --description "Find with ripgrep and fzf"
    _fzf_check; or return 1

    if command -q bat
        set bat bat
    else if command -q batcat
        set bat batcat
    else
        echo -e "$(set_color red)Error$(set_color normal): 'bat' command not found" >&2
        return 1
    end

    if not command -q rg
        echo -e "$(set_color red)Error$(set_color normal): 'rg' command not found" >&2
        return 1
    end

    argparse hidden -- $argv; or return 1
    test (uname) = Darwin; and set exclude "-g !Applications -g !Library"
    set rg_prefix "rg -L --line-number --no-heading --color always --smart-case $_flag_hidden $exclude"
    set toggle '
        if string match -q "*ripgrep*" "$FZF_PROMPT"
            echo "unbind(change)+change-prompt(fzf> )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"
        else
            echo "rebind(change)+change-prompt(ripgrep> )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r"
        end'

    test "$EDITOR" = code; and set edit "$EDITOR -g {1}:{2}"; or set edit "$EDITOR {1} +{2}"

    fzf --height 100% --disabled --query "$argv" \
        --header 'Alt-T: Switch between ripgrep/fzf' \
        --prompt "ripgrep> " \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --delimiter : \
        --preview "$bat --color always {1} --highlight-line {2}" \
        --preview-window "up,border-bottom,+{2}+3/3,~3" \
        --bind "start:toggle-preview+reload:$rg_prefix {q}" \
        --bind "change:reload:sleep 0.1; $rg_prefix {q} || true" \
        --bind "alt-t:transform:fish -c '$toggle'" \
        --bind "enter:become(fish -c '$edit')"
    rm -f /tmp/rg-fzf-{r,f}
end
