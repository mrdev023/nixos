unset NIX_PATH NIXPKGS_CONFIG NIX_USER_PROFILE_DIR NIX_XDG_DESKTOP_PORTAL_DIR
unset NIXPKGS_QT6_QML_IMPORT_PATH QT_PLUGIN_PATH KPACKAGE_DEP_RESOLVERS_PATH
unset GDK_PIXBUF_MODULE_FILE CUPS_DATADIR SSH_ASKPASS GIO_EXTRA_MODULES
unset INFOPATH TERMINFO TERMINFO_DIRS GTK_PATH QTWEBKIT_PLUGIN_PATH
unset LESSKEYIN_SYSTEM QML2_IMPORT_PATH LIBEXEC_PATH

export XCURSOR_PATH="$HOME/.local/share/icons:$HOME/.icons:/usr/share/icons:/usr/share/pixmaps:/usr/X11R6/lib/X11/icons"
export XDG_SESSION_TYPE=wayland
export XDG_MENU_PREFIX=plasma-
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export XDG_CONFIG_DIRS="$HOME/.config/kdedefaults:$HOME/kde/usr/etc/xdg:/etc/xdg"
export XDG_DATA_DIRS="$HOME/kde/usr/share:$HOME/.local/share/applications:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share"
export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/var/lib/flatpak/exports/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:$HOME/.nix-profile/bin:$HOME/.local/bin"
export COLORTERM=truecolor
export TERM=xterm-256color
export QML2_IMPORT_PATH=/usr/lib/qt6/qml:/usr/lib/qt/qml
export QT_PLUGIN_PATH=/usr/lib/qt6/plugins:/usr/lib/qt/plugins

# WAYLAND_DISPLAY is removed by distrobox
#   On hyprland, display is wayland-1 and on KDE wayland-0
if [ -d "$XDG_RUNTIME_DIR" ]; then
    wayland_socket=$(ls "$XDG_RUNTIME_DIR"/wayland-* 2>/dev/null | grep -v '\.lock$' | head -1)
    if [ -n "$wayland_socket" ]; then
        export WAYLAND_DISPLAY=$(basename "$wayland_socket")
    fi
fi
