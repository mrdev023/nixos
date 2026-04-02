pragma Singleton

import Quickshell

Singleton {
    id: root

    property bool opened: false
    property string searchText: ""

    function open(): void {
        searchText = "";
        opened = true;
    }

    function close(): void {
        opened = false;
    }
}
