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
            if (Launcher.opened)
                Launcher.close();
            else
                Launcher.open();
        }
    }

    property var _clipboardToggle: QSH.GlobalShortcut {
        name: "clipboard_toggle"
        onPressed: {
            if (Clipboard.opened)
                Clipboard.close();
            else
                Clipboard.open();
        }
    }

    property var _clipboardWipe: QSH.GlobalShortcut {
        name: "clipboard_wipe"
        onPressed: Clipboard.wipe()
    }

    property var _sessionLock: QSH.GlobalShortcut {
        name: "session_lock"
        onPressed: SessionLock.lock()
    }

    property var _audioUp: QSH.GlobalShortcut {
        name: "audio_up"
        onPressed: AudioManager.audioUp()
    }

    property var _audioDown: QSH.GlobalShortcut {
        name: "audio_down"
        onPressed: AudioManager.audioDown()
    }

    property var _audioMuteToggle: QSH.GlobalShortcut {
        name: "audio_mute_toggle"
        onPressed: AudioManager.audioMuteToggle()
    }

    property var _micMuteToggle: QSH.GlobalShortcut {
        name: "mic_mute_toggle"
        onPressed: AudioManager.micMuteToggle()
    }
}
