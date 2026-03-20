import QtQuick
import Quickshell.Services.Pipewire as QSSP

import "../components"
import "../singletons"

Item {
    id: root
    property QSSP.PwNode sink: QSSP.Pipewire.defaultAudioSink

    QSSP.PwObjectTracker { objects: [ root.sink ] }

    implicitWidth: name.implicitWidth
    implicitHeight: name.implicitHeight

    DesktopText {
        id: name
        text: icon()
        color: Colors.base05
        verticalAlignment: Text.AlignVCenter

        function icon(): string {
            if (!sink.audio) return "󰝟"
            if (sink.audio.muted) return "󰖁"
            if (sink.audio.volume <= 0.33) return "󰕿"
            if (sink.audio.volume <= 0.66) return "󰖀"
            return "󰕾"
            
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.MiddleButton) {
                root.sink.audio.muted = !root.sink.audio.muted
            }
        }
        onWheel: event => {
            if (event.angleDelta.y > 0) {
                root.sink.audio.volume += 0.05
            } else {
                root.sink.audio.volume -= 0.05
            }
        }
    }
}
