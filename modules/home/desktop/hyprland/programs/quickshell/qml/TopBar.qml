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

    color: "transparent"
    implicitHeight: Variables.topBarHeight + Variables.windowGap * 2

    Item {
        anchors {
            fill: parent

            leftMargin: Variables.windowGap
            topMargin: Variables.windowGap
            rightMargin: Variables.windowGap
        }

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
