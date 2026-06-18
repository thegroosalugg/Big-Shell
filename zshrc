# Oh‑My‑Zsh installation directory
ZSH=$HOME/.oh-my-zsh
# You can change the theme with another one from https://github.com/robbyrussell/oh-my-zsh/wiki/themes
ZSH_THEME="robbyrussell"
# Disable warning about insecure completion-dependent directories
ZSH_DISABLE_COMPFIX=true

# Useful oh-my-zsh plugins (must run before `source`)
plugins=(git gitfast last-working-dir common-aliases zsh-syntax-highlighting zsh-autosuggestions history-substring-search ssh-agent)

# load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"

# Store your own aliases in the ~/.aliases file and load the here.
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Terminal encoding (UTF‑8 prevents character issues)
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Default editor for CLI tools (Git, Poetry, etc.)
export EDITOR=code

# Call `nvm use` automatically in a directory with a `.nvmrc` file
autoload -U add-zsh-hook
load-nvmrc() {
  if nvm -v &> /dev/null; then
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use --silent
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      nvm use default --silent
    fi
  fi
}
type -a nvm > /dev/null && add-zsh-hook chpwd load-nvmrc
type -a nvm > /dev/null && load-nvmrc

# Load nvm (to manage node versions)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Load pyenv (to manage Python versions)
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init - 2> /dev/null)" && RPROMPT+='[🐍 $(pyenv version-name)]'

# Deno environment (if installed)
[ -f "$HOME/.deno/env" ] && . "$HOME/.deno/env"

# Add user-level executables (pip, pipx, poetry, etc.) to PATH (Where the shell looks for programs)
export PATH="$HOME/.local/bin:$PATH"

# Add local Node project binaries to PATH
export PATH="./node_modules/.bin:$PATH"

# Add custom Zsh completions directory to FPATH (Where Zsh looks for completions and functions)
export FPATH="$HOME/.zsh/completions:$FPATH"

# Set Java JDK 25 path for IntelliJ and terminal commands
export JAVA_HOME=/usr/lib/jvm/jdk-25
export PATH=$JAVA_HOME/bin:$PATH

# Load Angular CLI autocompletion (if installed)
if command -v ng &> /dev/null; then
  source <(ng completion script)
fi
