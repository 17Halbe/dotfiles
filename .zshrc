# Lines configured by zsh-newuser-install
export TERM="screen-256color"
export EDITOR='nvim'

setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/alex/.zshrc'

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"


autoload -Uz compinit
compinit
# End of lines added by compinstall
source  ~/powerlevel9k/powerlevel9k.zsh-theme
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time ssh root_indicator background_jobs time battery)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator dir dir_writable rbenv vcs)

# ------------------------------------------------------------------------------
# Description
# -----------
#
# sudo or sudoedit will be inserted before the command
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
# * Dongweiming <ciici123@gmail.com>
#
# ------------------------------------------------------------------------------

sudo-command-line() {
[[ -z $BUFFER ]] && zle up-history
if [[ $BUFFER == sudo\ * ]]; then
  LBUFFER="${LBUFFER#sudo }"
elif [[ $BUFFER == $EDITOR\ * ]]; then
  LBUFFER="${LBUFFER#$EDITOR }"
  LBUFFER="sudoedit $LBUFFER"
elif [[ $BUFFER == sudoedit\ * ]]; then
  LBUFFER="${LBUFFER#sudoedit }"
  LBUFFER="$EDITOR $LBUFFER"
else
  LBUFFER="sudo $LBUFFER"
fi
}
zle -N sudo-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey "\e\e" sudo-command-line

######################### PLUGINS ##########################
FZF_COMPLETION_TRIGGER=';'
export FZF_TMUX=1
#export FZF_DEFAULT_OPTS=""
export FZF_CTRL_T_OPTS="--no-height --preview '(pdftotext -f 1 -l 1 "{}" - 2> /dev/null || if [[ -d "{}" ]]; then; tree -C "{}"; else; ccat "{}" --color=always;fi) 2> /dev/null | head -200' --preview-window=right:70%:wrap" 
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window right:70%:hidden:wrap --bind '?:toggle-preview' --exact --no-height"
#export FZF_ALT_C_COMMAND="locate /{}"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=6'
ZSH_AUTOSUGGEST_HIGHLIGHT_STRATEG='match_prev_cmd'
source ~/.config/zsh/zsh-interactive-cd.plugin/zsh-interactive-cd.plugin.zsh
source ~/.config/zsh/web-search/web-search.zsh
source ~/.config/zsh/pdf/pdf.zsh
source ~/.zpyi/zpyi.zsh

fd() {
  local dir
  dir=$(find ${1:-/} -path '*/\.*' -prune \
    -o -type d -print 2> /dev/null | /home/alex/.fzf/bin/fzf +m) &&
    cd "$dir"
}

fo() {
  local out file key
  IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}

########################## ALIASES #########################

alias ls='ls -Ap --group-directories-first --color'
alias ll='ls -Alh --group-directories-first --color'
alias syslog='tail -f /var/log/syslog'
alias wifi='sudo zsh -c "grep psk= /etc/NetworkManager/system-connections/* | sed \"s/.*\\///g\" | sed \"s/:psk=/\tPassword: /\" | expand -t 25"'
alias cat='ccat'
alias ocat='/bin/cat'
alias dif='icdiff -N'
alias psa='ps aux | grep'

function log(){
  if [ "$1" != "" ]
  then
    tail -f /var/log/"$1"
  else
    tail -f /var/log/syslog
  fi
}

zle -N log

chpwd() {
  ls
}
##############################################################################
# History Configuration
##############################################################################
HISTSIZE=5000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=5000               #Number of history entries to save to disk
#HISTDUP=erase               #Erase duplicates in the history file
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt incappendhistory #Immediately append to the history file, not just when a term is killed

zle -N history-substring-search-up
zle -N history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

#### HAS TO BE THE LAST LINES. ### FISH-like autocompletion
source /home/alex/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
