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

# 3. Linux-specific: Install system deps, Kitty and Nerd Font
if [ "$OS" = "Linux" ]; then
    # Install system dependencies needed by Kitty and Homebrew
    if command -v apt-get &> /dev/null; then
        echo "==> Installing system dependencies (apt)..."
        sudo apt-get update -qq
        sudo apt-get install -y -qq \
            build-essential curl file git \
            libgl1 libxkbcommon-x11-0 libfontconfig1 \
            libxcursor1 libxrandr2 libxi6 libxinerama1 \
            fontconfig 2>/dev/null || true
    elif command -v dnf &> /dev/null; then
        echo "==> Installing system dependencies (dnf)..."
        sudo dnf install -y -q \
            gcc gcc-c++ make curl file git \
            mesa-libGL libxkbcommon-x11 fontconfig \
            libXcursor libXrandr libXi libXinerama 2>/dev/null || true
    fi

    # Install Nerd Font (before Kitty so font is available)
    if ! fc-list 2>/dev/null | grep -qi "iosevkaterm nerd font"; then
        echo "==> Installing IosevkaTerm Nerd Font..."
        mkdir -p ~/.local/share/fonts
        FONT_TMP="$(mktemp -d)"
        if curl -fL --progress-bar -o "$FONT_TMP/IosevkaTerm.tar.xz" \
            https://github.com/ryanoasis/nerd-fonts/releases/latest/download/IosevkaTerm.tar.xz; then
            tar -xf "$FONT_TMP/IosevkaTerm.tar.xz" -C ~/.local/share/fonts
            fc-cache -f ~/.local/share/fonts 2>/dev/null || true
            echo "==> Font installed. Verifying..."
            if fc-list | grep -qi "iosevkaterm nerd font"; then
                echo "==> IosevkaTerm Nerd Font verified OK"
            else
                echo "==> WARNING: Font installed but not detected by fc-list. May need terminal restart."
            fi
        else
            echo "==> WARNING: Failed to download IosevkaTerm Nerd Font"
        fi
        rm -rf "$FONT_TMP"
    fi

    # Install Kitty terminal
    if ! command -v kitty &> /dev/null; then
        echo "==> Installing Kitty terminal..."
        if curl -fL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n; then
            mkdir -p ~/.local/bin
            ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/
            ln -sf ~/.local/kitty.app/bin/kitten ~/.local/bin/
            # Desktop integration
            mkdir -p ~/.local/share/applications
            if [ -f ~/.local/kitty.app/share/applications/kitty.desktop ]; then
                cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
                sed -i "s|Icon=kitty|Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty.desktop
            fi
            echo "==> Kitty installed successfully"
        else
            echo "==> WARNING: Kitty installation failed. You can install it manually later:"
            echo "    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin"
        fi
    fi
fi

# 4. Initialize and apply dotfiles
echo "==> Applying dotfiles..."
chezmoi init --apply "https://github.com/dpcrespo/dotfiles.git"

echo ""
echo "==> Bootstrap complete!"
echo "==> Please restart your terminal"
echo ""
echo "==> Next steps:"
echo "   1. Set up your NPM token: echo 'your-token' > ~/.npm_token"
echo "   2. Open Neovim to install plugins: nvim"
