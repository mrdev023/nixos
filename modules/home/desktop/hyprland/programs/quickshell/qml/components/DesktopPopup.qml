import QtQuick
import QtQuick.Layouts as QQL
import Quickshell as QS

import "../singletons"

QS.PopupWindow {
    id: root
    color: "transparent"
    // Variables.windowGap * 2 -> Keep spaces for Shadow
    implicitWidth: _container.implicitWidth + Variables.windowGap * 2
    implicitHeight: _container.implicitHeight + Variables.windowGap * 2
    visible: _container.opacity > 0
    property bool opened
    default property alias content: _content.children
    property alias spacing: _content.spacing

    anchor {
        window: topBar // Top parent bar
        edges: QS.Edges.Top | QS.Edges.Right
        gravity: QS.Edges.Bottom | QS.Edges.Left
        rect {
            x: topBar.width
            y: topBar.height
        }
        margins {
            top: Variables.windowGap
            right: Variables.windowGap
        }
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
