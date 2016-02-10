# Setup main environmental variables
export DOTFILES=$HOME/Dotfiles
export ZSH=$DOTFILES/zsh

# Load Antigen
source $HOME/Dotfiles/zsh/antigen/antigen.zsh

# Load the oh-my-zsh’s library
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell’s oh-my-zsh)
antigen bundle autojump
antigen bundle brew
antigen bundle brew-cask
antigen bundle common-aliases
antigen bundle compleat
antigen bundle git
antigen bundle git-extras
antigen bundle git-flow
antigen bundle osx
antigen bundle pip
antigen bundle tmux
antigen bundle web-search
antigen bundle z
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search

# Load the theme
antigen theme honukai

# Tell antigen that you’re done
antigen apply

# Setup zsh-autosuggestions
source $HOME/Dotfiles/zsh/zsh-autosuggestions/dist/autosuggestions.zsh

# Enable autosuggestions automatically
zle-line-init() {
    zle autosuggest-start
}
zle -N zle-line-init

# Setup environmental variables
source $ZSH/env.zsh
source $ZSH/shortcut.zsh


