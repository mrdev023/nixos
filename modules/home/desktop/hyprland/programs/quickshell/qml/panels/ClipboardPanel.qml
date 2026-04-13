import QtQuick
import Quickshell as QS
import Quickshell.Hyprland as QSH

import "./components"
import "./components/clipboard"
import "../singletons"

PickerPanel {
    id: root

    pickerOpened: Clipboard.opened && QSH.Hyprland.monitorFor(topBar.screen) === QSH.Hyprland.focusedMonitor
    placeholderText: "Rechercher dans le presse-papier..."
    emptyText: "Presse-papier vide"

    model: QS.ScriptModel {
        values: Clipboard.entries.filter(root._matchesSearch)
    }

    delegate: Component {
        ClipItem {}
    }

    onCloseRequested: Clipboard.close()
    onSearchUpdated: text => Clipboard.searchText = text
    onItemActivated: data => Clipboard.select(data)

    function _matchesSearch(line: string): bool {
        if (Clipboard.searchText === "")
            return true;

        const tabIdx = line.indexOf('\t');
        const content = tabIdx >= 0 ? line.substring(tabIdx + 1) : line;
        return content.toLowerCase().includes(Clipboard.searchText.toLowerCase());
    }
}
