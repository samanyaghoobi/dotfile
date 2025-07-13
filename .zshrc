# ============================
#        ZSH Configuration
# ============================

# ----------------------------
#     ZSH Environment Variables
# ----------------------------
export ZSH="$HOME/.oh-my-zsh"
export PATH="$PATH:/home/saman/.local/bin"
export V2RAY_LOCATION_ASSET=/usr/local/share/v2ray/
export MIBS=+custom
export CHROME_EXECUTABLE=/snap/bin/chromium

# ----------------------------
#     ZSH Theme and Colorization
# ----------------------------
#source ~/.afmagic-custom.zsh-theme
ZSH_THEME="af-magic"
#ZSH_THEME="bira"
#ZSH_THEME="fox"
#ZSH_THEME="fino-time"
ZSH_COLORIZE_TOOL=chroma
ZSH_COLORIZE_STYLE="colorful"

# ----------------------------
#     ZLE Widgets
# ----------------------------
# Define missing ZLE widgets
zle -N menu-search
zle -N recent-paths

# ----------------------------
#     Plugins
# ----------------------------
plugins=(
    eza
    git
    sudo
    copypath
    colored-man-pages
    command-not-found
    zsh-autosuggestions
    fast-syntax-highlighting
)

# ----------------------------
#     Enable Correction
# ----------------------------
ENABLE_CORRECTION="true"

# ----------------------------
#     Source Oh My Zsh
# ----------------------------
source $ZSH/oh-my-zsh.sh

# ----------------------------
#     Additional Configurations
# ----------------------------
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
[[ -f ~/.copyfile ]] && source ~/.copyfile

# ----------------------------
#     Conda Initialization
# ----------------------------
__conda_setup="$('/home/saman/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/saman/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/saman/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/saman/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
