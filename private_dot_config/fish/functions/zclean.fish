function zclean --description "Kill all zellij sessions except current"
    set -l sessions (zellij list-sessions 2>/dev/null | grep -v '(current)' | awk '{print $1}')

    if test (count $sessions) -eq 0
        echo "No other active sessions"
        return
    end

    echo "Killing "(count $sessions)" sessions..."
    for session in $sessions
        zellij delete-session $session -f
        echo "  - $session killed"
    end
    echo "Done"
end
