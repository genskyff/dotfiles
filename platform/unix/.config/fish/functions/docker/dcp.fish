function dcp --description "Copy files between container and host"
    _docker_check; or return 1
    _cmd_check fzf; or return 1

    argparse -N1 -X2 H -- $argv; or return 1
    if set -q _flag_H
        test (count $argv) -eq 1; and set argv[2] "\$(docker exec {2} bash -c 'echo \$HOME')"
        set args "$argv[1] {2}:$argv[2]"
    else
        test (count $argv) -eq 1; and set argv[2] (pwd)
        set args "{2}:$argv[1] $argv[2]"
    end

    _container_list | fzf --with-nth 2 \
        --preview "_docker_fzf_preview {1}" \
        --bind "start:toggle-preview" \
        --bind "enter:become(docker cp --follow-link $args)"
end
