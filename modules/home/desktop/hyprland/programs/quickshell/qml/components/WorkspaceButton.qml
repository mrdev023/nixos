import QtQuick
import Quickshell.Hyprland as QSH

import "../singletons"

Rectangle {
    property QSH.HyprlandWorkspace workspace
    
    radius: Variables.windowRadius / 2
    implicitWidth: text.implicitWidth + Variables.windowGap * 2
    implicitHeight: text.implicitHeight + Variables.windowGap / 2
    color: _applyColor(Colors.base00, Colors.base01, Colors.base01, Colors.base08, Colors.withOpacity(Colors.base02, 0.4))

    Behavior on opacity {
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }

    HoverHandler {
        id: hover
    }

    TapHandler {
        onTapped: workspace.activate()
    }

    DesktopText {
        id: text
        text: workspace.name
        anchors.centerIn: parent
        innerPadding: Variables.topBarGap / 4
        font.bold: true
        color: _applyColor(Colors.base03, Colors.base04, Colors.base04, Colors.base00, Colors.base05)
    }

    function _applyColor(normal, active, focused, urgent, hovered) {
        if (hover.hovered)     return hovered
        if (workspace.urgent)  return urgent
        if (workspace.focused) return focused
        if (workspace.active)  return active
        return normal
    }
}
