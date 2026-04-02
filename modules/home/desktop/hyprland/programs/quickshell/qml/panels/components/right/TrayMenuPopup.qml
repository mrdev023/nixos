import QtQuick
import QtQuick.Layouts as QQL
import Quickshell as QS

import "../../../components"
import "../../../singletons"

DesktopPopup {
    id: root

    required property var trayItem

    position: DesktopPopup.Position.TopRight

    QS.QsMenuOpener {
        id: menuOpener
        menu: root.trayItem.menu ?? null
    }

    Repeater {
        model: menuOpener.children

        delegate: Item {
            required property var modelData

            QQL.Layout.fillWidth: true
            implicitWidth: _label.implicitWidth + Variables.windowGap * 3
            implicitHeight: modelData.isSeparator
                ? 1 + Variables.windowGap
                : _label.implicitHeight + Variables.windowGap

            Rectangle {
                visible: modelData.isSeparator
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                height: 1
                color: Colors.base03
            }

            Rectangle {
                visible: !modelData.isSeparator
                anchors.fill: parent
                radius: Variables.windowRadius / 2
                color: _hover.hovered && modelData.enabled ? Colors.base01 : "transparent"
                Behavior on color { ColorAnimation { duration: 100 } }
            }

            DesktopText {
                id: _label
                visible: !modelData.isSeparator
                anchors.centerIn: parent
                text: modelData.text
                opacity: modelData.enabled ? 1.0 : 0.4
            }

            HoverHandler {
                id: _hover
                cursorShape: modelData.enabled && !modelData.isSeparator
                    ? Qt.PointingHandCursor
                    : Qt.ArrowCursor
            }

            TapHandler {
                enabled: modelData.enabled && !modelData.isSeparator
                onTapped: {
                    modelData.triggered()
                    root.opened = false
                }
            }
        }
    }
}
