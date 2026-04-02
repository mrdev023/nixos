import QtQuick
import QtQuick.Layouts as QQL
import Quickshell.Services.Notifications as QSN

import "../../../components"
import "../../../singletons"

Panel {
    id: root

    required property QSN.Notification notification

    property Timer _dismissTimer: Timer {
        interval: root.notification.expireTimeout > 0 ? root.notification.expireTimeout : 5000
        repeat: false
        running: true
        onTriggered: root.notification.expire()
    }

    implicitWidth: 300 + Variables.windowGap * 4
    implicitHeight: _layout.implicitHeight + Variables.windowGap * 4
    opacity: 0.0

    Component.onCompleted: opacity = 1.0

    Behavior on opacity {
        NumberAnimation {
            duration: 250
            easing.type: Easing.OutCubic
        }
    }

    QQL.ColumnLayout {
        id: _layout
        width: 300
        anchors.centerIn: parent
        spacing: Variables.windowGap / 2

        QQL.RowLayout {
            QQL.Layout.fillWidth: true
            spacing: Variables.windowGap / 2

            DesktopText {
                QQL.Layout.fillWidth: true
                text: root.notification.appName
                variant: DesktopText.Variant.Subtext
                elide: Text.ElideRight
            }

            DesktopText {
                text: ""
                variant: DesktopText.Bigtext
                color: Colors.base08
                opacity: _closeHover.hovered ? 0.7 : 1.0

                TapHandler {
                    onTapped: root.notification.dismiss()
                }

                HoverHandler {
                    id: _closeHover
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }

        DesktopText {
            QQL.Layout.fillWidth: true
            text: root.notification.summary
            variant: DesktopText.Variant.Subtitle
            wrapMode: Text.WordWrap
        }

        DesktopText {
            QQL.Layout.fillWidth: true
            visible: root.notification.body !== ""
            text: root.notification.body
            variant: DesktopText.Variant.Text
            wrapMode: Text.WordWrap
        }

        QQL.RowLayout {
            QQL.Layout.fillWidth: true
            visible: root.notification.actions.length > 0
            spacing: Variables.windowGap / 2

            Repeater {
                model: root.notification.actions
                delegate: DesktopButton {
                    required property QSN.NotificationAction modelData
                    buttonText: modelData.text
                    onClicked: modelData.invoke()
                }
            }
        }
    }
}
