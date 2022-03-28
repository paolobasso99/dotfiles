# some useful options (man zshoptions)
setopt appendhistory autocd extendedglob nomatch menucomplete
setopt interactive_comments
stty stop undef		# Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')

# beeping is annoying
unsetopt BEEP

# completions
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots)		# Include hidden files.

# Colors and prompt
autoload -Uz colors && colors
PS1="%B%{$fg[red]%}[%{$fg[green]%}%n@%M%{$fg[white]%}:%{$fg[blue]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# Useful Functions
source "$ZDOTDIR/functions"

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "zsh-users/zsh-completions"
zsh_add_plugin "zsh-users/zsh-history-substring-search"

# Normal files to source
zsh_add_file "vim-mode"
zsh_add_file "aliases"
zsh_add_file "prompt"
zsh_add_file "key-bindings"
zsh_add_file "show-neofetch"
