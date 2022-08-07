export EDITOR="/usr/bin/nvim"
if [ -d "$HOME/.local/bin" ] ; then
  PATH="$PATH:$HOME/.local/bin"
fi

# Run local-exports
[ -f "$HOME/.config/zsh/local-exports" ] && . "$HOME/.config/zsh/local-exports"
