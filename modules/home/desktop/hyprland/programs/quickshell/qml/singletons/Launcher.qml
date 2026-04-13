pragma Singleton

import Quickshell

Singleton {
    id: root

    property bool opened: false
    property string searchText: ""

    function open(): void {
        // Must close Clipboard to avoid broke it
        Clipboard.opened = false;
        searchText = "";
        opened = true;
    }

    function close(): void {
        opened = false;
    }
}
