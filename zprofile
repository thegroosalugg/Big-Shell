# Configure pyenv root directory
export PYENV_ROOT="$HOME/.pyenv"

# Add pyenv executable to PATH (so the 'pyenv' command is found)
export PATH="$PYENV_ROOT/bin:$PATH"

# Initialize pyenv for login shells (sets up Python shims correctly)
type -a pyenv > /dev/null && eval "$(pyenv init --path)"
