#!/usr/bin/env fish

docker ps -a --filter id=$argv \
    --format "{{.ID}}/{{.Image}}/{{.Command}}/{{.CreatedAt}}/{{.Status}}/{{.Ports}}/{{.Names}}" \
    | while read -l line
        set -l fields (string split / $line)
        echo (set_color blue)"ID      "(set_color normal)$fields[1]
        echo (set_color green)"Image   "(set_color normal)$fields[2]
        echo (set_color yellow)"Command "(set_color normal)$fields[3]
        echo (set_color cyan)"Created "(set_color normal)$fields[4]
        echo (set_color yellow)"Status  "(set_color normal)$fields[5]
        echo (set_color green)"Ports   "(set_color normal)$fields[6]
        echo (set_color blue)"Name    "(set_color normal)$fields[7]
        echo ""
    end
