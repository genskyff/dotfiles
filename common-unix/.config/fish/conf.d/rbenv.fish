#!/usr/bin/env fish

status is-interactive; or return 0

command -q rbenv; or return 0
rbenv init - --no-rehash fish | source
