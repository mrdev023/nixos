import QtQuick
import QtQuick.Layouts as QQL
import Quickshell as QS

import "../components"
import "./components/notification"
import "../singletons"

QS.PopupWindow {
    id: root

    color: "transparent"
    visible: Notifications.trackedNotifications.values.length > 0

    anchor {
        window: topBar
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

    implicitWidth: _column.implicitWidth + Variables.windowGap * 2
    implicitHeight: _column.implicitHeight + Variables.windowGap * 2

    QQL.ColumnLayout {
        id: _column
        anchors.centerIn: parent
        spacing: Variables.windowGap

        Repeater {
            model: Notifications.trackedNotifications
            delegate: NotificationItem {
                required property var modelData
                notification: modelData
            }
        }
    }
}
