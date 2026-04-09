import QtQuick
import Quickshell.Services.SystemTray as QSSST

import "../../../components"
import "../../../singletons"

DesktopIcon {
    id: root

    property QSSST.SystemTrayItem trayItem

    iconSource: trayItem.icon
    height: Fonts.ptToPx(Fonts.desktopSize, topBar.screen)

    TrayMenuPopup {
        id: menuPopup
        trayItem: root.trayItem
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton) {
                if (root.trayItem.hasMenu)
                    menuPopup.opened = true
            } else {
                root.trayItem.activate()
            }
        }
    }
}
