source "$HOME/kde/build/plasma-mobile/prefix.sh"

export QT_QUICK_CONTROLS_MOBILE=1
export PLASMA_PLATFORM=phone:handset
export PLASMA_DEFAULT_SHELL=org.kde.plasma.mobileshell
export QT_QUICK_CONTROLS_STYLE=org.kde.breeze
export KWIN_IM_SHOW_ALWAYS=1
export QT_ASSUME_STDERR_HAS_CONSOLE=1
export QT_FORCE_STDERR_LOGGING=1
export QT_LOGGING_RULES="*.warning=true;*waydroid*.debug=true"
export XDG_CONFIG_DIRS="$HOME/.config/plasma-mobile:/etc/xdg:$XDG_CONFIG_DIRS"

function prepare() {
    QT_QPA_PLATFORM=offscreen plasma-mobile-envmanager --apply-settings
}

function run_kwin() {
    QT_QPA_PLATFORM=wayland dbus-run-session kwin_wayland --xwayland "$@" --width 360 --height 720
}

function run_plasma() {
    run_kwin plasmashell -p org.kde.plasma.mobileshell
}

function run_plasma_with_gammaray() {
    run_kwin gammaray --inject-only --listen tcp://0.0.0.0:12345 plasmashell -p org.kde.plasma.mobileshell
}

function run_plasma_with_qmljsdebugger() {
    run_kwin PLASMA_ENABLE_QML_DEBUG=1 plasmashell -p org.kde.plasma.mobileshell -qmljsdebugger=port:3678,block
}

function run_gammaray() {
    if [[ "$(cat /proc/sys/kernel/yama/ptrace_scope)" -ne 0 ]]; then
        echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    fi
    gammaray
}

function run_and_attach_gdb() {
    "$@" &
    attach_gdb $! "$1"
}

function attach_gdb_to_program() {
    local program_name=$1
    local program_pid
    program_pid=$(pidof -s "$program_name")
    attach_gdb "$program_pid" "$program_name"
}

function attach_gdb() {
    local program_pid=$1
    local program_name=$2
    gdb -pid "$program_pid" -batch \
        -ex "set debuginfod enabled on" \
        -ex "set logging file $program_name.gdb" \
        -ex "set logging enabled on" \
        -ex "continue" \
        -ex "thread apply all backtrace" \
        -ex "quit"
}
