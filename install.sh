#!/bin/zsh

# Define a function which rename a `target` file to `target.backup` if the file exists and if it's not a symlink
backup() {
  target=$1
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
      mv "$target" "$target.backup"
      echo "-----> Moved your old $target config file to $target.backup"
    fi
  fi
}

symlink() {
  file=$1
  link=$2
  if [ ! -e "$link" ]; then
    echo "-----> Symlinking your new $link"
    ln -s "$file" "$link"
  fi
}

# For all files `$filename` in the present folder backup the target file located at `~/.$filename` and symlink `$filename` to `~/.$filename`
for filename in gitconfig zprofile zshrc; do
  if [ ! -d "$filename" ]; then
    target="$HOME/.$filename"
    backup $target
    symlink $PWD/$filename $target
  fi
done

# Symlink VS Code settings and keybindings for WSL
for filename in settings.json keybindings.json; do
  target="$HOME/.vscode-server/data/Machine/$filename"
  backup "$target"
  symlink "$PWD/$filename" "$target"
done

# Install zsh plugins
CURRENT_DIR=$(pwd)
ZSH_PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"
mkdir -p "$ZSH_PLUGINS_DIR" && cd "$ZSH_PLUGINS_DIR"

if [ ! -d "zsh-autosuggestions" ]; then
  echo "-----> Installing zsh plugin 'zsh-autosuggestions'..."
  git clone https://github.com/zsh-users/zsh-autosuggestions
fi

if [ ! -d "zsh-syntax-highlighting" ]; then
  echo "-----> Installing zsh plugin 'zsh-syntax-highlighting'..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting
fi

cd "$CURRENT_DIR"

echo "👌 Finished"

# Refresh the current terminal with the newly installed configuration
exec zsh
