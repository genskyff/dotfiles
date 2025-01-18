#!/usr/bin/env fish

function nup --description "Update nix packages"
    argparse 'root' -- $argv
    set -q _flag_root
    and set list (sudo -i nix-env -q | cut -d- -f1)
    or set list (nix-env -q | cut -d- -f1)

    for pkg in $list
        nix-env -uA nixpkgs.$pkg
    end
end
