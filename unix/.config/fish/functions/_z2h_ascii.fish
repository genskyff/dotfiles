function _z2h_ascii --description 'Convert full-width ascii characters to half-width'
    _cmd_check perl; or return 1

    set cmd (commandline)
    set converted (printf "%s" "$cmd" | perl -CS -Mutf8 -MUnicode::Normalize=NFKC -pe '
        s/……|…/^/g;
        s/¥|￥/\\$/g;

        $_ = NFKC($_);

        s/〜/~/g;
        s/￥/\$/g;
        s/【/[/g;
        s/】/]/g;
        s/「|『|」|』/\"/g;
        s/——|—/_/g;
        s/ー/-/g;
        s/、/\\\\/g;
        s/‘|’/\'/g;
        s/“|”/\"/g;
        s/《/</g;
        s/》/>/g;
        s/。/./g;
        s/・/\//g;

        tr/\x{3000}\x{FF01}-\x{FF5E}/ \x21-\x7E/;
    ')
    commandline --replace -- $converted
end
