# --- 1. Styles (MUST BE AT THE TOP) ---
# These must be defined before Oh My Zsh runs 'compinit'
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
autoload -U compinit
compinit -i
setopt HIST_IGNORE_ALL_DUPS     # Don't store duplicates in history
plugins=(git zsh-autosuggestions)
eval "$(starship init zsh)"
# eval "$(octx init zsh)"

# --- 2. Oh My Zsh Path ---
export ZSH="$HOME/.oh-my-zsh"

# --- 3. Disable OMZ Theme ---
ZSH_THEME=""
alias VENV='python3 -m venv venv ; source venv/bin/activate'
alias -g C=' | pbcopy'
alias -g JQ=' | jq'
alias -g YQ=' | yq'
# --- 4. Plugins ---
# Added 'kubectl' so you get proper Kubernetes completions
plugins=(
    git
    kubectl
    zsh-autosuggestions
#    zsh-history-substring-search
#     zsh-autocomplete
    zsh-syntax-highlighting    
)
ZSH_COMPLETIONS="$HOME/.zsh/completions"

for tool in kubectl helm oc yq; do
  f="$ZSH_COMPLETIONS/${tool}_completion.zsh"
  if command -v $tool &>/dev/null; then
    if [ ! -f "$f" ]; then
      $tool completion zsh > "$f"
    fi
    source "$f"
  fi
done
# --- 5. Load Oh My Zsh ---
source $ZSH/oh-my-zsh.sh

# --- 6. Starship (Bottom) ---
eval "$(starship init zsh)"
gitp() {
  git add .
  COMMIT_MSG="fix"
  if [ "$#" -gt 0 ]; then
    COMMIT_MSG="$@"
  fi
  git commit -m "$COMMIT_MSG"
  git push
}
eval "$(octx init zsh)"
#source $HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

ZSH_COMPLETIONS="$HOME/.zsh/completions"
mkdir -p "$ZSH_COMPLETIONS"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls --color=auto'
alias k='kubectl'
alias kctx='kubectx'
alias kns='kubens'
alias watch='watch '
alias grep='grep --color=auto'
alias tridentctl='tridentctl -n trident '
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

export KIND_EXPERIMENTAL_PROVIDER=podman
