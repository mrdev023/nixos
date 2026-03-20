import QtQuick
import QtQuick.Controls as QQC

import "../singletons"

QQC.ProgressBar {
    width: 150
    height: Variables.windowGap
    background: Rectangle {
        radius: Variables.windowRadius / 2
        color: Colors.base01
    }

    contentItem: Rectangle {
        radius: Variables.windowRadius / 2
        color: Colors.base0B
        width: parent.visualPosition * parent.width
        height: parent.height

        Behavior on width {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }
        }
    }
}
