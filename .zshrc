# =========================== #
#        ZSH Configuration    #
#         Arch Linux          #
# =========================== #

# --- Interactive Shell Check ---
case $- in
  *i*) ;;  # interactive, do nothing
  *) return ;;  # non-interactive, stop loading rest
esac


# --- Prompt ---
PROMPT='%F{81}%~%f %F{244}›%f '
# PROMPT='%F{yellow}%~%f %# '


# --- Environment Variables ---
export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="brave"

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH="/opt/cuda/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export LD_LIBRARY_PATH="/opt/cuda/lib64:$LD_LIBRARY_PATH"

export BUN_INSTALL="$HOME/.bun"
export SUDO_PROMPT="🔑 : %p → "


# --- History Settings ---
HISTFILE=~/.zsh_history
HISTSIZE=500000
SAVEHIST=500000

setopt INC_APPEND_HISTORY        # write immediately
setopt SHARE_HISTORY             # share history across sessions
setopt HIST_IGNORE_ALL_DUPS      # remove duplicates
setopt HIST_IGNORE_SPACE         # ignore cmds starting with space
setopt HIST_VERIFY               # don't execute right after !expansion
setopt HIST_BEEP                 # beep on failed history expansion


# --- Aliases ---
alias ..='cd ..'
alias ...='cd ../..'
alias art='python3 ~/scripts/art.py'
alias c='clear'
alias cat='bat'
alias cfg='cd ~/.config'
alias g='git'
alias ga='git add'
alias gc='git commit -m'
alias gd='git diff'
alias gl='git pull --rebase'
alias gp='git push'
alias gs='git status -sb'
alias grep='grep --color=auto'
alias install='sudo pacman -S'
alias journal='python /home/fraktal/scripts/journal_questions.py'
alias la='lsd -lha'
alias ll='lsd -lah'
alias ls='lsd'
alias menu='walker -show drun'
alias n='nvim'
alias p5media='cd /home/fraktal/p/p5js/composer; npx serve .'
alias py='python'
alias r='ranger-cd'
alias remove='sudo pacman -Rn'
alias rm='rm -r'
alias s='~/.config/fraktal/scripts/show-scripts.sh'
alias storage='lsblk -o NAME,MODEL,SIZE,FSTYPE,FSUSED,FSAVAIL,FSUSE%,MOUNTPOINT -e7'
alias todo='python3 ~/scripts/todo.py'
alias update='sudo pacman -Syu'
alias o='nautilus . &'


# --- Options ---
setopt AUTO_CD             # type directory name to cd
setopt AUTO_MENU           # show menu on tab complete
setopt COMPLETE_IN_WORD
setopt CORRECT             # autocorrect mistakes
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS
setopt MENU_COMPLETE       # cycles through options
setopt NOMATCH             # don't expand unmatched globs


# --- Keybindings ---
bindkey -e
bindkey '^[[1;5C' forward-word    # Ctrl+Right
bindkey '^[[1;5D' backward-word   # Ctrl+Left
bindkey '^R' history-incremental-search-backward


# --- fzf Integration ---
if command -v fzf &> /dev/null; then
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi


# --- Custom Functions ---
mkcd() {
  mkdir -p "$1" && cd "$1"
}

function ranger-cd {
  local IFS=$'\t\n'
  local tempfile
  tempfile="$(mktemp -t tmp.XXXXXX)"
  local ranger_cmd=(
    command ranger --cmd="map q chain shell echo %d > \"$tempfile\"; quitall"
  )
  "${ranger_cmd[@]}" "$@"
  if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(pwd)" ]]; then
    cd -- "$(cat "$tempfile")" || return
  fi
  command rm -f -- "$tempfile" 2>/dev/null
}


# --- Completions ---
autoload -Uz compinit bashcompinit
mkdir -p ~/.cache/zsh

zstyle ':completion:*' menu select
zstyle ':completion:*:descriptions' format $'%F{yellow}-- %d --%f'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-prompt '%SAt %p: Hit TAB for more, or type to filter%s'

compinit -d ~/.cache/zsh/.zcompdump


# --- Plugins ---
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# --- Kitty Terminal Integration ---
if [[ -n "$KITTY_INSTALLATION_DIR" ]]; then
  export KITTY_SHELL_INTEGRATION="enabled"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR/shell-integration/zsh/kitty-integration"
  kitty-integration
  unfunction kitty-integration
fi


# --- External Completions ---
[[ -f /home/fraktal/.dart-cli-completion/zsh-config.zsh ]] && \
  . /home/fraktal/.dart-cli-completion/zsh-config.zsh || true


# --- Bun Setup ---
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"


# --- Extras ---
eval "$(zoxide init zsh)"
source /usr/share/nvm/init-nvm.sh

