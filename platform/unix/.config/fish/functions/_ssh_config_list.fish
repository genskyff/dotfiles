function _ssh_config_list --description "List ssh configuration files"
    path filter -f $HOME/.ssh/config $HOME/.ssh/conf.d/**
end
