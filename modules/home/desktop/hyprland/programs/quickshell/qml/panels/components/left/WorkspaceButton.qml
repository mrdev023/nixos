import QtQuick
import Quickshell.Hyprland as QSH

import "../../../components"
import "../../../singletons"

Rectangle {
    id: root
    property QSH.HyprlandWorkspace workspace

    radius: Variables.windowRadius / 2
    width: root.height + Variables.windowGap
    opacity: hover.hovered ? 0.7 : 1.0
    color: _backgroundColor()

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
        anchors.centerIn: root
        variant: DesktopText.Variant.Subtitle
        color: _textColor()
    }

    function _textColor() {
        if (workspace.urgent)
            return Colors.base00;
        if (workspace.active || workspace.focused)
            return Colors.base04;
        return Colors.base03;
    }

    function _backgroundColor() {
        if (workspace.urgent)
            return Colors.base08;
        if (workspace.active || workspace.focused)
            return Colors.base01;
        return Colors.base00;
    }
}
