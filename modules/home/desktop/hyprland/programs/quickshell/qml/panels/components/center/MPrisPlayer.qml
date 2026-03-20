import QtQuick
import Quickshell.Services.Mpris as QSSM

import "../../../components"
import "../../../singletons"

Row {
    property QSSM.MprisPlayer _player: {
        const players = [...QSSM.Mpris.players.values];
        return players.sort((a, b) => playerScore(b) - playerScore(a))[0];
    }

    anchors.verticalCenter: parent.verticalCenter
    visible: _player
    spacing: Variables.windowGap

    DesktopText {
        text: parent._player ? `${parent._player.isPlaying ? "󰐊" : "󰏤"}` : ""
        variant: DesktopText.Bigtext
    }

    DesktopText {
        text: parent._player ? `${parent._player.trackTitle} - ${parent._player.trackArtist}` : ""
        variant: DesktopText.Bigtext
        font.italic: !!!parent._player?.isPlaying
        elide: Text.ElideRight
        width: Math.min(implicitWidth, 350)
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
