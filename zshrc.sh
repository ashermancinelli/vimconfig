export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

export HISTORY_IGNORE="fg"
export HIST_IGNORE_SPACE=1
export HIST_NO_STORE=1

ZSH_THEME="refined"
plugins=(
git 
colored-man-pages 
zsh-autosuggestions 
zsh-syntax-highlighting
)

bindkey '^ ' autosuggest-accept
