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

VENV() {
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
}
CONSOLE() {
  u=$(oc get route -n openshift-console  console -o jsonpath='{.spec.host}')
  open -a Firefox http://$u
}
#alias CONSOLE="oc get route -n openshift-console  console -o jsonpath='{.spec.host}' |pbcopy"
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
_octx_tmux_rename() {
    # Match if the command starts with "octx "
    if [[ "$1" =~ ^octx[[:space:]]+(.*) ]]; then
        # Extract the cluster name (everything after "octx ")
        local cluster_name="${match[1]}"
        
        # Rename the window after a tiny delay so it happens after octx runs
        if [ -n "$TMUX" ]; then
            (sleep 0.1; tmux rename-window "$cluster_name") &!
        fi
    fi
}
add-zsh-hook preexec _octx_tmux_rename
APPROVE() {
kubectl get installplans.operators.coreos.com -A -o jsonpath='{range .items[?(@.spec.approved==false)]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}' | while read -r ns name; do 
  kubectl patch installplan "$name" -n "$ns" --type merge -p '{"spec":{"approved":true}}'
done
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
alias velero='velero -n openshift-gitops '
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

export KIND_EXPERIMENTAL_PROVIDER=podman

export PATH="$HOME/.local/bin:$PATH"
