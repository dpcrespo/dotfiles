function zs --description "Attach to zellij session with fzf picker"
    # Don't run if already inside zellij
    if set -q ZELLIJ
        echo "Already inside a zellij session. Use Ctrl+o w to switch."
        return 1
    end

    set -l sessions (command zellij list-sessions -s 2>/dev/null)

    if test -z "$sessions"
        echo "No active sessions. Use 'workon' to start a new one."
        return 1
    end

    set -l selected (printf '%s\n' $sessions | fzf \
        --prompt="Session: " \
        --preview="command zellij list-sessions 2>/dev/null | grep -E '^{}'" \
        --preview-window=up:3:wrap)

    if test -n "$selected"
        echo "Attaching to: $selected"
        command zellij attach $selected
    end
end
