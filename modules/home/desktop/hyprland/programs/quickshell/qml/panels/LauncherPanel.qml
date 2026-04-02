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

    onVisibleChanged: if (!visible) Launcher.close()

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

            Item {
                QQL.Layout.fillWidth: true
                QQL.Layout.fillHeight: true

                ListView {
                    id: _appList

                    anchors.fill: parent
                    clip: true
                    spacing: Variables.windowGap / 2
                    highlightMoveDuration: 100
                    currentIndex: -1
                    visible: count > 0

                    onCountChanged: currentIndex = count > 0 ? 0 : -1

                    model: QS.ScriptModel {
                        id: _appModel
                        values: QS.DesktopEntries.applications.values
                            .filter(root._matchesSearch)
                            .sort((a, b) => {
                                if (Launcher.searchText === "")
                                    return a.name.localeCompare(b.name);
                                return root._appScore(b) - root._appScore(a);
                            })
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
                            onHoveredChanged: if (hovered) _appList.currentIndex = _delegate.index
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
                    anchors.centerIn: parent
                    visible: _appList.count === 0 && Launcher.searchText !== ""
                    text: "Aucun résultat"
                    variant: DesktopText.Variant.Subtitle
                    color: Colors.base03
                }
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

    // Returns a fuzzy match score for `str` against `query`.
    // Characters of query must appear in order (subsequence).
    // Higher score = better match. Returns -1 if no match.
    function _fuzzyScore(str: string, query: string): int {
        const s = str.toLowerCase();
        const q = query.toLowerCase();

        let si = 0, qi = 0, score = 0, consecutive = 0;

        while (si < s.length && qi < q.length) {
            if (s[si] === q[qi]) {
                // Bonus: start of string
                if (si === 0)
                    score += 10;
                // Bonus: word boundary (preceded by separator)
                else if (" -_.".includes(s[si - 1]))
                    score += 8;
                // Bonus: consecutive chars
                score += consecutive * 4;
                consecutive++;
                qi++;
            } else {
                consecutive = 0;
            }
            si++;
        }

        if (qi < q.length)
            return -1;

        // Prefer shorter strings (less noise)
        score -= Math.floor(s.length / 4);

        return score;
    }

    // Best fuzzy score across name, genericName and keywords.
    function _appScore(app: QS.DesktopEntry): int {
        const q = Launcher.searchText;
        let best = _fuzzyScore(app.name, q);

        if (app.genericName !== "")
            best = Math.max(best, _fuzzyScore(app.genericName, q));

        for (const k of app.keywords)
            best = Math.max(best, _fuzzyScore(k, q));

        return best;
    }

    function _matchesSearch(app: QS.DesktopEntry): bool {
        if (Launcher.searchText === "")
            return true;

        return _appScore(app) >= 0;
    }
}
