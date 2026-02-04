#!/bin/bash
set -e

echo "==> Dotfiles Bootstrap Script"
echo "==> This will set up your development environment"
echo ""

# Detect OS and architecture
OS="$(uname -s)"
ARCH="$(uname -m)"

echo "==> Detected: $OS ($ARCH)"

# Configure Homebrew prefix based on OS/arch
if [ "$OS" = "Darwin" ]; then
    [ "$ARCH" = "arm64" ] && HOMEBREW_PREFIX="/opt/homebrew" || HOMEBREW_PREFIX="/usr/local"
else
    HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
fi

# 1. Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew is in PATH
eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"

# 2. Install Chezmoi
if ! command -v chezmoi &> /dev/null; then
    echo "==> Installing Chezmoi..."
    brew install chezmoi
fi

# 3. Linux-specific: Install Kitty and Nerd Font
if [ "$OS" = "Linux" ]; then
    # Install Kitty terminal
    if ! command -v kitty &> /dev/null; then
        echo "==> Installing Kitty terminal..."
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
        mkdir -p ~/.local/bin
        ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/
        ln -sf ~/.local/kitty.app/bin/kitten ~/.local/bin/
        # Desktop integration
        mkdir -p ~/.local/share/applications
        cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
        sed -i "s|Icon=kitty|Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty.desktop
    fi

    # Install Nerd Font
    if ! fc-list | grep -qi "iosevka"; then
        echo "==> Installing IosevkaTerm Nerd Font..."
        mkdir -p ~/.local/share/fonts
        cd /tmp
        curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/IosevkaTerm.tar.xz
        tar -xf IosevkaTerm.tar.xz -C ~/.local/share/fonts
        fc-cache -fv || true  # May fail on some systems, but font is installed
        cd -
    fi
fi

# 4. Initialize and apply dotfiles
echo "==> Applying dotfiles..."
chezmoi init --apply "https://github.com/dpcrespo/dotfiles.git"

# 5. Configure Fish as default shell
FISH_PATH="$(which fish)"
if [ -n "$FISH_PATH" ]; then
    if ! grep -q "$FISH_PATH" /etc/shells; then
        echo "==> Adding fish to /etc/shells..."
        echo "$FISH_PATH" | sudo tee -a /etc/shells
    fi

    if [ "$SHELL" != "$FISH_PATH" ]; then
        echo "==> Setting fish as default shell..."
        chsh -s "$FISH_PATH"
    fi
fi

echo ""
echo "==> Bootstrap complete!"
echo "==> Please restart your terminal or run: exec fish"
echo ""
echo "==> Next steps:"
echo "   1. Set up your NPM token: echo 'your-token' > ~/.npm_token"
echo "   2. Configure your Git email when prompted by chezmoi"
echo "   3. Open Neovim to install plugins: nvim"
