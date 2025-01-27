set -l nix_daemon /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
test -f $nix_daemon; and . $nix_daemon
