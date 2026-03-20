import QtQuick
import Quickshell.Services.UPower as QSSU

import "../components"
import "../singletons"

Item {
    property int profile: QSSU.PowerProfiles.profile

    visible: QSSU.PowerProfiles.hasPerformanceProfile
    implicitWidth: name.implicitWidth
    implicitHeight: name.implicitHeight

    DesktopText {
        id: name
        text: icon()
        color: Colors.base05
        verticalAlignment: Text.AlignVCenter

        function icon(): string {
            if (profile === QSSU.PowerProfile.PowerSaver)
                return "󰌪"
            if (profile === QSSU.PowerProfile.Balanced)
                return "󰾅"
            if (profile === QSSU.PowerProfile.Performance)
                return "󰓅"

            return "󰗖"
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                switch (profile) {
                    case QSSU.PowerProfile.PowerSaver:
                        QSSU.PowerProfiles.profile = QSSU.PowerProfile.Balanced
                        break
                    case QSSU.PowerProfile.Balanced:
                        QSSU.PowerProfiles.profile = QSSU.PowerProfile.Performance
                        break
                    case QSSU.PowerProfile.Performance:
                        QSSU.PowerProfiles.profile = QSSU.PowerProfile.PowerSaver
                        break
                }
            }
        }
    }
}
