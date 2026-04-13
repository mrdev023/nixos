pragma Singleton

import Quickshell
import Quickshell.Services.Mpris as QSSM

Singleton {
    id: root

    property var players: {
        const players = [...QSSM.Mpris.players.values];
        return players.sort((a, b) => _playerScore(b) - _playerScore(a));
    }

    property int _playerIndex: 0
    property int _playerCount: players.length

    readonly property QSSM.MprisPlayer player: players.length > 0 ? players[Math.min(_playerIndex, players.length - 1)] : null
    readonly property bool hasPrevPlayer: root._playerIndex > 0
    readonly property bool hasNextPlayer: root._playerIndex < root.players.length - 1

    onPlayersChanged: {
        if (players.length < _playerCount)
            _playerIndex = 0;
        _playerCount = players.length;
    }

    function prevPlayer(): void {
        root._playerIndex--;
    }

    function nextPlayer(): void {
        root._playerIndex++;
    }

    function _playerScore(player: QSSM.MprisPlayer): int {
        let score = 0;
        if (player.isPlaying)
            score += 1;
        if (/spotify/i.test(String(player.identity)))
            score += 10;
        return score;
    }
}
