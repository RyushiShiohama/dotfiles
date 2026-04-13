#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> dotfiles directory: $DOTFILES_DIR"

# ============================================================
#  1. Homebrew
# ============================================================
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Apple Silicon の場合 PATH を通す
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  echo "==> Homebrew already installed"
fi

# ============================================================
#  2. Brew bundle
# ============================================================
echo "==> Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# ============================================================
#  3. macOS defaults
# ============================================================
echo "==> Applying macOS system preferences..."
# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 63
# Keyboard
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 25
# Trackpad: tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 1.5
# Apply Dock changes
killall Dock 2>/dev/null || true

# ============================================================
#  4. Symlinks
# ============================================================
echo "==> Creating symlinks..."

link() {
  local src="$1" dst="$2"
  if [[ -e "$dst" || -L "$dst" ]]; then
    echo "   backup: $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi
  ln -sf "$src" "$dst"
  echo "   linked: $src -> $dst"
}

mkdir -p "$HOME/.hammerspoon"

link "$DOTFILES_DIR/zsh/.zshrc"           "$HOME/.zshrc"
link "$DOTFILES_DIR/tmux/.tmux.conf"      "$HOME/.tmux.conf"
link "$DOTFILES_DIR/vim/.vimrc"           "$HOME/.vimrc"
link "$DOTFILES_DIR/git/.gitconfig"       "$HOME/.gitconfig"
link "$DOTFILES_DIR/hammerspoon/init.lua" "$HOME/.hammerspoon/init.lua"

# ============================================================
#  5. vim-plug & plugins
# ============================================================
if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
  echo "==> Installing vim-plug..."
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
echo "==> Installing vim plugins..."
vim +PlugInstall +qall 2>/dev/null || true

# ============================================================
#  6. Hammerspoon ShiftIt Spoon
# ============================================================
SPOONS_DIR="$HOME/.hammerspoon/Spoons"
if [[ ! -d "$SPOONS_DIR/ShiftIt.spoon" ]]; then
  echo "==> Installing ShiftIt Spoon..."
  mkdir -p "$SPOONS_DIR"
  curl -fL -o /tmp/ShiftIt.spoon.zip \
    https://github.com/peterklijn/hammerspoon-shiftit/raw/master/Spoons/ShiftIt.spoon.zip
  unzip -o /tmp/ShiftIt.spoon.zip -d "$SPOONS_DIR"
  rm /tmp/ShiftIt.spoon.zip
else
  echo "==> ShiftIt Spoon already installed"
fi

# ============================================================
#  7. npm global packages
# ============================================================
echo "==> Installing global npm packages..."
npm install -g @anthropic-ai/claude-code

echo ""
echo "=========================================="
echo "  Setup complete!"
echo "=========================================="
echo ""
echo "Restart your terminal or run: source ~/.zshrc"
echo ""
echo "Manual steps remaining:"
echo "  1. SSH keys: AirDrop or USB from old Mac -> ~/.ssh/"
echo "  2. AWS credentials: AirDrop or USB -> ~/.aws/"
echo "  3. gh auth login"
echo "  4. Docker Desktop: open from Applications to complete setup"
