# dotfiles
My linux configuration files. Based on [this tutorial by Atlassian](https://web.archive.org/web/20220313023609/https://www.atlassian.com/git/tutorials/dotfiles).

## Install dotfiles onto a new system procedure
- Create alias:
```bash
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```
- Clone repository:
```bash
git clone --bare git@github.com:paolobasso99/dotfiles.git $HOME/.dotfiles
```
- Checkout the actual content from the bare repository to your $HOME:
```bash
config checkout
```
The step above might fail with a message like:
```bash
error: The following untracked working tree files would be overwritten by checkout:
    .bashrc
    .gitignore
Please move or remove them before you can switch branches.
Aborting
```
This is because your $HOME folder might already have some stock configuration files which would be overwritten by Git.
The solution is simple: back up the files if you care about them, remove them if you don't care.
- Set the flag showUntrackedFiles to no on this specific (local) repository:
```bash
config config --local status.showUntrackedFiles no
```
- Install packages using:
```bash
sudo $HOME/scripts/install-packages.sh
```

## Editing dotfiles
```bash
config status
config add .vimrc
config commit -m "Add vimrc"
config add .bashrc
config commit -m "Add bashrc"
config push
```

## Getting updated dotfiles
Pull latest updates:
```bash
config pull
```
