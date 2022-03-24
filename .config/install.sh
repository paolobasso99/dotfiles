#!/bin/bash

curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -

apt-get update
apt-get install -y \
	neovim \
	tmux \
	tree \
	nodejs \
	python3 \
	ctop
