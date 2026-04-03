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

        PowerProfileItem {
            profile: QSSU.PowerProfile.PowerSaver
            label: "Économie d'énergie"
        }

        PowerProfileItem {
            profile: QSSU.PowerProfile.Balanced
            label: "Équilibré"
        }

        PowerProfileItem {
            profile: QSSU.PowerProfile.Performance
            label: "Performance"
        }
    }

    component PowerProfileItem: QQL.RowLayout {
        id: item

        required property int profile
        required property string label

        spacing: Variables.windowGap

        DesktopText {
            QQL.Layout.fillWidth: true
            text: item.label
            variant: DesktopText.Text
        }

        DesktopSwitch {
            checked: root.profile === item.profile
            onClicked: QSSU.PowerProfiles.profile = item.profile
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
