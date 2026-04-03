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

    // Middle click to mute
    TapHandler {
        acceptedButtons: Qt.MiddleButton
        onTapped: root.node.audio.muted = !root.node.audio.muted
    }

    // Scroll to adjust volume
    WheelHandler {
        onWheel: event => {
            if (event.angleDelta.y > 0)
                root.volumeUp();
            else
                root.volumeDown();
        }
    }

    DesktopPopup {
        id: detailsWindow
        spacing: Variables.windowGap

        QQL.RowLayout {
            QQL.Layout.fillWidth: true
            QQL.Layout.bottomMargin: Variables.windowGap

            DesktopText {
                text: kind === Audio.Sink ? "󰕾" : ""
                variant: DesktopText.Variant.Title
            }

            DesktopText {
                QQL.Layout.fillWidth: true
                text: kind === Audio.Sink ? "Sortie audio" : "Entrée audio"
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

    component AudioItem: QQL.RowLayout {
        id: audioItem
        required property QSSP.PwNode node

        spacing: Variables.windowGap

        DesktopText {
            QQL.Layout.fillWidth: true
            text: audioItem.node.nickname || audioItem.node.description || audioItem.node.name
            variant: DesktopText.Text
        }

        DesktopSwitch {
            checked: switch (root.kind) {
            case Audio.Sink:
                return QSSP.Pipewire.defaultAudioSink === audioItem.node;
            case Audio.Source:
                return QSSP.Pipewire.defaultAudioSource === audioItem.node;
            }

            onClicked: {
                if (root.kind === Audio.Sink)
                    QSSP.Pipewire.preferredDefaultAudioSink = audioItem.node;
                else
                    QSSP.Pipewire.preferredDefaultAudioSource = audioItem.node;
            }
        }
    }

    DesktopPopup {
        id: indicator
        closeOnFocusLost: false

        QQL.RowLayout {
            spacing: Variables.windowGap

            DesktopText {
                text: root.kind === Audio.Sink ? "󰕾" : ""
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

    QSH.GlobalShortcut {
        name: "volume_up"
        onPressed: {
            if (root.kind !== Audio.Sink)
                return;
            root.volumeUp();
        }
    }

    QSH.GlobalShortcut {
        name: "volume_down"
        onPressed: {
            if (root.kind !== Audio.Sink)
                return;
            root.volumeDown();
        }
    }

    function volumeUp(): void {
        if (root.node.audio.muted) {
            root.node.audio.muted = false;
        } else {
            let newValue = root.node.audio.volume + 0.05;
            root.node.audio.volume = Math.min(newValue, 1.0);
        }
    }

    function volumeDown(): void {
        root.node.audio.volume -= 0.05;
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
            return "";
        if (root.node.audio.volume <= 0.5)
            return "󰍮";
        return "";
    }
}
