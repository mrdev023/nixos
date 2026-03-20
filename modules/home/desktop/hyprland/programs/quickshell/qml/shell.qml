import Quickshell
import Quickshell.Hyprland as QSH

import QtQuick

PanelWindow {
    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 10
        left: 10
        right: 10
    }

    color: "transparent"
    implicitHeight: 30

    Item {
        anchors.fill: parent

        LeftPanel {
            height: parent.height
            anchors.left: parent.left
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
