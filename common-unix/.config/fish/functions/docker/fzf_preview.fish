#!/usr/bin/env fish

docker ps -a --filter id="$argv[1]" \
    --format \
'ID:      {{.ID}}
Image:   {{.Image}}
Command: {{.Command}}
Created: {{.CreatedAt}}
Status:  {{.Status}}
Ports:   {{.Ports}}
Name:    {{.Names}}'
