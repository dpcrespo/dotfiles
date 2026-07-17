#!/usr/bin/env bash
set -euo pipefail

# Crea un git worktree DENTRO de ~/projects (para que `workon` lo liste) y
# copia los ficheros gitignored necesarios para arrancar el proyecto.
#
# Uso (desde DENTRO del repo del que quieres el worktree):
#   gwt <branch-name> [base-branch]
#
# Ejemplos:
#   gwt FC-1234-mi-feature           # rama desde HEAD actual
#   gwt FC-1234-mi-feature master    # rama desde master

REPO_ROOT="$(git rev-parse --show-toplevel)"
REPO_NAME="$(basename "$REPO_ROOT")"

# Los worktrees cuelgan directamente de ~/projects para que `workon` los vea.
PROJECTS_DIR="$HOME/projects"

BRANCH="${1:?Uso: gwt <branch-name> [base-branch]}"
BASE="${2:-HEAD}"

# Nombre de la carpeta del worktree. Prefijado con el repo para identificarlo
# en el picker de workon. Para dejarlo pelado: WORKTREE_NAME="$BRANCH"
WORKTREE_NAME="${REPO_NAME}__${BRANCH}"
WORKTREE_PATH="$PROJECTS_DIR/$WORKTREE_NAME"

if [ -d "$WORKTREE_PATH" ]; then
  echo "Error: ya existe un worktree en $WORKTREE_PATH"
  exit 1
fi

mkdir -p "$PROJECTS_DIR"

if git show-ref --verify --quiet "refs/heads/$BRANCH" \
  || git show-ref --verify --quiet "refs/remotes/origin/$BRANCH"; then
  git worktree add "$WORKTREE_PATH" "$BRANCH"
else
  echo "La rama '$BRANCH' no existe."
  echo ""
  echo "  1) Crear una rama nueva con ese nombre (desde $BASE)"
  echo "  2) Salir"
  echo ""
  read -rp "Elige opción [1/2]: " choice
  case "$choice" in
    1) git worktree add -b "$BRANCH" "$WORKTREE_PATH" "$BASE" ;;
    *) echo "Abortado."; exit 0 ;;
  esac
fi

# Ficheros gitignored que el worktree NO trae y necesitas para arrancar.
FILES_TO_COPY=(".env" ".env.local" ".mcp.json" "mise.toml" ".claude/settings.local.json")

for file in "${FILES_TO_COPY[@]}"; do
  if [ -f "$REPO_ROOT/$file" ]; then
    mkdir -p "$(dirname "$WORKTREE_PATH/$file")"   # por si el subdir no existe aún
    cp "$REPO_ROOT/$file" "$WORKTREE_PATH/$file"
    echo "Copiado $file"
  fi
done

echo ""
echo "Worktree listo en: $WORKTREE_PATH"
echo "Rama: $BRANCH"
echo ""
echo "Siguiente paso:"
echo "  workon $WORKTREE_NAME   # o: cd $WORKTREE_PATH"
echo "  npm install             # el worktree no trae node_modules"
