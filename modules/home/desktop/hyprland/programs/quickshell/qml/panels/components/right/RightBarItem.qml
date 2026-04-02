import QtQuick

import "../../../components"
import "../../../singletons"

Item {
    id: root

    property alias iconText: _icon.text
    signal tapped()
    signal middleTapped()
    signal wheeled(real delta)

    implicitWidth: _icon.implicitWidth
    implicitHeight: _icon.implicitHeight

    DesktopText {
        id: _icon
        variant: DesktopText.Bigtext
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton)
                root.tapped()
            else if (mouse.button === Qt.MiddleButton)
                root.middleTapped()
        }
        onWheel: event => root.wheeled(event.angleDelta.y)
    }
}
