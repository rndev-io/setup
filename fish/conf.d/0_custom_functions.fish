function add_to_path
    set -gx PATH $PATH $argv
end

function get_keychain_environment_variable
    security find-generic-password -w -a $USER -D "environment variable" -s $argv
end

function set_keychain_environment_variable
    security add-generic-password -U -a $USER -D "environment variable" -s $argv -w
end

function delete_keychain_environment_variable
    security delete-generic-password -a $USER -D "environment variable" -s $argv
end