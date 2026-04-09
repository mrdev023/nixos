import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts as QQL
import Quickshell.Services.Notifications as QSN

import "../../../components"
import "../../../singletons"

Panel {
    id: root

    required property QSN.Notification notification

    readonly property string _urgencyIcon: {
        switch (root.notification.urgency) {
        case QSN.NotificationUrgency.Low:
            return "";
        case QSN.NotificationUrgency.Critical:
            return "󰵙";
        default:
            return "󰂞";
        }
    }

    readonly property color _urgencyColor: {
        switch (root.notification.urgency) {
        case QSN.NotificationUrgency.Low:
            return Colors.base03;
        case QSN.NotificationUrgency.Critical:
            return Colors.base08;
        default:
            return Colors.base0D;
        }
    }

    readonly property int _urgencyTimeout: {
        switch (root.notification.urgency) {
        case QSN.NotificationUrgency.Low:
            return 8000;
        case QSN.NotificationUrgency.Critical:
            return 0;
        default:
            return 10000;
        }
    }

    readonly property int _timeout: {
        if (root.notification.expireTimeout > 0)
            return root.notification.expireTimeout;
        if (root.notification.transient && root._urgencyTimeout === 0)
            return 10000;
        return root._urgencyTimeout;
    }

    property Timer _dismissTimer: Timer {
        interval: root._timeout
        repeat: false
        running: root._timeout > 0
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
        spacing: Variables.windowGap

        // Ligne AppIcon + AppName (fillWidth) + CloseIcon
        QQL.RowLayout {
            QQL.Layout.fillWidth: true
            spacing: Variables.windowGap / 2

            QQL.RowLayout {
                QQL.Layout.fillWidth: true
                spacing: Variables.windowGap
                DesktopIcon {
                    id: _appIcon
                    iconSource: "image://icon/" + root.notification.appIcon
                    width: height
                    height: appName.height
                }

                DesktopText {
                    id: appName
                    QQL.Layout.fillWidth: true
                    text: root.notification.appName
                    variant: DesktopText.Variant.Subtext
                    elide: Text.ElideRight
                }
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

        QQL.RowLayout {
            QQL.Layout.fillWidth: true
            spacing: Variables.windowGap

            DesktopText {
                visible: root._urgencyIcon !== ""
                text: root._urgencyIcon
                variant: DesktopText.Bigtext
                color: root._urgencyColor
            }

            DesktopText {
                QQL.Layout.fillWidth: true
                text: root.notification.summary
                variant: DesktopText.Variant.Subtitle
                color: root._urgencyColor
                wrapMode: Text.WordWrap
            }
        }

        DesktopText {
            QQL.Layout.fillWidth: true
            visible: root.notification.body !== ""
            text: root.notification.body
            variant: DesktopText.Variant.Text
            wrapMode: Text.WordWrap
        }

        DesktopProgressBar {
            QQL.Layout.fillWidth: true

            visible: root.notification.hints["value"] !== undefined
            value: (root.notification.hints["value"] ?? 0) / 100
        }

        QQL.RowLayout {
            id: actionsRow
            QQL.Layout.fillWidth: true
            QQL.Layout.topMargin: Variables.windowGap
            property list<QSN.NotificationAction> actions: root.notification.actions.filter(actionIsValid)

            visible: actions.length > 0
            spacing: Variables.windowGap

            Repeater {
                model: actionsRow.actions
                delegate: DesktopButton {
                    required property QSN.NotificationAction modelData
                    buttonText: modelData.text
                    onClicked: modelData.invoke()
                }
            }

            function actionIsValid(action: QSN.NotificationAction): bool {
                return action.identifier !== "default" && action.identifier !== "inline-reply" && action.text !== "";
            }
        }

        QQL.FlexboxLayout {
            id: replyRow
            QQL.Layout.fillWidth: true
            QQL.Layout.topMargin: Variables.windowGap
            visible: root.notification.hasInlineReply
            gap: Variables.windowGap
            direction: _replyField.lineCount > 1 ? QQL.FlexboxLayout.Column : QQL.FlexboxLayout.Row
            readonly property bool isColumn: direction === QQL.FlexboxLayout.Column

            function sendReply(): void {
                root.notification.sendInlineReply(_replyField.text);
            }

            DesktopTextArea {
                id: _replyField
                QQL.Layout.fillWidth: true
                placeholderText: root.notification.inlineReplyPlaceholder ?? ""
                wrapMode: QQC.TextArea.Wrap

                Keys.onPressed: {
                    _dismissTimer.restart();
                    _timeoutAnim.restart();
                }
                Keys.onReturnPressed: event => {
                    if (event.modifiers & Qt.ShiftModifier) {
                        replyRow.sendReply();
                    } else {
                        event.accepted = false;
                    }
                }
            }

            DesktopButton {
                QQL.Layout.fillHeight: !replyRow.isColumn
                QQL.Layout.fillWidth: replyRow.isColumn
                horizontalAlignment: replyRow.isColumn ? Text.AlignHCenter : Text.AlignLeft
                topPadding: replyRow.isColumn ? Variables.windowGap : 0
                bottomPadding: replyRow.isColumn ? Variables.windowGap : 0
                buttonText: ""
                onClicked: replyRow.sendReply()
            }
        }

        DesktopProgressBar {
            id: _timeoutBar
            QQL.Layout.fillWidth: true
            QQL.Layout.topMargin: Variables.windowGap
            visible: root._timeout > 0
            variant: DesktopProgressBar.Secondary
            fillColor: root._urgencyColor
            value: 1.0

            Component.onCompleted: _timeoutAnim.start()

            NumberAnimation {
                id: _timeoutAnim
                target: _timeoutBar
                property: "value"
                from: 1.0
                to: 0.0
                duration: root._timeout
            }
        }
    }
}
