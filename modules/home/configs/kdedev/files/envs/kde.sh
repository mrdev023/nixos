#!/bin/bash
# KDE Qt environment configuration

export QT_QUICK_CONTROLS_STYLE=org.kde.breeze
export QT_ASSUME_STDERR_HAS_CONSOLE=1
export QT_FORCE_STDERR_LOGGING=1
export QT_LOGGING_RULES="*.warning=true;*waydroid*.debug=true"

# GDB debugging helper functions

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
