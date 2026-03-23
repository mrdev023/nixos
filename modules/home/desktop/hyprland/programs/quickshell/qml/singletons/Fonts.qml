pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string _fontsFile: `${Quickshell.env("XDG_CONFIG_HOME") || Quickshell.env("HOME") + "/.config"}/quickshell/fonts.json`

    property var _data: ({})

    property var _file: FileView {
        path: root._fontsFile
        onLoaded: root._data = JSON.parse(text())
    }

    function _get(key) {
        return _data[key] ?? ""
    }

    // pt → px : 1pt = 1/72 inch = 25.4/72 mm
    function ptToPx(pt, screen) {
        return pt * screen.logicalPixelDensity * 25.4 / 72
    }

    readonly property string emoji:     _get("emoji")
    readonly property string monospace: _get("monospace")
    readonly property string sansSerif: _get("sansSerif")
    readonly property string serif:     _get("serif")

    readonly property int appSize:      _data.sizes?.applications ?? 12
    readonly property int desktopSize:  _data.sizes?.desktop      ?? 14
    readonly property int popupSize:    _data.sizes?.popups        ?? 10
    readonly property int terminalSize: _data.sizes?.terminal      ?? 12
}
