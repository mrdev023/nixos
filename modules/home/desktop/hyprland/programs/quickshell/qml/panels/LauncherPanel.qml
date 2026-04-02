import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts as QQL
import Quickshell as QS
import Quickshell.Hyprland as QSH

import "../components"
import "../singletons"

QS.PopupWindow {
    id: root

    color: "transparent"
    width: 500
    height: 450
    visible: Launcher.opened || _container.opacity > 0

    anchor {
        window: topBar
        rect {
            x: topBar.width / 2 - root.width / 2
            y: topBar.screen.height / 2 - root.height / 2
        }
    }

    onVisibleChanged: if (!visible)
        Launcher.close()

    QSH.HyprlandFocusGrab {
        id: _grab
        windows: [root]
        active: Launcher.opened
        onCleared: Launcher.close()
    }

    Panel {
        id: _container

        anchors {
            fill: parent
            margins: Variables.windowGap
        }
        opacity: Launcher.opened ? 1.0 : 0.0

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
                placeholderText: "Rechercher une application..."
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

                onTextChanged: Launcher.searchText = text

                Keys.onEscapePressed: Launcher.close()
                Keys.onDownPressed: {
                    if (_appList.count > 0) {
                        _appList.currentIndex = 0;
                        _appList.forceActiveFocus();
                    }
                }
                Keys.onReturnPressed: {
                    if (_appList.count > 0) {
                        _appModel.values[0].execute();
                        Launcher.close();
                    }
                }
            }

            ListView {
                id: _appList

                QQL.Layout.fillWidth: true
                QQL.Layout.fillHeight: true
                clip: true
                spacing: Variables.windowGap / 2
                highlightMoveDuration: 100
                currentIndex: -1

                onCountChanged: currentIndex = count > 0 ? 0 : -1

                model: QS.ScriptModel {
                    id: _appModel
                    values: QS.DesktopEntries.applications.values.filter(root._matchesSearch).sort((a, b) => a.name.localeCompare(b.name))
                }

                highlight: Rectangle {
                    color: Colors.base01
                    radius: Variables.windowRadius / 2
                    opacity: 0.7
                }

                delegate: Item {
                    id: _delegate

                    required property QS.DesktopEntry modelData
                    required property int index

                    width: _appList.width
                    height: Variables.topBarHeight

                    QQL.RowLayout {
                        anchors {
                            fill: parent
                            leftMargin: Variables.windowGap
                            rightMargin: Variables.windowGap
                        }
                        spacing: Variables.windowGap

                        Image {
                            width: 20
                            height: 20
                            sourceSize: Qt.size(20, 20)
                            visible: _delegate.modelData.icon !== ""
                            source: _delegate.modelData.icon !== "" ? ("image://icon/" + _delegate.modelData.icon) : ""
                            fillMode: Image.PreserveAspectFit
                        }

                        DesktopText {
                            QQL.Layout.fillWidth: true
                            text: _delegate.modelData.name
                            variant: DesktopText.Variant.Text
                            elide: Text.ElideRight
                        }
                    }

                    TapHandler {
                        onTapped: {
                            _delegate.modelData.execute();
                            Launcher.close();
                        }
                    }

                    HoverHandler {
                        cursorShape: Qt.PointingHandCursor
                        onHoveredChanged: if (hovered)
                            _appList.currentIndex = _delegate.index
                    }
                }

                Keys.onEscapePressed: Launcher.close()
                Keys.onReturnPressed: {
                    if (currentItem) {
                        currentItem.modelData.execute();
                        Launcher.close();
                    }
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
                QQL.Layout.fillWidth: true
                visible: _appList.count === 0 && Launcher.searchText !== ""
                text: "Aucun résultat"
                variant: DesktopText.Variant.Subtext
                color: Colors.base03
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Connections {
        target: Launcher
        function onOpenedChanged(): void {
            if (Launcher.opened) {
                _search.text = "";
                _search.forceActiveFocus();
            }
        }
    }

    function _matchesSearch(app: QS.DesktopEntry): bool {
        const q = Launcher.searchText.toLowerCase();

        if (q === "")
            return true;
        if (app.name.toLowerCase().includes(q))
            return true;
        if (app.genericName !== "" && app.genericName.toLowerCase().includes(q))
            return true;
        if (app.keywords.some(k => k.toLowerCase().includes(q)))
            return true;

        return false;
    }
}
