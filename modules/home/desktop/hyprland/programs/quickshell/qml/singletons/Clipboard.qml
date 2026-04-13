pragma Singleton

import Quickshell
import Quickshell.Io as QSI

Singleton {
    id: root

    property bool opened: false
    property string searchText: ""
    property list<string> entries: []

    function open(): void {
        // Must close Launcher to avoid broke it
        Launcher.opened = false;
        searchText = "";
        entries = [];
        _listProcess.running = true;
        opened = true;
    }

    function close(): void {
        opened = false;
    }

    function select(line: string): void {
        _decodeProcess.command = ["sh", "-c", "printf '%s\\n' \"$1\" | cliphist decode | wl-copy", "sh", line];
        _decodeProcess.running = true;
        _notify("Élément copié dans le presse-papier");
        close();
    }

    function wipe(): void {
        _wipeProcess.running = true;
    }

    function _notify(message: string): void {
        _notifyProcess.command = ["notify-send", "-u", "low", message];
        _notifyProcess.running = true;
    }

    QSI.Process {
        id: _listProcess
        command: ["cliphist", "list"]
        running: false
        stdout: QSI.SplitParser {
            onRead: line => {
                if (line !== "")
                    root.entries = [...root.entries, line];
            }
        }
    }

    QSI.Process {
        id: _decodeProcess
        running: false
    }

    QSI.Process {
        id: _wipeProcess
        command: ["cliphist", "wipe"]
        running: false
        onExited: root._notify("Presse-papier vidé")
    }

    QSI.Process {
        id: _notifyProcess
        running: false
    }
}
