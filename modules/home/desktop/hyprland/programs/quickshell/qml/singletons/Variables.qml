pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string _variablesFile: `${Quickshell.env("XDG_CONFIG_HOME") || Quickshell.env("HOME") + "/.config"}/quickshell/variables.json`

    property var _data: ({})

    property var _file: FileView {
        path: root._variablesFile
        onLoaded: root._data = JSON.parse(text())
    }

    readonly property int topBarGap:      _data.topBar?.gap            ?? 16
    readonly property int topBarHeight:   _data.topBar?.height         ?? 32

    readonly property int windowRadius:   _data.window?.border?.radius ?? 10
    readonly property int windowBorder:   _data.window?.border?.size   ?? 3
    readonly property int windowGap:      _data.window?.gap            ?? 10

    readonly property string wallpaper:   _data.wallpaper              ?? ""
}
