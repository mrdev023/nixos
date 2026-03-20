import QtQuick
import QtQuick.Controls as QQC

import "../singletons"

QQC.Button {
    property alias buttonText: desktopText.text
    leftPadding: Variables.windowGap * 1.5
    rightPadding: leftPadding

    opacity: hover.hovered ? 0.7 : 1.0

    background: Rectangle {
        color: Colors.base0B
        radius: Variables.windowRadius / 2
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
