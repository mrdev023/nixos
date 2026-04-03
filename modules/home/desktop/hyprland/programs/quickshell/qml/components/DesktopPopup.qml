import QtQuick
import QtQuick.Layouts as QQL
import Quickshell as QS
import Quickshell.Hyprland as QSH

import "../singletons"

QS.PopupWindow {
    id: root

    enum Position {
        TopLeft,
        TopCenter,
        TopRight,
        Center
    }

    property int position: DesktopPopup.Position.TopRight
    property bool opened
    // When true, pointer/scroll events pass through to windows below (no focus capture)
    property bool passthrough: false
    default property alias content: _content.data
    property alias spacing: _content.spacing

    signal focusLost()
    onFocusLost: opened = false

    mask: passthrough ? _passthroughMask : null

    color: "transparent"
    implicitWidth: _container.implicitWidth + Variables.windowGap * 2
    implicitHeight: _container.implicitHeight + Variables.windowGap * 2
    visible: root.opened || _container.opacity > 0

    anchor {
        window: topBar
        edges: {
            switch (root.position) {
            case DesktopPopup.Position.TopLeft:   return QS.Edges.Top | QS.Edges.Left;
            case DesktopPopup.Position.TopCenter: return QS.Edges.Top | QS.Edges.Right;
            case DesktopPopup.Position.TopRight:  return QS.Edges.Top | QS.Edges.Right;
            default:                              return QS.Edges.Top | QS.Edges.Left;
            }
        }
        gravity: {
            switch (root.position) {
            case DesktopPopup.Position.TopLeft:   return QS.Edges.Bottom | QS.Edges.Right;
            case DesktopPopup.Position.TopCenter: return QS.Edges.Bottom | QS.Edges.Left;
            case DesktopPopup.Position.TopRight:  return QS.Edges.Bottom | QS.Edges.Left;
            default:                              return QS.Edges.Bottom | QS.Edges.Right;
            }
        }
        rect {
            x: {
                switch (root.position) {
                case DesktopPopup.Position.TopLeft:   return 0;
                case DesktopPopup.Position.TopCenter: return topBar.width / 2 + root.width / 2;
                case DesktopPopup.Position.TopRight:  return topBar.width;
                default:                              return topBar.width / 2 - root.width / 2;
                }
            }
            y: root.position === DesktopPopup.Position.Center
                ? topBar.screen.height / 2 - root.height / 2
                : topBar.height
        }
        margins {
            top: root.position === DesktopPopup.Position.Center ? 0 : Variables.windowGap
            right: root.position === DesktopPopup.Position.TopRight ? Variables.windowGap : 0
            left: root.position === DesktopPopup.Position.TopLeft ? Variables.windowGap : 0
        }
    }

    QS.Region {
        id: _passthroughMask
    }

    QSH.HyprlandFocusGrab {
        windows: [root]
        active: root.opened && !root.passthrough
        onCleared: root.focusLost()
    }

    Panel {
        id: _container
        opacity: root.opened ? 1.0 : 0.0
        anchors.centerIn: parent
        implicitWidth: _content.implicitWidth + Variables.windowGap * 4
        implicitHeight: _content.implicitHeight + Variables.windowGap * 4

        Behavior on opacity {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        QQL.ColumnLayout {
            id: _content
            anchors.centerIn: parent
        }
    }
}
