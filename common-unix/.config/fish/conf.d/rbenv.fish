#!/usr/bin/env fish

status is-interactive; or return

command -q rbenv; or return
rbenv init - --no-rehash fish | source
