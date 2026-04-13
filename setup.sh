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
#  3. Symlinks
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

link "$DOTFILES_DIR/zsh/.zshrc"           "$HOME/.zshrc"
link "$DOTFILES_DIR/tmux/.tmux.conf"      "$HOME/.tmux.conf"
link "$DOTFILES_DIR/vim/.vimrc"           "$HOME/.vimrc"
link "$DOTFILES_DIR/git/.gitconfig"       "$HOME/.gitconfig"
link "$DOTFILES_DIR/hammerspoon/init.lua" "$HOME/.hammerspoon/init.lua"

# ============================================================
#  4. vim-plug & plugins
# ============================================================
if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
  echo "==> Installing vim-plug..."
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
echo "==> Installing vim plugins..."
vim +PlugInstall +qall 2>/dev/null || true

# ============================================================
#  5. Hammerspoon ShiftIt Spoon
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
#  6. Create .hammerspoon dir if needed
# ============================================================
mkdir -p "$HOME/.hammerspoon"

echo ""
echo "==> Done! Restart your terminal or run: source ~/.zshrc"
echo ""
echo "==> Manual steps remaining:"
echo "   - SSH keys: copy or generate ~/.ssh/github_rsa etc."
echo "   - gh auth login"
echo "   - Docker Desktop: open from Applications to complete setup"
