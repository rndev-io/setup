function fish_prompt
    set_color yellow
    echo -n (prompt_pwd)
    if type -q arc-prompt
        echo " "(arc-prompt)
    end
    set_color normal
    echo '> '
end