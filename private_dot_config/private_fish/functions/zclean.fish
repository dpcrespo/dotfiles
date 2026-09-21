function zclean --description "Kill all zellij sessions except current and prune stale cache"
    set -l sessions (zellij list-sessions 2>/dev/null | grep -v '(current)' | awk '{print $1}')

    if test (count $sessions) -eq 0
        echo "No hay otras sesiones activas"
    else
        echo "Eliminando "(count $sessions)" sesiones..."
        for session in $sessions
            zellij delete-session $session -f
            echo "  - $session eliminada"
        end
    end

    # Restos de sesiones muertas. Sin --force para no tocar sesiones vivas
    # (incluida la actual): --force las mataria antes de borrarlas.
    zellij delete-all-sessions --yes 2>/dev/null

    # Directorios session_info huerfanos: uno por cada sesion que existio
    # alguna vez. Se conservan solo los de sesiones vivas.
    set -l cache_root ~/.cache/zellij
    set -l version (zellij --version | awk '{print $2}')
    set -l info_dir $cache_root/$version/session_info
    set -l live (zellij list-sessions -s 2>/dev/null)
    set -l pruned 0

    if test -d $info_dir
        for dir in $info_dir/*
            set -l name (basename $dir)
            if not contains -- $name $live
                rm -rf $dir
                set pruned (math $pruned + 1)
            end
        end
    end

    # Caches de versiones anteriores de zellij
    for dir in $cache_root/*
        set -l name (basename $dir)
        if string match -qr '^[0-9]+\.[0-9]+\.[0-9]+$' -- $name; and test "$name" != "$version"
            rm -rf $dir
            echo "  - cache de zellij $name eliminada"
        end
    end

    # Caches de plugins por sesion (un dir uuid por arranque). Los de sesiones
    # vivas se tocan constantemente, asi que el filtro por antiguedad no los
    # alcanza. NO se toca la cache WASM (dirs numericos): recompilar es lento.
    set -l stale (find $cache_root -maxdepth 1 -type d -name '*-*-*-*-*' -mtime +30)
    if test (count $stale) -gt 0
        rm -rf $stale
        echo "  - "(count $stale)" caches de plugins obsoletas eliminadas"
    end

    test $pruned -gt 0; and echo "  - $pruned directorios session_info huerfanos eliminados"
    echo "Listo"
end
