set fish_greeting
set fish_function_path (path resolve -- $__fish_config_dir/functions/**/) $fish_function_path
set fish_function_path (string join \n $fish_function_path | awk '!seen[$0]++')
