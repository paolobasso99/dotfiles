# dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Docker Compose
alias dc='docker-compose'
alias dcup='docker-compose up -d && docker-compose logs -f'
alias dcl='docker-compose logs -f'

# Docker
alias dk='docker'
alias dkl='docker logs -f'
