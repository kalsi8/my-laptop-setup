#!/bin/bash

set -e  # Exit on error

echo "🚀 Starting installation on macOS..."

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✅ Homebrew already installed"
fi

# Ensure brew is available in PATH
if [[ $(uname -m) == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Install NVM if not installed
if [ ! -d "$HOME/.nvm" ]; then
    echo "📦 Installing NVM..."
    brew install nvm
    mkdir -p ~/.nvm
    {
        echo 'export NVM_DIR="$HOME/.nvm"'
        echo '[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"'
        echo '[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"'
    } >> ~/.zshrc
else
    echo "✅ NVM already installed"
fi

# Load NVM into current shell
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

# Install latest Node.js LTS
echo "📦 Installing latest Node.js LTS..."
nvm install --lts
nvm use --lts

# Install Yarn
if ! command -v yarn &> /dev/null; then
    echo "📦 Installing Yarn..."
    brew install yarn
else
    echo "✅ Yarn already installed"
fi

echo "🎉 Installation completed!"
echo "Restart your terminal or run: source ~/.zshrc"
