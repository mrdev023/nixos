import QtQuick

import "../components"
import "./components/center"
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

        MPrisPlayer {}
        SystemClock {}
    }
}
