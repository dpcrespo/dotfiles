function dotpull --description "Pull the dotfiles source and apply it without running the run_ scripts"
    argparse h/help s/with-scripts -- $argv
    or return 1

    if set -q _flag_help
        echo "dotpull [--with-scripts]"
        echo ""
        echo "  Trae los commits del source de chezmoi y los aplica en esta maquina."
        echo "  Por defecto salta los run_ scripts: instalan via Homebrew, y este"
        echo "  equipo tiene las herramientas por apt y /usr/local/bin."
        echo ""
        echo "  --with-scripts   ejecuta tambien los run_ scripts"
        return
    end

    type -q chezmoi
    or begin
        echo "chezmoi no esta instalado"
        return 1
    end

    set -l src (chezmoi source-path 2>/dev/null)
    if not test -d "$src"
        echo "No encuentro el source de chezmoi"
        return 1
    end

    set -l before (git -C $src rev-parse HEAD 2>/dev/null)

    echo "==> git pull"
    if not git -C $src pull --ff-only
        echo "El pull no ha ido limpio. El source se queda como estaba y no se aplica nada."
        return 1
    end

    set -l after (git -C $src rev-parse HEAD)

    if test "$before" = "$after"
        echo "    ya estaba al dia"
    else
        git -C $src log --oneline $before..$after

        # A changed config template leaves the rendered config stale. Every
        # prompt in it is promptOnce, so regenerating reuses the stored answers
        # instead of asking again.
        if git -C $src diff --name-only $before $after | string match -q '.chezmoi.toml.tmpl'
            echo "==> chezmoi init (la plantilla del config ha cambiado)"
            chezmoi init
            or return 1
        end
    end

    echo "==> chezmoi apply"
    if set -q _flag_with_scripts
        chezmoi apply
        or return 1
    else
        chezmoi apply --exclude=scripts
        or return 1

        # Rows with R in the second column are the scripts just skipped.
        set -l pending (chezmoi status 2>/dev/null | string match -r '^.R ' | count)
        test $pending -gt 0
            and echo (set_color brblack)"    $pending run_ script(s) sin ejecutar; dotpull --with-scripts para lanzarlos"(set_color normal)
    end

    echo "Listo"
end
