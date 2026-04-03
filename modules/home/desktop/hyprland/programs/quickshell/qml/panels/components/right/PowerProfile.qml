import QtQuick
import QtQuick.Layouts as QQL
import Quickshell.Services.UPower as QSSU

import "../../../components"
import "../../../singletons"

RightBarItem {
    id: root

    property int profile: QSSU.PowerProfiles.profile

    visible: QSSU.PowerProfiles.hasPerformanceProfile
    iconText: _icon()

    onTapped: detailsWindow.opened = !detailsWindow.opened

    DesktopPopup {
        id: detailsWindow
        spacing: Variables.windowGap

        QQL.RowLayout {
            QQL.Layout.fillWidth: true
            QQL.Layout.bottomMargin: Variables.windowGap

            DesktopText {
                text: "󰾅"
                variant: DesktopText.Variant.Title
            }

            DesktopText {
                QQL.Layout.fillWidth: true
                text: "Profil d'alimentation"
                variant: DesktopText.Variant.Title
            }
        }

        DesktopStepSelector {
            QQL.Layout.fillWidth: true
            icons: ["󰌪", "󰾅", "󰓅"]
            activeIndex: {
                const profiles = [QSSU.PowerProfile.PowerSaver, QSSU.PowerProfile.Balanced, QSSU.PowerProfile.Performance]
                const idx = profiles.indexOf(root.profile)
                return idx >= 0 ? idx : 0
            }
            onActivated: (index) => {
                const profiles = [QSSU.PowerProfile.PowerSaver, QSSU.PowerProfile.Balanced, QSSU.PowerProfile.Performance]
                QSSU.PowerProfiles.profile = profiles[index]
            }
        }
    }

    function _icon(): string {
        if (profile === QSSU.PowerProfile.PowerSaver)
            return "󰌪";
        if (profile === QSSU.PowerProfile.Balanced)
            return "󰾅";
        if (profile === QSSU.PowerProfile.Performance)
            return "󰓅";
        return "󰗖";
    }
}
