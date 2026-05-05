#!/bin/bash
# KDE Plasma environment configuration with mobile/desktop selection

# Source Plasma workspace prefix
if [ -f "$HOME/kde/build/plasma-workspace/prefix.sh" ]; then
    source "$HOME/kde/build/plasma-workspace/prefix.sh"
fi

# Reset plasma mobile envs
unset QT_QUICK_CONTROLS_MOBILE PLASMA_PLATFORM PLASMA_DEFAULT_SHELL KWIN_IM_SHOW_ALWAYS

[ -z "$XDG_CONFIG_DIRS_BACKUP" ] && export XDG_CONFIG_DIRS_BACKUP="$XDG_CONFIG_DIRS"
export XDG_CONFIG_DIRS="$XDG_CONFIG_DIRS_BACKUP"
export KWIN_WIDTH=1280
export KWIN_HEIGHT=960

echo "Configuration Plasma Mobile ou Desktop ?"
echo -n "Utiliser Plasma Mobile ? (o/N) "
read -r REPLY
REPLY=${REPLY:0:1}

if [[ $REPLY =~ ^[Oo]$ ]]; then
    # Plasma Mobile configuration
    export QT_QUICK_CONTROLS_MOBILE=1
    export PLASMA_PLATFORM=phone:handset
    export PLASMA_DEFAULT_SHELL=org.kde.plasma.mobileshell
    export XDG_CONFIG_DIRS="$HOME/.config/plasma-mobile:/etc/xdg:$XDG_CONFIG_DIRS"
    export KWIN_IM_SHOW_ALWAYS=1
    export KWIN_WIDTH=360
    export KWIN_HEIGHT=720

    function prepare() {
        QT_QPA_PLATFORM=offscreen plasma-mobile-envmanager --apply-settings
    }

    echo "→ Plasma Mobile activé (résolution: ${KWIN_WIDTH}x${KWIN_HEIGHT})"
else
    # Desktop configuration
    echo "→ Plasma Desktop (résolution: ${KWIN_WIDTH}x${KWIN_HEIGHT})"
fi

# Plasma helper functions

function run_kwin() {
    QT_QPA_PLATFORM=wayland dbus-run-session kwin_wayland --xwayland "$@" --width ${KWIN_WIDTH:-1280} --height ${KWIN_HEIGHT:-960}
}

function run_plasma() {
    run_kwin plasmashell
}

function run_plasma_with_gammaray() {
    run_kwin gammaray --inject-only --listen tcp://0.0.0.0:12345 plasmashell
}

function run_plasma_with_qmljsdebugger() {
    run_kwin PLASMA_ENABLE_QML_DEBUG=1 plasmashell -qmljsdebugger=port:3678,block
}

function run_gammaray() {
    if [[ "$(cat /proc/sys/kernel/yama/ptrace_scope)" -ne 0 ]]; then
        echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    fi
    gammaray
}
