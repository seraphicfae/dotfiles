# ─── Paths ──────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ─── Plugin Manager ─────────────────────────────────────
source "${HOME}/.config/zsh/antidote/antidote.zsh"
antidote load "${HOME}/.config/zsh/.zsh_plugins.txt"

# ─── Zsh Options ────────────────────────────────────────
autoload -Uz compinit && compinit
setopt autocd
setopt prompt_subst
setopt correct
setopt hist_ignore_dups
setopt share_history
setopt menucomplete

# ─── History ────────────────────────────────────────────
HISTFILE="${HOME}/.config/zsh/zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt inc_append_history
setopt share_history

# ─── Commands ────────────────────────────────────────────
icd() {
  local dir
  dir=$(zoxide query -ls | awk '{$1=""; print substr($0,2)}' | \
    fzf --height=40% --reverse --prompt="Select dir: " \
        --preview 'ls -la {}' --preview-window=right:60%)
  if [[ -n "$dir" ]]; then
    cd "$dir" || echo "Failed to cd into '$dir'"
  fi
}

bindkey -s '^F' 'icd\n'

# ─── Evals ────────────────────────────────────
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

# ─── Aliases ────────────────────────────────────
alias fastfetch=' clear && fastfetch'
alias zed='zeditor && exit'
