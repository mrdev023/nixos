import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts as QQL
import Quickshell as QS
import Quickshell.Hyprland as QSH

import "../../components"
import "../../singletons"

QS.PopupWindow {
    id: root

    property bool pickerOpened: false
    property string placeholderText: ""
    property string emptyText: ""
    property alias model: _list.model
    property Component delegate

    signal closeRequested()
    signal searchUpdated(string text)
    signal itemActivated(var modelData)

    color: "transparent"
    implicitWidth: 500
    implicitHeight: 450
    visible: pickerOpened || _container.opacity > 0

    anchor {
        window: topBar
        rect {
            x: topBar.width / 2 - root.width / 2
            y: topBar.screen.height / 2 - root.height / 2
        }
    }

    onVisibleChanged: if (!visible) closeRequested()

    QSH.HyprlandFocusGrab {
        id: _grab
        windows: [root]
        active: root.pickerOpened
        onCleared: root.closeRequested()
    }

    Panel {
        id: _container

        anchors {
            fill: parent
            margins: Variables.windowGap
        }
        opacity: root.pickerOpened ? 1.0 : 0.0

        Behavior on opacity {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        QQL.ColumnLayout {
            anchors.fill: parent
            spacing: Variables.windowGap

            QQC.TextField {
                id: _search

                QQL.Layout.fillWidth: true
                placeholderText: root.placeholderText
                color: Colors.base05
                placeholderTextColor: Colors.base03
                selectionColor: Colors.base0D
                leftPadding: Variables.windowGap
                rightPadding: Variables.windowGap
                topPadding: Variables.windowGap / 2
                bottomPadding: Variables.windowGap / 2

                font {
                    family: Fonts.monospace
                    pixelSize: Fonts.ptToPx(Fonts.desktopSize, topBar.screen)
                }

                background: Rectangle {
                    color: Colors.base01
                    radius: Variables.windowRadius / 2
                }

                onTextChanged: root.searchUpdated(text)

                Keys.onEscapePressed: root.closeRequested()
                Keys.onDownPressed: {
                    if (_list.count > 0) {
                        _list.incrementCurrentIndex();
                        _list.forceActiveFocus();
                    }
                }
                Keys.onReturnPressed: {
                    if (_list.count > 0)
                        root.itemActivated(_list.currentItem.modelData);
                }
                Keys.onPressed: event => {
                    if (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_J) {
                        if (_list.count > 0) {
                            _list.incrementCurrentIndex();
                            _list.forceActiveFocus();
                        }
                        event.accepted = true;
                    }
                }
            }

            Item {
                QQL.Layout.fillWidth: true
                QQL.Layout.fillHeight: true

                ListView {
                    id: _list

                    anchors.fill: parent
                    clip: true
                    spacing: Variables.windowGap / 2
                    highlightMoveDuration: 100
                    currentIndex: -1
                    visible: count > 0

                    onCountChanged: currentIndex = count > 0 ? 0 : -1

                    highlight: Rectangle {
                        color: Colors.base01
                        radius: Variables.windowRadius / 2
                        opacity: 0.7
                    }

                    delegate: root.delegate

                    Keys.onEscapePressed: root.closeRequested()
                    Keys.onReturnPressed: {
                        if (currentItem)
                            root.itemActivated(currentItem.modelData);
                    }
                    Keys.onUpPressed: {
                        if (currentIndex <= 0) {
                            currentIndex = -1;
                            _search.forceActiveFocus();
                        } else {
                            decrementCurrentIndex();
                        }
                    }
                    Keys.onPressed: event => {
                        // Vim-like navigation: Ctrl+J = down, Ctrl+K = up
                        if (event.modifiers & Qt.ControlModifier) {
                            // Move to next item
                            if (event.key === Qt.Key_J) {
                                incrementCurrentIndex();
                                event.accepted = true;
                            // Move to previous item, or back to search field if at top
                            } else if (event.key === Qt.Key_K) {
                                if (currentIndex <= 0) {
                                    currentIndex = -1;
                                    _search.forceActiveFocus();
                                } else {
                                    decrementCurrentIndex();
                                }
                                event.accepted = true;
                            }
                        // Backspace: delete last char and refocus search
                        } else if (event.key === Qt.Key_Backspace) {
                            _search.text = _search.text.slice(0, -1);
                            _search.forceActiveFocus();
                            event.accepted = true;
                        // Printable character: forward to search field (charCode >= 32 excludes control chars)
                        } else if (event.text.length > 0 && event.text.charCodeAt(0) >= 32) {
                            _search.insert(_search.cursorPosition, event.text);
                            _search.forceActiveFocus();
                            event.accepted = true;
                        }
                    }
                }

                DesktopText {
                    anchors.centerIn: parent
                    visible: _list.count === 0 && _search.text !== ""
                    text: "Aucun résultat"
                    variant: DesktopText.Variant.Subtitle
                    color: Colors.base03
                }

                DesktopText {
                    anchors.centerIn: parent
                    visible: _list.count === 0 && _search.text === "" && root.pickerOpened && root.emptyText !== ""
                    text: root.emptyText
                    variant: DesktopText.Variant.Subtitle
                    color: Colors.base03
                }
            }
        }
    }

    // WORKAROUND: forceActiveFocus() must be deferred until Wayland has confirmed
    // focus transfer to this surface (wl_keyboard.enter + text-input activation),
    // which takes multiple round-trips (~10-30ms). Qt.callLater() is not enough
    // and produces the following warnings:
    //   WARN qt.qpa.wayland.textinput: enableSurface(0x…launcher) with focusing surface(0x…topbar)
    //   WARN qt.qpa.wayland.textinput: enableSurface(0x…clipboard) with focusing surface(0x…launcher)
    //   WARN qt.qpa.wayland.textinput: enableSurface(0x…launcher) with focusing surface(0x…clipboard)
    // PopupWindow does not expose onActiveChanged to detect the actual focus arrival.
    Timer {
        id: _focusTimer
        interval: 50
        onTriggered: _search.forceActiveFocus()
    }

    function focusSearch(): void {
        _search.text = "";
        _focusTimer.restart();
    }
}
