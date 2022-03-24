# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# Run .zprofile
[ -f "$HOME/.config/zsh/.zprofile" ] && . "$HOME/.config/zsh/.zprofile"
