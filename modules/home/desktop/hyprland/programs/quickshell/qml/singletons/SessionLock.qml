pragma Singleton

import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Pam
import Quickshell.Wayland as QSW

Singleton {
    id: root

    property var _wlLock: QSW.WlSessionLock {
        id: wlLock

        QSW.WlSessionLockSurface {
            id: surface

            property bool _unlockInProgress: false
            property bool _authError: false
            property string _password: ""

            color: Colors.base00

            PamContext {
                id: _pam
                configDirectory: "/etc/pam.d"
                config: "login"

                onPamMessage: if (responseRequired) respond(surface._password)

                onCompleted: function(result) {
                    surface._unlockInProgress = false
                    if (result === PamResult.Success) {
                        wlLock.locked = false
                    } else {
                        surface._authError = true
                        _passwordField.text = ""
                        _passwordField.forceActiveFocus()
                    }
                }
            }

            Image {
                anchors.fill: parent
                source: Variables.wallpaper !== "" ? "file://" + Variables.wallpaper : ""
                fillMode: Image.PreserveAspectCrop
                visible: Variables.wallpaper !== ""

                layer.enabled: true
                layer.effect: MultiEffect {
                    blurEnabled: true
                    blur: 1.0
                    blurMax: 64
                }
            }

            Rectangle {
                anchors.fill: parent
                color: Colors.withOpacity(Colors.base00, 0.4)
            }

            Text {
                id: _time
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -300
                text: Qt.formatTime(new Date(), "HH:mm")
                color: Colors.base05
                font.family: Fonts.sansSerif
                font.pixelSize: 120
                font.weight: Font.Light
            }

            Text {
                id: _date
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -200
                text: Qt.formatDate(new Date(), "dddd dd MMMM")
                color: Colors.base05
                font.family: Fonts.sansSerif
                font.pixelSize: 32
            }

            Timer {
                interval: 1000
                running: wlLock.locked
                repeat: true
                onTriggered: {
                    _time.text = Qt.formatTime(new Date(), "HH:mm")
                    _date.text = Qt.formatDate(new Date(), "dddd dd MMMM")
                }
            }

            Rectangle {
                id: _passwordRect
                width: 400
                height: 44
                anchors.centerIn: parent
                radius: Variables.windowRadius
                color: Colors.withOpacity(Colors.base01, 0.8)
                border.color: surface._authError ? Colors.base08 : Colors.base03
                border.width: Variables.windowBorder

                TextInput {
                    id: _passwordField
                    anchors {
                        fill: parent
                        margins: 12
                    }
                    echoMode: TextInput.Password
                    enabled: !surface._unlockInProgress
                    color: Colors.base05
                    font.family: Fonts.sansSerif
                    font.pixelSize: 16
                    verticalAlignment: TextInput.AlignVCenter

                    onTextChanged: {
                        surface._password = text
                        if (text.length > 0) surface._authError = false
                    }

                    Keys.onReturnPressed: {
                        if (text.length > 0 && !surface._unlockInProgress) {
                            surface._unlockInProgress = true
                            _pam.start()
                        }
                    }
                }
            }

            Text {
                anchors.top: _passwordRect.bottom
                anchors.topMargin: Variables.windowGap
                anchors.horizontalCenter: parent.horizontalCenter
                visible: surface._authError
                text: "Mot de passe incorrect"
                color: Colors.base08
                font.family: Fonts.sansSerif
                font.pixelSize: 14
            }

            onVisibleChanged: if (visible) {
                _password = ""
                _authError = false
                _unlockInProgress = false
                _passwordField.text = ""
                _passwordField.forceActiveFocus()
            }
        }
    }

    function lock() {
        wlLock.locked = true
    }
}
