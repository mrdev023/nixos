pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string _colorsFile: `${Quickshell.env("XDG_CONFIG_HOME") || Quickshell.env("HOME") + "/.config"}/quickshell/colors.json`

    property var _data: ({})

    property var _file: FileView {
        path: root._colorsFile
        onLoaded: root._data = JSON.parse(text())
    }

    function _mapColor(key) {
        let data = _data[key] ? `#${_data[key]}` : "#FF0000"
        return Qt.color(data)
    }

    function withOpacity(color, opacity) {
        return Qt.rgba(color.r, color.g, color.b, opacity)
    }

    readonly property color base00: _mapColor("base00")
    readonly property color base01: _mapColor("base01")
    readonly property color base02: _mapColor("base02")
    readonly property color base03: _mapColor("base03")
    readonly property color base04: _mapColor("base04")
    readonly property color base05: _mapColor("base05")
    readonly property color base06: _mapColor("base06")
    readonly property color base07: _mapColor("base07")
    readonly property color base08: _mapColor("base08")
    readonly property color base09: _mapColor("base09")
    readonly property color base0A: _mapColor("base0A")
    readonly property color base0B: _mapColor("base0B")
    readonly property color base0C: _mapColor("base0C")
    readonly property color base0D: _mapColor("base0D")
    readonly property color base0E: _mapColor("base0E")
    readonly property color base0F: _mapColor("base0F")
}
