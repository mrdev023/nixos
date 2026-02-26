{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.home.configs.distrobox;

  initHook = pkgs.writeScriptBin "init_hooks" ''
    rm /usr/bin/flatpak
    cp -f /etc/skel/.* $HOME/

    ln -s ${config.home.homeDirectory}/.ssh $HOME/.ssh

    # Needed because distrobox with --init it's not a seat session
    cat > /usr/share/polkit-1/rules.d/49-allow-kde.rules << EOF
    polkit.addRule(function(action, subject) {
        if (action.id.startsWith("org.kde.") && subject.isInGroup("wheel")) {
            return polkit.Result.YES;
        }
    });
    EOF

    cat > $HOME/run.sh << 'EOF'
    # Ensure we are in the correct prefix
    source $HOME/kde/build/plasma-mobile/prefix.sh

    # Environment variables
    export QT_QUICK_CONTROLS_MOBILE=1
    export PLASMA_PLATFORM=phone:handset
    export PLASMA_DEFAULT_SHELL=org.kde.plasma.mobileshell
    export QT_QUICK_CONTROLS_STYLE=org.kde.breeze
    export KWIN_IM_SHOW_ALWAYS=1
    export QT_ASSUME_STDERR_HAS_CONSOLE=1
    export QT_FORCE_STDERR_LOGGING=1
    export QT_LOGGING_RULES="*.warning=true;*waydroid*.debug=true"

    # Set ~/.config/plasma-mobile/... as location for default mobile configs (i.e. envmanager generated)
    export XDG_CONFIG_DIRS="$HOME/.config/plasma-mobile:/etc/xdg:$XDG_CONFIG_DIRS"

    function prepare() {
        # Ensure that we have our environment settings set properly prior to the shell being loaded (otherwise there is a race condition with autostart)
        QT_QPA_PLATFORM=offscreen plasma-mobile-envmanager --apply-settings
    }

    function run_kwin() {
        QT_QPA_PLATFORM=wayland dbus-run-session kwin_wayland --xwayland "$*" --width 360 --height 720
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
        # Disable temporary for gammaray running
        if [[ "$(cat /proc/sys/kernel/yama/ptrace_scope)" -ne 0 ]]; then
            echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        fi
        gammaray
    }

    function run_and_attach_gdb() {
        $@ &
        attach_gdb $! $1
    }

    function attach_gdb_to_program() {
        program_name=$1
        program_pid=$(pidof -s $program_name)
        attach_gdb $program_pid $program_name
    }

    function attach_gdb() {
        program_pid=$1
        program_name=$2
        gdb -pid $program_pid -batch -ex "set debuginfod enabled on" -ex "set logging file $program_name.gdb" -ex "set logging enabled on" -ex "continue" -ex "thread apply all backtrace" -ex "quit"
    }
    EOF

    cat > $HOME/copy_polkit.sh << 'EOF'
    TMP_POLKIT_DIR=$HOME/kde/usr/share/polkit-1/actions/tmp
    mkdir -p $TMP_POLKIT_DIR

    # Copy all files in /kde/usr/share/polkit-1/actions/*.policy with the new name 99-<old_name>-custom.policy to avoid conflict with packaged files
    for f in $HOME/kde/usr/share/polkit-1/actions/*.policy; do
        base=$(basename "$f" .policy)
        cp "$f" "$TMP_POLKIT_DIR/99-$base-custom.policy"
    done

    sudo cp -r $TMP_POLKIT_DIR/* /usr/share/polkit-1/actions/
    rm -rf $TMP_POLKIT_DIR
    EOF

    cat >> $HOME/.bashrc << 'EOF'
    # Cleaning nix injected envs
    unset NIX_PATH
    unset NIXPKGS_CONFIG
    unset NIX_USER_PROFILE_DIR
    unset NIX_XDG_DESKTOP_PORTAL_DIR
    unset NIXPKGS_QT6_QML_IMPORT_PATH
    unset QT_PLUGIN_PATH
    unset KPACKAGE_DEP_RESOLVERS_PATH
    unset GDK_PIXBUF_MODULE_FILE
    unset CUPS_DATADIR
    unset SSH_ASKPASS
    unset GIO_EXTRA_MODULES
    unset INFOPATH
    unset TERMINFO
    unset TERMINFO_DIRS
    unset GTK_PATH
    unset QTWEBKIT_PLUGIN_PATH
    unset LESSKEYIN_SYSTEM
    unset QML2_IMPORT_PATH
    unset LIBEXEC_PATH

    export XCURSOR_PATH=$HOME/.local/share/icons:$HOME/.icons:/usr/share/icons:/usr/share/pixmaps:/usr/X11R6/lib/X11/icons
    export XDG_SESSION_TYPE=wayland
    export XDG_MENU_PREFIX=plasma-
    export XDG_CONFIG_DIRS=$HOME/.config/kdedefaults:$HOME/kde/usr/etc/xdg:/etc/xdg
    export XDG_DATA_DIRS=$HOME/kde/usr/share:$HOME/.local/share/applications:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share
    export PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/var/lib/flatpak/exports/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl
    export WAYLAND_DISPLAY=wayland-0 # waydroid create --init params seems to remove it
    export COLORTERM=truecolor
    export TERM=xterm-256color

    # Required for kde-builder
    export PATH="$HOME/.nix-profile/bin:$HOME/.local/bin:$PATH"

    if [[ ! -f $HOME/.local/bin/kde-builder ]]; then
        echo "Finishing configurations for kde development"

        sudo chown ${config.home.username}:${config.home.username} $HOME/{.config,.ssh,run.sh,copy_polkit.sh}
        sudo chmod u+x $HOME/{run.sh,copy_polkit.sh}

        curl 'https://invent.kde.org/sdk/kde-builder/-/raw/master/scripts/initial_setup.sh?ref_type=heads' > $HOME/initial_setup.sh
        bash $HOME/initial_setup.sh
        rm $HOME/initial_setup.sh

        kde-builder --generate-config
        kde-builder --install-distro-packages

        sed -i 's/generate-clion-project-config:\ false/generate-clion-project-config:\ true/g' $HOME/.config/kde-builder.yaml
        sed -i 's/generate-vscode-project-config:\ false/generate-vscode-project-config:\ true/g' $HOME/.config/kde-builder.yaml
        sed -i 's/generate-qtcreator-project-config:\ false/generate-qtcreator-project-config:\ true/g' $HOME/.config/kde-builder.yaml
    fi
    EOF

    # Avoid sleep on distrobox for plasma development
    sed -i 's/#IdleAction=ignore/IdleAction=ignore/g' /etc/systemd/logind.conf
  '';
in
{
  options.modules.home.configs.distrobox = {
    enable = mkEnableOption ''
      Enable distrobox configuration
    '';
  };
  config = mkIf cfg.enable {
    xdg.configFile."distrobox/distrobox.conf".text = ''
      ${getExe pkgs.xhost} +si:localuser:${config.home.username} > /dev/null
    '';

    xdg.configFile."distrobox/kdedev.ini".text = ''
      [kdedev]
      home=${config.home.homeDirectory}/distrobox/kdedev
      init_hooks="${getExe initHook}"
      additional_packages="kde-cli-tools base-devel nix"
      image=docker.io/archlinux:latest
      init=true
      nvidia=true
      pull=true
      root=false
    '';
  };
}
