#!/usr/bin/env bash
set -euo pipefail

# Elimina git worktrees creados con `gwt` (los que cuelgan de
# ~/projects/<repo>__<branch>). Contrapartida de git-worktree.sh.
#
# Uso (desde DENTRO del repo o de cualquiera de sus worktrees):
#   gwtr                 # interactivo: lista y elige (número, 'a' = todos)
#   gwtr <branch-name>   # elimina el worktree de esa rama
#   gwtr --all           # elimina todos los worktrees del repo
#
# Usa `git worktree remove --force` porque los worktrees de gwt siempre
# tienen ficheros untracked (.env, node_modules...). Tras eliminar, ofrece
# borrar también la(s) rama(s) local(es).

PROJECTS_DIR="$HOME/projects"

# El primer worktree del listado porcelain es siempre el principal; así
# gwtr funciona también ejecutado desde dentro de un worktree.
MAIN_ROOT="$(git worktree list --porcelain | head -1 | sed 's/^worktree //')"
REPO_NAME="$(basename "$MAIN_ROOT")"
CURRENT_ROOT="$(git rev-parse --show-toplevel)"

mapfile -t WORKTREES < <(
  git worktree list --porcelain \
    | awk '/^worktree /{print substr($0, 10)}' \
    | grep -F "$PROJECTS_DIR/${REPO_NAME}__" || true
)

if [ "${#WORKTREES[@]}" -eq 0 ]; then
  echo "No hay worktrees de gwt para '$REPO_NAME' en $PROJECTS_DIR."
  exit 0
fi

branch_of() {
  git -C "$1" branch --show-current 2>/dev/null || echo "(detached)"
}

remove_one() {
  local path="$1"
  if [ "$path" = "$CURRENT_ROOT" ]; then
    echo "Saltado $path: estás dentro de él (sal del worktree y repite)."
    return 1
  fi
  git -C "$MAIN_ROOT" worktree remove --force "$path"
  echo "Eliminado worktree $path"
}

delete_branches_prompt() {
  local branches=("$@")
  [ "${#branches[@]}" -eq 0 ] && return 0
  echo ""
  read -rp "¿Borrar también la(s) rama(s) local(es) (${branches[*]})? [y/N]: " del
  if [[ "${del:-}" =~ ^[yY]$ ]]; then
    for b in "${branches[@]}"; do
      [ "$b" = "(detached)" ] && continue
      git -C "$MAIN_ROOT" branch -D "$b" && echo "Borrada rama $b"
    done
  fi
}

remove_list() {
  local paths=("$@")
  echo "Se eliminarán los siguientes worktrees:"
  for p in "${paths[@]}"; do
    echo "  $p  (rama: $(branch_of "$p"))"
  done
  echo ""
  read -rp "¿Continuar? [y/N]: " confirm
  [[ "${confirm:-}" =~ ^[yY]$ ]] || { echo "Abortado."; exit 0; }

  local removed_branches=()
  for p in "${paths[@]}"; do
    local b
    b="$(branch_of "$p")"
    if remove_one "$p"; then
      removed_branches+=("$b")
    fi
  done
  delete_branches_prompt "${removed_branches[@]}"
}

case "${1:-}" in
  --all|-a)
    remove_list "${WORKTREES[@]}"
    ;;
  "")
    echo "Worktrees de '$REPO_NAME':"
    for i in "${!WORKTREES[@]}"; do
      echo "  $((i + 1))) ${WORKTREES[$i]}  (rama: $(branch_of "${WORKTREES[$i]}"))"
    done
    echo "  a) todos"
    echo ""
    read -rp "Elige worktree a eliminar [1-${#WORKTREES[@]}/a]: " choice
    if [[ "${choice:-}" =~ ^[aA]$ ]]; then
      remove_list "${WORKTREES[@]}"
    elif [[ "${choice:-}" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#WORKTREES[@]}" ]; then
      remove_list "${WORKTREES[$((choice - 1))]}"
    else
      echo "Abortado."
      exit 0
    fi
    ;;
  *)
    BRANCH="$1"
    WORKTREE_PATH="$PROJECTS_DIR/${REPO_NAME}__${BRANCH}"
    if ! printf '%s\n' "${WORKTREES[@]}" | grep -qxF "$WORKTREE_PATH"; then
      echo "No existe worktree para la rama '$BRANCH'."
      echo ""
      echo "Disponibles:"
      for p in "${WORKTREES[@]}"; do
        echo "  ${p##*__}"
      done
      exit 1
    fi
    remove_list "$WORKTREE_PATH"
    ;;
esac
