import QtQuick
import QtQuick.Controls
import Quickshell as QS

import "../components"
import "../singletons"

QS.FloatingWindow {
    id: root

    title: "Confirmation"
    property string message

    signal confirmed
    signal cancelled

    minimumSize: Qt.size(300, 150)
    visible: false

    function open(): void {
        visible = true
    }

    function close(): void {
        visible = false
    }

    component ActionButton: Button {
        property string buttonText

        background: Rectangle {
            color: hover.hovered
                ? Colors.base01
                : Colors.withOpacity(Colors.base02, 0.4)
            radius: Variables.windowRadius / 2
        }

        contentItem: DesktopText {
            text: buttonText
            color: hover.hovered
                ? Colors.base04
                : Colors.base05
        }

        HoverHandler {
            id: hover
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Colors.base00

        Column {
            anchors.centerIn: parent
            spacing: 16

            DesktopText {
                text: root.message
                color: Colors.base05
                font.pixelSize: 15
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                spacing: 12
                anchors.horizontalCenter: parent.horizontalCenter

                ActionButton {
                    buttonText: "Non"
                    
                    onClicked: {
                        root.close()
                        root.cancelled()
                    }
                }

                ActionButton {
                    buttonText: "Oui"

                    onClicked: {
                        root.close()
                        root.confirmed()
                    }
                }
            }
        }
    }
}
