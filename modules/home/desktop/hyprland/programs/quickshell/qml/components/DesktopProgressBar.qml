import QtQuick
import QtQuick.Controls as QQC

import "../singletons"

QQC.ProgressBar {
    id: root

    enum Variant {
        Default,
        Secondary
    }

    property int variant: DesktopProgressBar.Default
    property color fillColor: Colors.base05

    width: 150
    height: variant === DesktopProgressBar.Secondary
        ? Variables.windowGap / 2
        : Variables.windowGap

    background: Rectangle {
        radius: Variables.windowRadius / 2
        color: root.variant === DesktopProgressBar.Secondary
            ? "transparent"
            : Colors.base01
    }

    contentItem: Rectangle {
        radius: Variables.windowRadius / 2
        color: root.fillColor
        width: parent.visualPosition * parent.width
        height: parent.height

        Behavior on width {
            enabled: root.variant === DesktopProgressBar.Default
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }
        }
    }
}
