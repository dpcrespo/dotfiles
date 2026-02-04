function zkill --description "Kill zellij session"
    if test (count $argv) -eq 0
        echo "Available sessions:"
        zellij list-sessions
        return
    end
    zellij delete-session $argv[1]
    echo "Session '$argv[1]' killed"
end
