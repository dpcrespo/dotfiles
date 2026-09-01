# Dotfiles drift check.
#
# Nothing ever reported that ~/.config and the chezmoi source had diverged, so
# they quietly did, for seven months. This says so at shell start, and stays
# silent when there is nothing to say. Costs ~40ms.
#
# Set CHEZMOI_DRIFT_QUIET to turn it off.

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
    end

    test (count $out) -eq 0; and return

    printf '%s\n' $out
end

if status is-interactive
    __chezmoi_drift
end
