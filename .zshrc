# === BASIC OPTIONS ===
export EDITOR=nano
unsetopt BEEP                   # Disable terminal bell
setopt HIST_IGNORE_ALL_DUPS     # Don't store duplicates in history
setopt SHARE_HISTORY            # Share history between sessions
setopt INC_APPEND_HISTORY       # Append to history immediately
setopt AUTO_CD                  # Allows `cd folder` just by typing folder name

# === PATH SETUP ===
export PATH=$HOME/bin:/usr/local/bin:$PATH

# === PROMPT ===
PROMPT='%F{green}%n@%m%f %F{blue}%~%f %# '
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=red"
# === ALIASES ===
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias k='kubectl'
alias kctx='kubectx'
alias kns='kubens'
alias grep='grep --color=auto'

# === GIT SHORTCUT ===
gitp() {
  git add .
  COMMIT_MSG="fix"
  if [ "$#" -gt 0 ]; then
    COMMIT_MSG="$@"
  fi
  git commit -m "$COMMIT_MSG"
  git push
}

# === FUNCTIONS ===
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# === PLUGIN: zsh-autosuggestions ===
# Install it: git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# === PLUGIN: zsh-syntax-highlighting ===
# Install it: git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
# Always load this LAST
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# === STARSHIP PROMPT ===
# Install it: https://starship.rs
eval "$(starship init zsh)"
export PATH=$PATH:/snap/bin
# === COMPLETIONS (cached to avoid slowness) ===
ZSH_COMPLETIONS="$HOME/.zsh/completions"
mkdir -p "$ZSH_COMPLETIONS"

for tool in kubectl helm oc yq; do
  f="$ZSH_COMPLETIONS/${tool}_completion.zsh"
  if command -v $tool &>/dev/null; then
    if [ ! -f "$f" ]; then
      $tool completion zsh > "$f"
    fi
    source "$f"
  fi
done
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
