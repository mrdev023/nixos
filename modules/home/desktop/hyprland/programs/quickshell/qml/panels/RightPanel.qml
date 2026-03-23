import QtQuick
import Quickshell.Services.SystemTray as QSSST

import "../components"
import "../singletons"

Panel {
    implicitWidth: tray.implicitWidth + Variables.windowGap * 2

    Row {
        id: tray
        spacing: Variables.windowGap

        Repeater {
            model: QSSST.SystemTray.items

            delegate: Image {
                source: modelData.icon

                width: Fonts.ptToPx(Fonts.desktopSize, topBar.screen)
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter

                TapHandler {
                    onTapped: modelData.activate()
                }
            }
        }
    }
}
