import QtQuick
import QtQuick.Layouts as QQL
import Quickshell.Hyprland as QSH
import Quickshell.Services.Pipewire as QSSP

import "../../../components"
import "../../../singletons"

RightBarItem {
    id: root

    enum Kind {
        Sink,
        Source
    }

    required property int kind
    property QSSP.PwNode node: switch (kind) {
    case Audio.Sink:
        return QSSP.Pipewire.defaultAudioSink;
    case Audio.Source:
        return QSSP.Pipewire.defaultAudioSource;
    }

    QSSP.PwObjectTracker {
        objects: [root.node]
    }

    iconText: kind === Audio.Sink ? _iconSink() : _iconSource()

    onTapped: detailsWindow.opened = !detailsWindow.opened
    onMiddleTapped: AudioManager.muteToggle(root.node)
    onWheeled: delta => {
        if (delta > 0)
            AudioManager.volumeUp(root.node);
        else
            AudioManager.volumeDown(root.node);
    }

    DesktopPopup {
        id: detailsWindow
        spacing: Variables.windowGap

        QQL.RowLayout {
            QQL.Layout.fillWidth: true
            QQL.Layout.bottomMargin: Variables.windowGap

            DesktopText {
                text: root.kind === Audio.Sink ? "󰕾" : ""
                variant: DesktopText.Variant.Title
            }

            DesktopText {
                QQL.Layout.fillWidth: true
                text: root.kind === Audio.Sink ? "Sortie audio" : "Entrée audio"
                variant: DesktopText.Variant.Title
            }
        }

        Repeater {
            id: connectedRepeater
            model: QSSP.Pipewire.nodes.values.filter(filterNode)

            delegate: AudioItem {
                required property QSSP.PwNode modelData
                node: modelData
            }

            function filterNode(node: QSSP.PwNode): bool {
                if (node.isStream)
                    return false;

                switch (root.kind) {
                case Audio.Sink:
                    return node.isSink;
                case Audio.Source:
                    return !node.isSink;
                default:
                    return false;
                }
            }
        }
    }

    component AudioItem: DesktopRadioButton {
        required property QSSP.PwNode node

        text: node.nickname || node.description || node.name
        selected: root.kind === Audio.Sink ? QSSP.Pipewire.defaultAudioSink === node : QSSP.Pipewire.defaultAudioSource === node

        onClicked: {
            if (root.kind === Audio.Sink)
                QSSP.Pipewire.preferredDefaultAudioSink = node;
            else
                QSSP.Pipewire.preferredDefaultAudioSource = node;
        }
    }

    DesktopPopup {
        id: indicator
        passthrough: true

        QQL.RowLayout {
            spacing: Variables.windowGap

            DesktopText {
                text: root.kind === Audio.Sink ? "󰕾" : ""
                variant: DesktopText.Variant.Text
            }

            DesktopProgressBar {
                value: root.node.audio.volume
            }

            Connections {
                target: root.node?.audio ?? null
                function onVolumesChanged(): void {
                    indicator.opened = true;
                    indicatorTimer.restart();
                }
            }

            Timer {
                id: indicatorTimer
                interval: 2000
                repeat: false
                onTriggered: indicator.opened = false
            }
        }
    }

    function _iconSink(): string {
        if (!root.node)
            return "󰝟";
        if (!root.node.audio)
            return "󰝟";
        if (root.node.audio.muted || root.node.audio.volume === 0)
            return "󰖁";
        if (root.node.audio.volume <= 0.33)
            return "󰕿";
        if (root.node.audio.volume <= 0.66)
            return "󰖀";
        return "󰕾";
    }

    function _iconSource(): string {
        if (!root.node)
            return "󱦉";
        if (!root.node.audio)
            return "󱦉";
        if (root.node.audio.muted || root.node.audio.volume === 0)
            return "";
        if (root.node.audio.volume <= 0.5)
            return "󰍮";
        return "";
    }
}
