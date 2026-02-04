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

# 3. Initialize and apply dotfiles
echo "==> Applying dotfiles..."
# Replace 'dpcrespo' with your GitHub username
chezmoi init --apply "https://github.com/dpcrespo/dotfiles.git"

# 4. Configure Fish as default shell
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
