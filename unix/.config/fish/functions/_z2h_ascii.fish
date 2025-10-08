function _z2h_ascii --description 'Convert full-width ascii characters to half-width'
    _cmd_check perl; or return 1

    set cmd (commandline)
    set converted (printf "%s" "$cmd" | perl -CSD -Mutf8 -pe 'tr/\x{3000}\x{FF01}-\x{FF5E}/ \x21-\x7E/')
    commandline --replace -- $converted
end
