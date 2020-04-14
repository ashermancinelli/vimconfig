export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

ZSH_THEME="refined"
plugins=(
git 
colored-man-pages 
zsh-autosuggestions 
zsh-syntax-highlighting
)

bindkey '^ ' autosuggest-accept
