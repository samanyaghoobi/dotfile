# ============================
#         Zinit Setup
# ============================

source ~/.local/share/zinit/zinit.zsh

autoload -Uz compinit && compinit
autoload -U colors && colors
setopt prompt_subst

# ============================
#        Plugins (async)
# ============================

# Autosuggestions
zinit ice wait"1" blockf lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# Syntax Highlighting
zinit ice wait"2" blockf compile
zinit light zdharma-continuum/fast-syntax-highlighting

# Autocomplete
zinit ice wait"3" blockf compile
zinit light marlonrichert/zsh-autocomplete


# ============================
#    Git Prompt Configuration
# ============================
git_prompt() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    local branch git_status_symbol git_color
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD)

    if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
      git_status_symbol="%F{red}✗%f"
    else
      git_status_symbol="%F{green}✓%f"
    fi

    echo " %F{yellow}[ $branch $git_status_symbol]%f"
  fi
}

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

function git_info_if_repo() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    git_super_status
  fi
}

function precmd() {
  local width=$(tput cols)
  local userhost="${USER}@${HOST}"
  local color="%F{242}"
  local reset="%f"
  print -P "${color}$(printf '%*s' "$width" '' | tr ' ' '-')${reset}"
}
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

if [ -d "$HOME/miniconda3" ]; then
  export PATH="$HOME/miniconda3/bin:$PATH"
  eval "$(conda shell.zsh hook)"
  conda config --set auto_activate_base false
fi

# ============================
#         Java Settings
# ============================

if [ -d "/usr/lib/jvm/java-21-openjdk-amd64" ]; then
  export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
  export PATH=$JAVA_HOME/bin:$PATH
fi
