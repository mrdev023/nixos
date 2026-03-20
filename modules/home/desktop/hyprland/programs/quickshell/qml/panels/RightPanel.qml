import QtQuick
import Quickshell.Services.SystemTray as QSSST

import "../components"
import "./components/right"
import "../singletons"

Panel {
    implicitWidth: tray.implicitWidth + Variables.windowGap * 4

    Row {
        id: tray
        spacing: Variables.windowGap
        anchors.horizontalCenter: parent.horizontalCenter

        PowerProfile {}
        Audio {
            kind: Audio.Sink
        }
        Audio {
            kind: Audio.Source
        }
        Bluetooth {}

        Repeater {
            model: QSSST.SystemTray.items

            delegate: TrayItem {
                required property var modelData
                trayItem: modelData
                anchors.verticalCenter: tray.verticalCenter
            }
        }

        Power {}
    }
}
