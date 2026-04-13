pragma Singleton

import Quickshell

Singleton {
    id: root

    property bool opened: false

    function open(): void {
        // Must close Clipboard to avoid broke it
        Clipboard.close();
        opened = true;
    }

    function close(): void {
        opened = false;
    }
}
