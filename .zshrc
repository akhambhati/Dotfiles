# Setup main environmental variables
export DOTFILES=$HOME/Dotfiles
export ZSH=$DOTFILES/zsh

# Load Antigen
. $DOTFILES/zsh/antigen/antigen.zsh

# Load the oh-my-zsh’s library
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell’s oh-my-zsh)
antigen bundle autojump        # Enable auto jump when installed with homebrew
antigen bundle brew            # Adds brew completion, enables the brews command   
antigen bundle common-aliases  # Collection of useful zsh aliases ls et al.
antigen bundle compleat        # Bash completion
antigen bundle git             # Adds git aliases
antigen bundle git-extras      # Tab after various git commands autofills fields
antigen bundle git-flow        # Enforces the git-flow model
antigen bundle osx             # Interfaces with the OS X ui environment
antigen bundle pip             # PIP completion
antigen bundle tmux            # Can set various tux options
antigen bundle web-search      # Can do shell-based web searches

# Tracks your most used directories, based on frequency.
antigen bundle z
autoload -Uz add-zsh-hook
add-zsh-hook precmd _z_precmd
function _z_precmd {
    _z --add "$PWD"
}

# History search
antigen bundle zsh-users/zsh-history-substring-search

# syntax highlighting bundle
antigen bundle zsh-users/zsh-syntax-highlighting

# autocomplete
antigen bundle tarruda/zsh-autosuggestions

# Load the theme
antigen bundle oskarkrawczyk/honukai-iterm-zsh
antigen theme oskarkrawczyk/honukai-iterm-zsh honukai

# Tell antigen that you’re done
antigen apply

# Automatically list directory contents on `cd`.
auto-ls () { ls; }
chpwd_functions=( auto-ls $chpwd_functions )


# Setup environmental variables
source $ZSH/env.zsh
source $ZSH/shortcut.zsh
source $ZSH/bkeys.zsh
