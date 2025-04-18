# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
# export ZSH="$HOME/.oh-my-zsh"

# To choice pure theme

# fpath+=$HOME/.zsh/pure
# autoload -U promptinit; promptinit
# prompt pure

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster" # set by `omz`

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    zsh-syntax-highlighting    
    zsh-autosuggestions
    fzf
    vi-mode
    tmux
)


source ~/.oh-my-zsh/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

export TERM="screen-256color"

export DEFAULT_USER="$(whoami)" 

alias v='nvim'
alias vm='viman'
alias t='tmux'
alias tn='tmux new-session'

. $HOME/.asdf/asdf.sh

export PATH="$HOME/go/bin:$PATH"
export ASDF_DATA_DIR="/home/brunocosta/.asdf"
export PATH="$ASDF_DATA_DIR/shims:$PATH"

# . ~/.asdf/plugins/java/set-java-home.zsh
#
# append completions to fpath
fpath=(${ASDF_DATA_DIR}/completions $fpath)
# initialise completions with ZSH's compinit


alias vc='nvim $HOME/.config/nvim/init.vim'


fpath+=${ZDOTDIR:-~}/.zsh_functions

#export PERL_MM_OPT="INSTALL_BASE=/N/u/bruno/Carbonate/perl5"
#export PERL5LIB="/N/u/bruno/Carbonate/perl5/lib/perl5:$PERL5LIB"
#export PATH="/N/u/bruno/Carbonate/perl5/bin:$PATH"
# eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"

# Needs to install lsd

export PATH=~/.cargo/bin:$PATH
export PATH=$PATH:/usr/local/go/bin


alias ls='lsd'
alias l='lsd -l'
alias la='lsd -a'
alias ll='ls -la'
alias lt='ls --tree'




pathdotfiles="$HOME/Documents/dotfiles"
alias dotf="cd $pathdotfiles"
export PATH=$PATH:$HOME/.local/share/nvim/lsp_servers/cssls/node_modules/vscode-langservers-extracted/bin/vscode-css-language-server
export PATH=$PATH:$HOME/.local/bin
export PATH="$HOME/lua-language-server/bin/:$PATH"
alias luamake=/home/brunocosta/lua-language-server/3rd/luamake/luamake

export FLYCTL_INSTALL="/home/brunocosta/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

if [[ $TERM == xterm ]]; then TERM=xterm-256color; fi


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH=~/.npm-global/bin:$PATH

zstyle ':completation:*' menu select

autoload -Uz compinit 
compinit


export SPRING_DATA_SOURCE_USERNAME="teste"
export SPRING_DATA_SOURCE_PASSWORD="teste123"

