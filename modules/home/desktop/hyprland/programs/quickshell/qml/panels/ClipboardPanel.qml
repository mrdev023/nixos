import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts as QQL
import Quickshell as QS
import Quickshell.Hyprland as QSH

import "../components"
import "./components/clipboard"
import "../singletons"

QS.PopupWindow {
    id: root

    color: "transparent"
    implicitWidth: 500
    implicitHeight: 450
    visible: Clipboard.opened || _container.opacity > 0

    anchor {
        window: topBar
        rect {
            x: topBar.width / 2 - root.width / 2
            y: topBar.screen.height / 2 - root.height / 2
        }
    }

    onVisibleChanged: if (!visible) Clipboard.close()

    QSH.HyprlandFocusGrab {
        id: _grab
        windows: [root]
        active: Clipboard.opened
        onCleared: Clipboard.close()
    }

    Panel {
        id: _container

        anchors {
            fill: parent
            margins: Variables.windowGap
        }
        opacity: Clipboard.opened ? 1.0 : 0.0

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
                placeholderText: "Rechercher dans le presse-papier..."
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

                onTextChanged: Clipboard.searchText = text

                Keys.onEscapePressed: Clipboard.close()
                Keys.onDownPressed: {
                    if (_clipList.count > 0) {
                        _clipList.currentIndex = 0;
                        _clipList.forceActiveFocus();
                    }
                }
                Keys.onReturnPressed: {
                    if (_clipList.count > 0)
                        Clipboard.select(_clipModel.values[0]);
                }
            }

            Item {
                QQL.Layout.fillWidth: true
                QQL.Layout.fillHeight: true

                ListView {
                    id: _clipList

                    anchors.fill: parent
                    clip: true
                    spacing: Variables.windowGap / 2
                    highlightMoveDuration: 100
                    currentIndex: -1
                    visible: count > 0

                    onCountChanged: currentIndex = count > 0 ? 0 : -1

                    model: QS.ScriptModel {
                        id: _clipModel
                        values: Clipboard.entries.filter(root._matchesSearch)
                    }

                    highlight: Rectangle {
                        color: Colors.base01
                        radius: Variables.windowRadius / 2
                        opacity: 0.7
                    }

                    delegate: ClipItem {}

                    Keys.onEscapePressed: Clipboard.close()
                    Keys.onReturnPressed: {
                        if (currentItem)
                            Clipboard.select(currentItem.modelData);
                    }
                    Keys.onUpPressed: {
                        if (currentIndex <= 0) {
                            currentIndex = -1;
                            _search.forceActiveFocus();
                        } else {
                            decrementCurrentIndex();
                        }
                    }
                }

                DesktopText {
                    anchors.centerIn: parent
                    visible: _clipList.count === 0 && Clipboard.searchText !== ""
                    text: "Aucun résultat"
                    variant: DesktopText.Variant.Subtitle
                    color: Colors.base03
                }

                DesktopText {
                    anchors.centerIn: parent
                    visible: _clipList.count === 0 && Clipboard.searchText === "" && Clipboard.opened
                    text: "Presse-papier vide"
                    variant: DesktopText.Variant.Subtitle
                    color: Colors.base03
                }
            }
        }
    }

    Connections {
        target: Clipboard
        function onOpenedChanged(): void {
            if (Clipboard.opened) {
                _search.text = "";
                Qt.callLater(() => _search.forceActiveFocus());
            }
        }
    }

    function _matchesSearch(line: string): bool {
        if (Clipboard.searchText === "")
            return true;

        const tabIdx = line.indexOf('\t');
        const content = tabIdx >= 0 ? line.substring(tabIdx + 1) : line;
        return content.toLowerCase().includes(Clipboard.searchText.toLowerCase());
    }
}
