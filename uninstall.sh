#!/bin/bash

echo "==> Dotfiles Uninstall Script"
echo "==> This will remove dotfiles and optionally Homebrew packages"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Detect OS
OS="$(uname -s)"
ARCH="$(uname -m)"

if [ "$OS" = "Darwin" ]; then
    [ "$ARCH" = "arm64" ] && HOMEBREW_PREFIX="/opt/homebrew" || HOMEBREW_PREFIX="/usr/local"
else
    HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
fi

# Function to ask yes/no
ask() {
    local prompt="$1"
    local default="${2:-n}"
    local answer

    if [ "$default" = "y" ]; then
        prompt="$prompt [Y/n]: "
    else
        prompt="$prompt [y/N]: "
    fi

    read -p "$prompt" answer
    answer="${answer:-$default}"

    [[ "$answer" =~ ^[Yy]$ ]]
}

echo -e "${YELLOW}This script will remove:${NC}"
echo "  - Config directories (~/.config/nvim, fish, kitty, zellij, yazi, atuin, mise)"
echo "  - Git config (~/.gitconfig)"
echo "  - Chezmoi directory (~/.local/share/chezmoi)"
echo "  - Kitty local install (~/.local/kitty.app)"
echo "  - Nerd Fonts from ~/.local/share/fonts"
echo ""

if ! ask "Continue with uninstall?"; then
    echo "Aborted."
    exit 0
fi

echo ""

# 1. Restore default shell (bash)
CURRENT_SHELL="$(basename "$SHELL")"
if [ "$CURRENT_SHELL" = "fish" ]; then
    echo -e "${YELLOW}==> Restoring bash as default shell...${NC}"
    if ask "Change default shell back to bash?"; then
        chsh -s /bin/bash
        echo -e "${GREEN}    Default shell changed to bash${NC}"
    fi
fi

# 2. Remove dotfiles configs
echo ""
echo -e "${YELLOW}==> Removing config directories...${NC}"

CONFIGS=(
    "$HOME/.config/nvim"
    "$HOME/.config/fish"
    "$HOME/.config/kitty"
    "$HOME/.config/zellij"
    "$HOME/.config/yazi"
    "$HOME/.config/atuin"
    "$HOME/.config/mise"
    "$HOME/.gitconfig"
)

for config in "${CONFIGS[@]}"; do
    if [ -e "$config" ]; then
        rm -rf "$config"
        echo -e "${GREEN}    Removed: $config${NC}"
    fi
done

# 3. Remove chezmoi directory and config
echo ""
echo -e "${YELLOW}==> Removing chezmoi...${NC}"
rm -rf "$HOME/.local/share/chezmoi"
rm -rf "$HOME/.config/chezmoi"
echo -e "${GREEN}    Removed chezmoi directories${NC}"

# 4. Remove Kitty local install (Linux only)
if [ "$OS" = "Linux" ] && [ -d "$HOME/.local/kitty.app" ]; then
    echo ""
    echo -e "${YELLOW}==> Removing Kitty local install...${NC}"
    rm -rf "$HOME/.local/kitty.app"
    rm -f "$HOME/.local/bin/kitty"
    rm -f "$HOME/.local/bin/kitten"
    rm -f "$HOME/.local/share/applications/kitty.desktop"
    echo -e "${GREEN}    Removed Kitty${NC}"
fi

# 5. Remove Nerd Fonts
echo ""
echo -e "${YELLOW}==> Removing Nerd Fonts...${NC}"
if [ -d "$HOME/.local/share/fonts" ]; then
    # Only remove Iosevka fonts we installed
    find "$HOME/.local/share/fonts" -name "*Iosevka*" -delete 2>/dev/null
    fc-cache -fv 2>/dev/null || true
    echo -e "${GREEN}    Removed Iosevka Nerd Fonts${NC}"
fi

# 6. Remove mise shims and data
echo ""
if [ -d "$HOME/.local/share/mise" ]; then
    if ask "Remove mise data (Node/Yarn versions installed by mise)?"; then
        rm -rf "$HOME/.local/share/mise"
        rm -rf "$HOME/.local/state/mise"
        rm -rf "$HOME/.cache/mise"
        echo -e "${GREEN}    Removed mise data${NC}"
    else
        echo -e "${YELLOW}    Kept mise data${NC}"
    fi
fi

# 7. Homebrew packages (optional)
echo ""
if command -v brew &> /dev/null; then
    echo -e "${YELLOW}==> Homebrew packages${NC}"
    echo ""
    echo "The following packages were installed by the dotfiles Brewfile:"
    echo "  fish, starship, atuin, zellij, zoxide, fzf, ripgrep, fd, yazi,"
    echo "  bat, eza, tree, git, lazygit, gh, delta, neovim, tree-sitter,"
    echo "  luarocks, mise, stylua, prettier, eslint, shfmt, file, unar,"
    echo "  poppler, ffmpegthumbnailer, imagemagick, jq, yq, curl, wget,"
    echo "  htop, lazydocker, direnv"
    echo ""

    if ask "Uninstall these Homebrew packages?"; then
        echo -e "${YELLOW}==> Uninstalling Homebrew packages...${NC}"

        BREW_PACKAGES=(
            fish starship atuin zellij zoxide fzf ripgrep fd yazi
            bat eza tree lazygit gh delta neovim tree-sitter
            luarocks mise stylua prettier eslint shfmt file unar
            poppler ffmpegthumbnailer imagemagick jq yq
            htop lazydocker direnv
        )

        for pkg in "${BREW_PACKAGES[@]}"; do
            if brew list "$pkg" &>/dev/null; then
                brew uninstall --ignore-dependencies "$pkg" 2>/dev/null || true
                echo -e "${GREEN}    Uninstalled: $pkg${NC}"
            fi
        done

        # Clean up
        brew autoremove 2>/dev/null || true
        brew cleanup 2>/dev/null || true
    else
        echo -e "${YELLOW}    Kept Homebrew packages${NC}"
    fi

    # Ask about removing Homebrew entirely
    echo ""
    if ask "Remove Homebrew completely? (WARNING: This removes ALL brew packages)"; then
        echo -e "${RED}==> Removing Homebrew...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
    else
        echo -e "${YELLOW}    Kept Homebrew${NC}"
    fi
fi

# 8. Clean up Neovim data
echo ""
if [ -d "$HOME/.local/share/nvim" ] || [ -d "$HOME/.local/state/nvim" ]; then
    if ask "Remove Neovim plugin data and cache?"; then
        rm -rf "$HOME/.local/share/nvim"
        rm -rf "$HOME/.local/state/nvim"
        rm -rf "$HOME/.cache/nvim"
        echo -e "${GREEN}    Removed Neovim data${NC}"
    fi
fi

echo ""
echo -e "${GREEN}==> Uninstall complete!${NC}"
echo ""
echo "Please restart your terminal or run: exec bash"
echo ""
echo "Note: If you had configs before installing dotfiles,"
echo "you may need to restore them from backup."
