import QtQuick
import QtQuick.Layouts as QQL
import Quickshell.Services.Mpris as QSSM

import "../../../components"
import "../../../singletons"

Item {
    id: root

    property var _players: {
        const players = [...QSSM.Mpris.players.values];
        return players.sort((a, b) => playerScore(b) - playerScore(a));
    }

    property int _playerIndex: 0
    property int _playerCount: 0

    Component.onCompleted: _playerCount = _players.length

    on_PlayersChanged: {
        if (_players.length < _playerCount)
            _playerIndex = 0;
        _playerCount = _players.length;
    }

    readonly property QSSM.MprisPlayer _player: _players.length > 0 ? _players[Math.min(_playerIndex, _players.length - 1)] : null

    implicitWidth: _row.implicitWidth
    implicitHeight: _row.implicitHeight

    Row {
        id: _row
        anchors.verticalCenter: parent.verticalCenter
        visible: !!root._player
        spacing: Variables.windowGap

        DesktopText {
            text: root._player ? (root._player.isPlaying ? "󰐊" : "󰏤") : ""
            variant: DesktopText.Bigtext
        }

        DesktopText {
            text: root._player ? `${root._player.trackTitle} - ${root._player.trackArtist}` : ""
            variant: DesktopText.Bigtext
            font.italic: !root._player?.isPlaying
            elide: Text.ElideRight
            width: Math.min(implicitWidth, 350)
        }
    }

    TapHandler {
        onTapped: detailsWindow.opened = !detailsWindow.opened
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }

    // position is not auto-updated by Quickshell — manually emit positionChanged() every second
    // See: https://quickshell.org/docs/v0.2.1/types/Quickshell.Services.Mpris/MprisPlayer/
    Timer {
        interval: 1000
        repeat: true
        running: !!root._player?.isPlaying && detailsWindow.opened
        onTriggered: root._player?.positionChanged()
    }

    DesktopPopup {
        id: detailsWindow
        position: DesktopPopup.Position.TopCenter
        spacing: Variables.windowGap

        QQL.RowLayout {
            QQL.Layout.fillWidth: true
            QQL.Layout.preferredWidth: 280
            visible: root._players.length > 1

            DesktopButton {
                buttonText: "󰒮"
                enabled: root._playerIndex > 0
                onClicked: root._playerIndex--
            }

            DesktopText {
                QQL.Layout.fillWidth: true
                text: root._player?.identity ?? ""
                variant: DesktopText.Variant.Subtext
                color: Colors.base03
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
            }

            DesktopButton {
                buttonText: "󰒭"
                enabled: root._playerIndex < root._players.length - 1
                onClicked: root._playerIndex++
            }
        }

        QQL.ColumnLayout {
            QQL.Layout.fillWidth: true
            QQL.Layout.preferredWidth: 280
            spacing: Variables.windowGap / 2

            DesktopText {
                QQL.Layout.fillWidth: true
                text: root._player?.trackTitle ?? ""
                variant: DesktopText.Variant.Title
                elide: Text.ElideRight
            }

            DesktopText {
                QQL.Layout.fillWidth: true
                text: root._player?.trackArtist ?? ""
                variant: DesktopText.Variant.Subtitle
                elide: Text.ElideRight
            }

            DesktopText {
                QQL.Layout.fillWidth: true
                visible: !!(root._player?.trackAlbum)
                text: root._player?.trackAlbum ?? ""
                variant: DesktopText.Variant.Subtext
                color: Colors.base03
                elide: Text.ElideRight
            }
        }

        DesktopProgressBar {
            QQL.Layout.fillWidth: true
            value: root._player && root._player.length > 0 ? root._player.position / root._player.length : 0

            TapHandler {
                onTapped: eventPoint => {
                    if (root._player && root._player.length > 0)
                        root._player.position = (eventPoint.position.x / parent.width) * root._player.length;
                }
            }

            HoverHandler {
                cursorShape: Qt.PointingHandCursor
            }
        }

        QQL.RowLayout {
            QQL.Layout.fillWidth: true

            DesktopText {
                text: _formatTime(root._player?.position ?? 0)
                variant: DesktopText.Variant.Subtext
                color: Colors.base03
            }

            Item {
                QQL.Layout.fillWidth: true
            }

            DesktopText {
                text: _formatTime(root._player?.length ?? 0)
                variant: DesktopText.Variant.Subtext
                color: Colors.base03
            }
        }

        QQL.RowLayout {
            QQL.Layout.fillWidth: true

            Item {
                QQL.Layout.fillWidth: true
            }

            DesktopButton {
                buttonText: "󰒮"
                enabled: root._player?.canGoPrevious ?? false
                onClicked: root._player?.previous()
            }

            DesktopButton {
                buttonText: root._player?.isPlaying ? "󰏤" : "󰐊"
                enabled: root._player?.canTogglePlaying ?? false
                onClicked: root._player?.togglePlaying()
            }

            DesktopButton {
                buttonText: "󰒭"
                enabled: root._player?.canGoNext ?? false
                onClicked: root._player?.next()
            }

            Item {
                QQL.Layout.fillWidth: true
            }
        }
    }

    function _formatTime(seconds: real): string {
        if (!seconds || seconds <= 0)
            return "0:00";
        const m = Math.floor(seconds / 60);
        const s = Math.floor(seconds % 60);
        return `${m}:${s.toString().padStart(2, "0")}`;
    }

    function playerScore(player: QSSM.MprisPlayer): int {
        let score = 0;
        if (player.isPlaying)
            score += 1;
        if (/spotify/i.test(String(player.identity)))
            score += 10;
        return score;
    }
}
