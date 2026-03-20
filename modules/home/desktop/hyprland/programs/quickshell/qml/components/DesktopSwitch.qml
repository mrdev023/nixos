import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts as QQL

import "../singletons"

QQC.Switch {
    id: root
    spacing: 0
    QQL.Layout.margins: 0

    indicator: Rectangle {
        width: _toggle.width * 3
        height: _toggle.height * 1.5
        radius: Variables.windowRadius / 2
        anchors.verticalCenter: parent.verticalCenter

        color: root.checked ? Colors.base0B : Colors.base01
        border.color: root.checked ? Colors.base03 : Colors.base02
        border.width: 2

        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
        Behavior on border.color {
            ColorAnimation {
                duration: 200
            }
        }

        Rectangle {
            id: _toggle
            width: Fonts.ptToPx(Fonts.desktopSize, topBar.screen) / 1.25
            height: width
            radius: Variables.windowRadius / 2
            anchors.verticalCenter: parent.verticalCenter
            x: root.checked ? parent.width - width - 3 : 3
            color: Colors.base05

            Behavior on x {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
}
