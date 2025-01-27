command -q fnm; or return 0

if status is-interactive
  fnm env --use-on-cd --shell fish | source
else
  fnm env --shell fish | source
end
