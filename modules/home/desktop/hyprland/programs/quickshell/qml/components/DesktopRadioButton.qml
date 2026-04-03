import QtQuick
import QtQuick.Layouts as QQL

import "../singletons"

QQL.RowLayout {
    id: root

    property string text
    property bool selected: false
    signal clicked()

    spacing: Variables.windowGap

    Rectangle {
        width: _dot.width + 6
        height: width
        radius: width / 2
        color: root.selected ? Colors.base0D : "transparent"
        border.color: root.selected ? Colors.base0D : Colors.base02
        border.width: 2

        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on border.color { ColorAnimation { duration: 150 } }

        Rectangle {
            id: _dot
            anchors.centerIn: parent
            width: Fonts.ptToPx(Fonts.desktopSize, topBar.screen) / 1.5
            height: width
            radius: width / 2
            color: Colors.base05
            visible: root.selected
            opacity: root.selected ? 1.0 : 0.0

            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
    }

    DesktopText {
        QQL.Layout.fillWidth: true
        text: root.text
        color: root.selected ? Colors.base05 : Colors.base03

        Behavior on color { ColorAnimation { duration: 150 } }
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        onTapped: root.clicked()
    }
}
