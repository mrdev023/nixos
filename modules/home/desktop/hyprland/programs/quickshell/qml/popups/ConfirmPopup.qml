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
        visible = true;
    }

    function close(): void {
        visible = false;
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

                DesktopButton {
                    buttonText: "Non"

                    onClicked: {
                        root.close();
                        root.cancelled();
                    }
                }

                DesktopButton {
                    buttonText: "Oui"

                    onClicked: {
                        root.close();
                        root.confirmed();
                    }
                }
            }
        }
    }
}
