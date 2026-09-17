function dcp --description "Copy files between container and host"
    _docker_check; or return 1
    _cmd_check fzf; or return 1

    argparse -N1 -X2 H -- $argv; or return 1

    set -l target (_container_list | fzf --with-nth 2 \
        --preview "_docker_fzf_preview {1}" \
        --bind "start:toggle-preview" \
        --bind "enter:become(echo {2})"); or return 1

    if set -q _flag_H
        if test (count $argv) -eq 1
            set argv[2] "$(docker exec "$target" sh -c 'echo "$HOME"')"; or return 1
        end
        docker cp --follow-link "$argv[1]" "$target:$argv[2]"
    else
        test (count $argv) -eq 1; and set argv[2] (pwd)
        docker cp --follow-link "$target:$argv[1]" "$argv[2]"
    end
end
