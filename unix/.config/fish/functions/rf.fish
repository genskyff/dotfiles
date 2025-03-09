function rf --description "Find with ripgrep and fzf"
    _cmd_check fzf rg; or return 1
    if _cmd_check --quiet bat
        set bat bat
    else if _cmd_check --quiet batcat
        set bat batcat
    else
        echo -e "$(set_color red)Error$(set_color normal): 'bat' command not found" >&2
        return 1
    end

    argparse hidden -- $argv; or return 1
    test (uname) = Darwin; and set exclude "-g !Applications -g !Library"
    set rg_prefix "rg -L --line-number --no-heading --color always --smart-case $_flag_hidden $exclude"
    set toggle '
        if string match -q "*ripgrep*" "$FZF_PROMPT"
            echo "unbind(change)+change-prompt(fzf> )+enable-search+transform-query:echo \{q} > /tmp/rf-r; cat /tmp/rf-f"
        else
            echo "rebind(change)+change-prompt(ripgrep> )+disable-search+transform-query:echo \{q} > /tmp/rf-f; cat /tmp/rf-r"
        end'

    test "$EDITOR" = code; and set edit "$EDITOR -g {1}:{2}"; or set edit "$EDITOR {1} +{2}"

    fzf -d: \
        --height 100% --disabled \
        --header "Alt-0: Switch between ripgrep/fzf" \
        --prompt "ripgrep> " \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --preview "$bat --color always {1} --highlight-line {2}" \
        --preview-window "up,border-bottom,+{2}+3/3,~3" \
        --bind "start:toggle-preview+reload:$rg_prefix {q} || true" \
        --bind "change:reload:sleep 0.1; $rg_prefix {q} || true" \
        --bind "alt-0:transform:$toggle" \
        --bind "enter:become($edit)"
    rm -f /tmp/rf-{r,f}
end
