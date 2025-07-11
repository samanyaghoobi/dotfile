# ============================
#         Zinit Setup
# ============================
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# Enable completion and colors
autoload -Uz compinit && compinit
autoload -U colors && colors
setopt prompt_subst

# ============================
#        Plugins (async)
# ============================

# zsh-autosuggestions (for auto-completions)
zinit ice lucid atload"_zsh_autosuggest_start" 
zinit light zsh-users/zsh-autosuggestions

# fast-syntax-highlighting (for syntax highlighting)
zinit ice compile
zinit light zdharma-continuum/fast-syntax-highlighting

# zsh-autocomplete (for advanced auto-completion)
zinit ice compile
zinit light marlonrichert/zsh-autocomplete

# Git prompt (with git status)
zinit ice blockf pick"zshrc.sh"
zinit light olivierverdier/zsh-git-prompt

# ============================
#    Git Prompt Configuration
# ============================

# Enable Git Prompt symbols
export GIT_PROMPT_SHOW_UPSTREAM=1
export GIT_PROMPT_SYMBOLS_AHEAD="↑"
export GIT_PROMPT_SYMBOLS_BEHIND="↓"
export GIT_PROMPT_SYMBOLS_NO_REMOTE_TRACKING="L"
export GIT_PROMPT_SYMBOLS_UNTRACKED="?"
export GIT_PROMPT_SYMBOLS_MODIFIED="✗"
export GIT_PROMPT_SYMBOLS_STAGED="+"
export GIT_PROMPT_SYMBOLS_CLEAN="✓"
export GIT_PROMPT_START="["
export GIT_PROMPT_END="]"

# ============================
#      Prompt & Header Line
# ============================

# Show Git status if in a Git repo
function git_prompt() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    local branch git_status_symbol
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD)
    git_status_symbol="%F{green}✓%f"
    if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
      git_status_symbol="%F{red}✗%f"
    fi
    echo " %F{yellow}[ $branch $git_status_symbol]%f"
  fi
}

# Header line before prompt
function precmd() {
  local width=$(tput cols)
  local userhost="${USER}@${HOST}"
  local color="%F{242}"
  local reset="%f"
  print -P "${color}$(printf '%*s' "$width" '' | tr ' ' '-')${reset}"
}

# Main Prompt
PROMPT='%F{green}%~%f$(git_prompt) %F{blue}»%f '
RPROMPT='%F{242}%n@%m%f'

# ============================
#       Shared History
# ============================

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt share_history
setopt inc_append_history
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt extended_history

# ============================
#       Aliases & Custom
# ============================

[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
[[ -f ~/.copyfile ]] && source ~/.copyfile

# ============================
#         Conda Settings
# ============================

# Ensure Conda is already installed and initialized (no need for auto-install)
[[ -d "$HOME/miniconda3" ]] && source "$HOME/miniconda3/etc/profile.d/conda.sh"

# ============================
#         Java Settings
# ============================

if [ -d "/usr/lib/jvm/java-21-openjdk-amd64" ]; then
  export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
  export PATH=$JAVA_HOME/bin:$PATH
fi

### End of Zinit's installer chunk
