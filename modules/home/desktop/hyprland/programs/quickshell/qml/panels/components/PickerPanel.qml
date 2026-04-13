import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts as QQL

import "../../components"
import "../../singletons"

DesktopPopup {
    id: root

    property bool pickerOpened: false
    property string placeholderText: ""
    property string emptyText: ""
    property alias model: _list.model
    property alias searchText: _search.text
    property Component delegate

    signal closeRequested
    signal itemActivated(var modelData)

    position: DesktopPopup.Position.Center
    opened: pickerOpened

    onFocusLost: closeRequested()
    onVisibleChanged: {
        if (!visible)
            closeRequested();
    }

    onPickerOpenedChanged: {
        if (pickerOpened) {
            _search.text = "";
            _search.forceActiveFocus();
        }
    }

    // Single Item wrapper: drives popup size via content (popup = content + gap*6)
    Item {
        QQL.Layout.preferredWidth: 500 - Variables.windowGap * 6
        QQL.Layout.preferredHeight: 450 - Variables.windowGap * 6

        QQL.ColumnLayout {
            anchors.fill: parent
            spacing: Variables.windowGap

            DesktopTextArea {
                id: _search

                QQL.Layout.fillWidth: true
                placeholderText: root.placeholderText

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
                            if (event.key === Qt.Key_J) {
                                incrementCurrentIndex();
                                event.accepted = true;
                            } else if (event.key === Qt.Key_K) {
                                if (currentIndex <= 0) {
                                    currentIndex = -1;
                                    _search.forceActiveFocus();
                                } else {
                                    decrementCurrentIndex();
                                }
                                event.accepted = true;
                            }
                        } else if (event.key === Qt.Key_Backspace) {
                            _search.text = _search.text.slice(0, -1);
                            _search.forceActiveFocus();
                            event.accepted = true;
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
}
