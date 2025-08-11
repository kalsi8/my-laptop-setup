#!/bin/bash

set -e  # Exit on error

echo "🚀 Starting installation on macOS..."

# Detect shell
SHELL_NAME=$(basename "$SHELL")
PROFILE_FILE="$HOME/.zshrc"
if [ "$SHELL_NAME" = "bash" ]; then
    PROFILE_FILE="$HOME/.bash_profile"
fi

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✅ Homebrew already installed"
fi

# Add Homebrew to PATH if not already
if [[ $(uname -m) == "arm64" ]]; then
    BREW_PREFIX="/opt/homebrew"
else
    BREW_PREFIX="/usr/local"
fi
if ! grep -q "$BREW_PREFIX/bin/brew shellenv" "$PROFILE_FILE"; then
    echo "🔧 Adding Homebrew to PATH..."
    echo "eval \"\$($BREW_PREFIX/bin/brew shellenv)\"" >> "$PROFILE_FILE"
    eval "$($BREW_PREFIX/bin/brew shellenv)"
fi

# Install NVM if not installed
if [ ! -d "$HOME/.nvm" ]; then
    echo "📦 Installing NVM..."
    brew install nvm
    mkdir -p ~/.nvm
    {
        echo 'export NVM_DIR="$HOME/.nvm"'
        echo "[ -s \"$BREW_PREFIX/opt/nvm/nvm.sh\" ] && \. \"$BREW_PREFIX/opt/nvm/nvm.sh\""
        echo "[ -s \"$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm\" ] && \. \"$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm\""
    } >> "$PROFILE_FILE"
else
    echo "✅ NVM already installed"
fi

# Load NVM into current shell
export NVM_DIR="$HOME/.nvm"
[ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$BREW_PREFIX/opt/nvm/nvm.sh"

# Install latest Node.js LTS
echo "📦 Installing latest Node.js LTS..."
nvm install --lts
nvm alias default lts/*
nvm use default

# Install Yarn
if ! command -v yarn &> /dev/null; then
    echo "📦 Installing Yarn..."
    brew install yarn
else
    echo "✅ Yarn already installed"
fi

echo "🎉 Installation completed!"
echo "🔄 Please restart your terminal or run: source $PROFILE_FILE"
