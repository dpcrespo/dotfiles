function zkill --description "Kill zellij session"
    if test (count $argv) -eq 0
        echo "Sessions disponibles:"
        zellij list-sessions
        return
    end
    zellij delete-session $argv[1]
    echo "Sesión '$argv[1]' eliminada"
end
