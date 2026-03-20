import QtQuick
import Quickshell as QS

import "../../../components"

Item {
    implicitWidth: text.implicitWidth
    implicitHeight: text.implicitHeight

    QS.SystemClock {
        id: clock
        precision: QS.SystemClock.Seconds
    }

    DesktopText {
        id: text
        anchors.verticalCenter: parent.verticalCenter
        text: clock.date.toLocaleString(Qt.locale(), "dddd dd MMM, hh:mm")
        variant: DesktopText.Bigtext
    }
}
