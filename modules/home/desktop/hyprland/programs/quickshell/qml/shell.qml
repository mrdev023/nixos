//@ pragma UseQApplication
import QtQuick
import Quickshell as QS
import Quickshell.Hyprland as QSH

import "singletons"

QtObject {
    property var _screens: QS.Variants {
        model: QS.Quickshell.screens
        TopBar {
            required property var modelData
            screen: modelData
        }
    }

    property var _launcherToggle: QSH.GlobalShortcut {
        name: "launcher_toggle"
        onPressed: {
            if (Launcher.opened) Launcher.close();
            else Launcher.open();
        }
    }

    property var _clipboardToggle: QSH.GlobalShortcut {
        name: "clipboard_toggle"
        onPressed: {
            if (Clipboard.opened) Clipboard.close();
            else Clipboard.open();
        }
    }

    property var _clipboardWipe: QSH.GlobalShortcut {
        name: "clipboard_wipe"
        onPressed: Clipboard.wipe()
    }
}
