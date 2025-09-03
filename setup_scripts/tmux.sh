#!/usr/bin/env bash

# Tmux setup script with Catppuccin, CPU and Battery plugins
# This script checks and installs only if missing

set -e

# Define plugin install paths
PLUGIN_DIR="$HOME/.config/tmux/plugins"
CATPPUCCIN_DIR="$PLUGIN_DIR/catppuccin"
CPU_DIR="$PLUGIN_DIR/tmux-cpu"
BATTERY_DIR="$PLUGIN_DIR/tmux-battery"

# Config file relative path (../.tmux.conf)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_CONF="$SCRIPT_DIR/../.tmux.conf"

echo "=== Starting tmux setup ==="

# Ensure plugin directory exists
if [ ! -d "$PLUGIN_DIR" ]; then
    echo "[+] Creating plugin directory at $PLUGIN_DIR"
    mkdir -p "$PLUGIN_DIR"
else
    echo "[✔] Plugin directory already exists: $PLUGIN_DIR"
fi

# Install Catppuccin
if [ ! -d "$CATPPUCCIN_DIR" ]; then
    echo "[+] Installing Catppuccin theme..."
    git clone https://github.com/catppuccin/tmux.git "$CATPPUCCIN_DIR"
else
    echo "[✔] Catppuccin already installed"
fi

# Install tmux-cpu
if [ ! -d "$CPU_DIR" ]; then
    echo "[+] Installing tmux-cpu..."
    git clone https://github.com/tmux-plugins/tmux-cpu.git "$CPU_DIR"
else
    echo "[✔] tmux-cpu already installed"
fi

# Install tmux-battery
if [ ! -d "$BATTERY_DIR" ]; then
    echo "[+] Installing tmux-battery..."
    git clone https://github.com/tmux-plugins/tmux-battery.git "$BATTERY_DIR"
else
    echo "[✔] tmux-battery already installed"
fi

# Write .tmux.conf into ../.tmux.conf
if [ ! -f "$TMUX_CONF" ]; then
    echo "[+] Creating new config at $TMUX_CONF"
    cat > "$TMUX_CONF" <<'EOF'
# ../.tmux.conf

##### 🔁 Reload Config #####
bind r source-file ~/.tmux.conf \; display-message "Reloaded .tmux.conf"

##### 📟 Core Settings #####
set -g mouse on
set -g default-terminal "tmux-256color"
set -g base-index 1
setw -g pane-base-index 1
set -g status-left-length 100
set -g status-right-length 100

##### 🎨 Catppuccin Theme #####
set -g @catppuccin_flavor "mocha"
set -g @catppuccin_window_status_style "rounded"
run '~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux'

##### 🎛 Status Line #####
set -g status-left ""
set -g status-right "#{E:@catppuccin_status_application}"
set -agF status-right "#{E:@catppuccin_status_cpu}"
set -ag status-right "#{E:@catppuccin_status_session}"
set -ag status-right "#{E:@catppuccin_status_uptime}"
set -agF status-right "#{E:@catppuccin_status_battery}"

##### 🔌 Extra Plugins (manual load) #####
run '~/.config/tmux/plugins/tmux-cpu/cpu.tmux'
run '~/.config/tmux/plugins/tmux-battery/battery.tmux'
EOF
else
    echo "[✔] Config file already exists at $TMUX_CONF (skipping creation)"
fi

echo "=== Tmux setup completed successfully ==="
echo "-> Start tmux and press 'prefix + r' to reload config"
