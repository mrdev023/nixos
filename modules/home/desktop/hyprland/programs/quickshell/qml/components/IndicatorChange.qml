import QtQuick
import QtQuick.Layouts as QQL

import "../components"
import "../singletons"

DesktopPopup {
    id: root

    implicitWidth: _container.implicitWidth
    implicitHeight: _container.implicitHeight

    visible: _container.opacity > 0
    property bool opened

    default property alias content: _content.children
    property alias spacing: _content.spacing

    Panel {
        id: _container
        opacity: root.opened ? 1.0 : 0.0

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
