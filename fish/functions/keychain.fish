function keychain-password
    security find-generic-password -w -s $argv
end

function keychain-account
    security find-generic-password -w -s $argv | grep 'acct' | cut -c 19- | tr -d '"' | tr -d '\n'
end