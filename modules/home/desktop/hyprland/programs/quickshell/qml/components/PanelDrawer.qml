import QtQuick
import QtQuick.Layouts as QQL
import Quickshell as QS

import "../singletons"

QS.PopupWindow {
    id: root
    color: "transparent"
    // If is completely hidden, switch to not visible
    // to avoid block event on others PanelDrawer
    // WARN: Binding loop detected for property "visible"
    //   root.width dépend de implicitWidth → _container.implicitWidth
    //   → qui peut changer quand visible change → qui recalcule _slideOffset
    //   → qui recalcule visible
    visible: _slideOffset < root.width

    implicitWidth: _container.implicitWidth
    implicitHeight: _container.implicitHeight

    property bool opened
    property real _slideOffset: opened ? 0 : root.width

    default property alias content: _content.children
    property alias spacing: _content.spacing

    Behavior on _slideOffset {
        NumberAnimation {
            duration: 250
            easing.type: Easing.OutCubic
        }
    }

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

    Rectangle {
        id: _container
        color: Colors.base00
        radius: Variables.windowRadius
        implicitWidth: _content.implicitWidth + Variables.windowGap * 4
        implicitHeight: _content.implicitHeight + Variables.windowGap * 4

        transform: Translate {
            x: root._slideOffset
        }

        border {
            width: Variables.windowBorder
            color: Colors.base0D
        }

        QQL.ColumnLayout {
            id: _content
            anchors.centerIn: parent
        }
    }
}
