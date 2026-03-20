import Quickshell as QS
import Quickshell.Services.Mpris as QSSM

import QtQuick

Rectangle {
    width: row.implicitWidth + row.anchors.leftMargin + row.anchors.rightMargin
    radius: 10
    color: "red"

    Row {
        id: row

        anchors {
            fill: parent
            leftMargin: 10
            rightMargin: 10
        }

        QS.SystemClock {
          id: clock
          precision: QS.SystemClock.Seconds
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            visible: QSSM.Mpris.players.values.length != 0
            text: QSSM.Mpris.players.values[0].trackAlbum|| ""
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: clock.date.toLocaleString(Qt.locale(), "dddd dd MMM, hh:mm")
        }
    }
}

