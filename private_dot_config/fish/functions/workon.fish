function workon --description "Project sessionizer - switch between projects with fzf and zellij"
    set -l project_name $argv[1]
    set -l projects_dir ~/projects

    if test -z "$project_name"
        # No argument - show fzf picker with zoxide frecency boost
        # First try zoxide query for frecent projects, fallback to ls
        set -l zoxide_results (zoxide query -l 2>/dev/null | string match "$projects_dir/*" | string replace "$projects_dir/" "")
        set -l all_projects (ls -1 $projects_dir)

        # Combine: zoxide results first (frecent), then rest
        set -l combined
        for p in $zoxide_results
            if contains $p $all_projects
                set -a combined $p
            end
        end
        for p in $all_projects
            if not contains $p $combined
                set -a combined $p
            end
        end

        set project_name (printf '%s\n' $combined | fzf \
            --height=50% \
            --layout=reverse \
            --border \
            --prompt="Project > " \
            --header="[Enter] Open | [Esc] Cancel" \
            --preview="ls -la $projects_dir/{} 2>/dev/null; echo ''; test -f $projects_dir/{}/README.md && head -20 $projects_dir/{}/README.md" \
            --preview-window=right:50%:wrap)

        if test -z "$project_name"
            return 0
        end
    end

    set -l project_path $projects_dir/$project_name

    if not test -d "$project_path"
        echo "Project not found: $project_name"
        return 1
    end

    # Update zoxide database
    zoxide add $project_path

    # Check if already in zellij
    if set -q ZELLIJ
        # Inside zellij - just cd
        cd $project_path
        echo "Changed to: $project_path"
    else
        # Outside zellij - check for existing session or create new
        set -l session_name $project_name

        # Check if session exists
        if command zellij list-sessions -s 2>/dev/null | string match -rq "^$session_name\$"
            echo "Attaching to existing session: $session_name"
            command zellij attach $session_name
        else
            echo "Creating new session: $session_name with layout: claude"
            cd $project_path
            command zellij --layout claude options --session-name $session_name
        end
    end
end
