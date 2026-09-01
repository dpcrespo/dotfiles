function zellij --description "Wrapper for zellij that uses directory name as session"
    # Get the real zellij binary
    set -l zellij_bin (command -v zellij)

    # If already inside zellij, pass through all commands
    if set -q ZELLIJ
        $zellij_bin $argv
        return
    end

    set -l session_name (basename $PWD)

    # If layout is specified
    if test "$argv[1]" = "--layout" -o "$argv[1]" = "-l"
        set -l layout_name $argv[2]

        # Check if session exists (exact match, using -s for plain names)
        if $zellij_bin list-sessions -s 2>/dev/null | string match -rq "^"$session_name"\$"
            echo "Attaching to session: $session_name"
            $zellij_bin attach $session_name
        else
            echo "Creating new session: $session_name with layout: $layout_name"
            $zellij_bin --layout $layout_name options --session-name $session_name
        end
    # No arguments - attach or create
    else if test (count $argv) -eq 0
        $zellij_bin attach -c $session_name
    else
        # Pass through all other commands
        $zellij_bin $argv
    end
end
