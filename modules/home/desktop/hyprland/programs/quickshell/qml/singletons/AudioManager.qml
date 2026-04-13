pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire as QSSP

Singleton {
    id: root

    property QSSP.PwNode _audioSink: QSSP.Pipewire.defaultAudioSink
    property QSSP.PwNode _audioSource: QSSP.Pipewire.defaultAudioSource

    function audioUp(): void {
        volumeUp(_audioSink);
    }

    function audioDown(): void {
        volumeDown(_audioSink);
    }

    function audioMuteToggle(): void {
        muteToggle(_audioSink);
    }

    function micMuteToggle(): void {
        muteToggle(_audioSource);
    }

    function volumeUp(node: QSSP.PwNode): void {
        if (node.audio.muted) {
            node.audio.muted = false;
        } else {
            let newValue = node.audio.volume + 0.05;
            node.audio.volume = Math.min(newValue, 1.0);
        }
    }

    function volumeDown(node: QSSP.PwNode): void {
        node.audio.volume -= 0.05;
    }

    function muteToggle(node: QSSP.PwNode): void {
        node.audio.muted = !node.audio.muted;
    }
}
