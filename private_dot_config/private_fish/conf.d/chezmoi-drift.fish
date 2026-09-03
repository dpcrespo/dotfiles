# Dotfiles drift check.
#
# Nothing ever reported that ~/.config and the chezmoi source had diverged, so
# they quietly did, for seven months. This says so at shell start, and stays
# silent when there is nothing to say. Costs ~40ms.
#
# Set CHEZMOI_DRIFT_QUIET to turn it off.

function __chezmoi_drift_fetch --description "Refresh origin in the background, at most once per interval"
    set -l src $argv[1]
    set -l interval 1800

    set -l cache_root $XDG_CACHE_HOME
    test -n "$cache_root"; or set cache_root $HOME/.cache
    set -l stamp $cache_root/chezmoi-drift/fetch-stamp

    if test -f $stamp
        set -l last (stat -c %Y $stamp 2>/dev/null; or stat -f %m $stamp 2>/dev/null)
        test -n "$last"
            and test (math (date +%s) - $last) -lt $interval
            and return
    end

    # Stamped before the fetch, not after: a remote that is down should throttle
    # the retries just like a successful one, not get hammered once per shell.
    mkdir -p (dirname $stamp) 2>/dev/null
    touch $stamp

    # Detached, so the shell start never waits on the network, and in batch mode
    # so a missing SSH key fails instead of hanging on a passphrase prompt. The
    # result lands in .git for the *next* shell to read, which is soon enough
    # for a repo that changes a few times a day.
    env GIT_TERMINAL_PROMPT=0 GIT_SSH_COMMAND="ssh -o BatchMode=yes -o ConnectTimeout=5" \
        git -C $src fetch --quiet &
    disown
end

function __chezmoi_drift --description "Report divergence between this machine and the dotfiles source"
    set -q CHEZMOI_DRIFT_QUIET; and return
    type -q chezmoi; or return

    set -l out

    # Rows with R in the second column are pending run_ scripts, not drift.
    set -l dirty (chezmoi status 2>/dev/null | string match -rv '^.R ')
    if test (count $dirty) -gt 0
        set -a out (set_color yellow)"chezmoi: "(count $dirty)" fichero(s) divergen del source"(set_color normal)

        set -l shown $dirty
        test (count $dirty) -gt 3; and set shown $dirty[1..3]
        for line in $shown
            set -a out "    "(string trim $line)
        end
        test (count $dirty) -gt 3
            and set -a out "    ... y "(math (count $dirty) - 3)" mas"
        set -a out (set_color brblack)"    chezmoi diff  ->  chezmoi add <fichero>  o  chezmoi apply"(set_color normal)
    end

    set -l src (chezmoi source-path 2>/dev/null)
    if test -d "$src"
        __chezmoi_drift_fetch $src

        set -l uncommitted (git -C $src status --porcelain 2>/dev/null | count)
        if test $uncommitted -gt 0
            set -a out (set_color yellow)"chezmoi: $uncommitted cambio(s) sin commitear en el source"(set_color normal)
            set -a out (set_color brblack)"    chezmoi cd  ->  git add -A && git commit"(set_color normal)
        end

        set -l unpushed (git -C $src log --oneline '@{u}..HEAD' 2>/dev/null | count)
        if test $unpushed -gt 0
            set -a out (set_color yellow)"chezmoi: $unpushed commit(s) sin pushear"(set_color normal)
            set -a out (set_color brblack)"    git -C $src push  (el portatil no los ve hasta entonces)"(set_color normal)
        end

        # Counted against the last fetch, which the check above keeps fresh.
        set -l unpulled (git -C $src log --oneline 'HEAD..@{u}' 2>/dev/null | count)
        if test $unpulled -gt 0
            set -a out (set_color yellow)"chezmoi: $unpulled commit(s) nuevos en origin sin traer"(set_color normal)
            set -a out (set_color brblack)"    dotpull  (trae el source y lo aplica saltando los run_ scripts)"(set_color normal)
        end
    end

    test (count $out) -eq 0; and return

    printf '%s\n' $out
end

if status is-interactive
    __chezmoi_drift
end
