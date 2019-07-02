function fish_right_prompt
    set -l exit_code $status
    
    if test $exit_code -ne 0
        set_color red
        printf "• %s" $exit_code
        set_color normal
    end
end