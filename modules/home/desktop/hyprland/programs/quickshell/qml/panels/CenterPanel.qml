import QtQuick
import Quickshell as QS
import Quickshell.Services.Mpris as QSSM

import "../components"
import "../singletons"

Panel {
    implicitWidth: row.implicitWidth + Variables.windowGap * 4

    Row {
        id: row
        spacing: Variables.windowGap

        anchors {
            fill: parent
            leftMargin: Variables.windowGap
            rightMargin: Variables.windowGap
        }

        QS.SystemClock {
          id: clock
          precision: QS.SystemClock.Seconds
        }

        // Player Info
        Row {
            property QSSM.MprisPlayer player: QSSM.Mpris.players.values[0]
            anchors.verticalCenter: parent.verticalCenter
            visible: player
            spacing: Variables.windowGap

            DesktopText {
                text: parent.player ? `${parent.player.isPlaying ? "󰐊" : "󰏤"}` : ""
                color: Colors.base05
            }

            DesktopText {
                text: parent.player ? `${parent.player.trackTitle} - ${parent.player.trackArtist}` : ""
                color: Colors.base05
                font.italic: !!!parent.player?.isPlaying
                elide: Text.ElideRight
                width: Math.min(implicitWidth, 350)
            }

        }

        DesktopText {
            anchors.verticalCenter: parent.verticalCenter
            text: clock.date.toLocaleString(Qt.locale(), "dddd dd MMM, hh:mm")
            color: Colors.base05
        }
    }
}

