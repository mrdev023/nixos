import Quickshell.Hyprland as QSH

import QtQuick

Rectangle {
    implicitWidth: workspaces.implicitWidth + 20
    radius: 10
    color: "green"

    Row {
        id: workspaces

        anchors {
            fill: parent   
            topMargin: 5
            leftMargin: 10
            rightMargin: 10
            bottomMargin: 5
        }

        Repeater {
            model: QSH.Hyprland.workspaces

            delegate: Rectangle {
                height: parent.height
                width: parent.height * 1.5
                radius: 5

                color: modelData.focused ? "red" : "transparent"

                Text {
                    text: modelData.name
                    anchors.centerIn: parent
                }
            }
        }
    }
    
}

