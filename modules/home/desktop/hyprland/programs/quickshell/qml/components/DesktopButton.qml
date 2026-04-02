import QtQuick
import QtQuick.Controls as QQC

import "../singletons"

QQC.Button {
    property alias buttonText: desktopText.text
    leftPadding: Variables.windowGap * 1.5
    rightPadding: leftPadding

    background: Rectangle {
        color: hover.hovered ? Colors.base0E : Colors.base0D
        radius: Variables.windowRadius / 2

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }

    contentItem: DesktopText {
        id: desktopText
        color: Colors.base00
    }

    HoverHandler {
        id: hover
        cursorShape: Qt.PointingHandCursor
    }
}
