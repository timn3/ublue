
#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

autoload -U compinit
compinit

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
#setopt APPEND_HISTORY
## for sharing history between zsh processes
#setopt INC_APPEND_HISTORY
#setopt SHARE_HISTORY

## never ever beep ever
#setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0

# autoload -U colors
#colors

# Ultramarine ZSH config
# initialize starship
eval "$(starship init zsh)"

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Ctrl + Arrow keybindings
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# Ctrl + Backspace/Delete Kebindings
bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word

# ALt + Backspace/Delete Keybinds
bindkey "^[[3~" delete-char
bindkey -M emacs '^[[3;3~' kill-word

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt SHARE_HISTORY

#### TIM Custom changes

### Thinkfan
#alias thinkfan_status="systemctl status thinkfan"

# TODO: Bake into own image
### CUDA/parprog Related changes
#alias nvsmi="watch -d -n 0.5 nvidia-smi"
#export PATH=/usr/local/cuda/bin:/usr/lib64/openmpi/bin:/home/tim/.cargo/bin:${PATH:+:${PATH}}
#export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda/lib64
#export CUDACXX=/usr/local/cuda/bin/nvcc
#export CPLUS_INCLUDE_PATH=/usr/local/cuda/include:$CPLUS_INCLUDE_PATH

#module load mpi/openmpi-x86_64
#CC=/usr/bin/gcc-13.2
#CXX=/usr/bin/g++-13.2
#export PATH=$PATH:$HOME/.local/bin


eval "$(zoxide init zsh)"
#eval $(thefuck --alias)
alias cd="z"
alias grep="rg"
alias find="fd"
alias l='eza --icons=always'
alias ls='eza -a --icons=always'
alias ll='eza -al --icons=always'
alias lt='eza -a --tree --level=1 --icons=always'
# alias wifi='nmtui'

