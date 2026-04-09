import QtQuick
import QtQuick.Controls as QQC

import "../singletons"

QQC.TextArea {
    id: root

    color: Colors.base05
    placeholderTextColor: Colors.base03
    selectionColor: Colors.base0D
    leftPadding: Variables.windowGap
    rightPadding: Variables.windowGap
    topPadding: Variables.windowGap / 2
    bottomPadding: Variables.windowGap / 2

    font {
        family: Fonts.monospace
        pixelSize: Fonts.ptToPx(Fonts.desktopSize, topBar.screen) - 4
    }

    background: Rectangle {
        color: Colors.base01
        radius: Variables.windowRadius / 2
    }
}
