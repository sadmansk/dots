Dot files for Linux (and maybe some \*nix)
=========================================

# Configuration
Assuming the repository is cloned to ~/dots/, you can use GNU `stow` for easy management
of dot files:
`stow <application_name>`

NOTE: for nvim (and other configs that live within the `~/.config` directory, make sure
you already have the .config directory created. Otherwise the stow command will link
`.config -> dots/nvim/.config` instead of `.config/nvim -> dots/nvim/.config/nvim`.

## shell (zsh)
Requirements:

* zsh
* powerline
* oh-my-zsh
* powerlevel10k
* nerd-fonts/menlo fonts
* fzf

```
stow zsh
```

## Window manager (i3blocks)

* i3blocks
* acpi
* amixer
* i3lock
  * ffmpeg
* xorg-xbacklight (for brightness controls)
* compton
* feh (and place wallpaper in `$HOME/Pictures/wallpaper.jpg`

## editor (nvim)

* neovim
* fzf
* LSPs:
  * npm (for copilot)
  * go
  * python
* cursor-cli (if using the default AI assistant, but easy to configure to work with
  other cli tools)

Lazynvim takes care of installing all plugins, and Mason takes care of installing
the required language servers.

## terminal mulitplexer (tmux)

* tmux
* tpm (tmux plugin manager)

All other dependencies (plugins etc.) are installed through the config using tpm
(if not, try running prefix + I within tmux to install)

## vim (deprecated)

* vundle
* fzf
* eclipse.jdt.ls
* node (installing through nvm might be easiest if package manager is bad)
* jedi-language-server

