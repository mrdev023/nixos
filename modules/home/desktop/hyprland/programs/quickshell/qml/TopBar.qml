import QtQuick
import Quickshell as QS
import Quickshell.Hyprland as QSH

import "panels"
import "singletons"

QS.PanelWindow {
    id: topBar

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: Variables.windowGap
        left: Variables.windowGap
        right: Variables.windowGap
    }

    color: "transparent"
    implicitHeight: Variables.topBarHeight + Variables.windowGap

    Item {
        anchors.fill: parent

        LeftPanel {
            height: parent.height
            anchors.left: parent.left
            monitor: QSH.Hyprland.monitorFor(topBar.screen)
        }

        CenterPanel {
            height: parent.height
            anchors.centerIn: parent
        }

        RightPanel {
            height: parent.height
            anchors.right: parent.right
        }
    }
}
