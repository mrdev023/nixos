import QtQuick
import QtQuick.Controls as QQC

import "../singletons"

QQC.Button {
    property alias buttonText: desktopText.text
    leftPadding: Variables.windowGap * 1.5
    rightPadding: leftPadding

    background: Rectangle {
        color: hover.hovered ? Colors.base01 : Colors.withOpacity(Colors.base02, 0.4)
        radius: Variables.windowRadius / 2
    }

    contentItem: DesktopText {
        id: desktopText
        color: hover.hovered ? Colors.base04 : Colors.base05
    }

    HoverHandler {
        id: hover
        cursorShape: Qt.PointingHandCursor
    }
}
