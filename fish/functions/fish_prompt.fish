set green (set_color green)
set magenta (set_color magenta)
set normal (set_color normal)
set red (set_color red)
set yellow (set_color yellow)

set __fish_git_prompt_color_branch magenta --bold
set __fish_git_prompt_color_dirtystate white
set __fish_git_prompt_color_invalidstate red
set __fish_git_prompt_color_merging yellow
set __fish_git_prompt_color_stagedstate yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

function fish_prompt
    set_color yellow
    echo -n (prompt_pwd)
    #if type -q arc-prompt
    #    echo -n (arc-prompt)
    #end
    echo -n (__fish_git_prompt)
    set_color normal
    echo '> '
end
