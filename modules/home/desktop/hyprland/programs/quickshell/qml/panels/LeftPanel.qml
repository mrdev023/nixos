import QtQuick
import Quickshell as QS
import Quickshell.Hyprland as QSH

import "../components"
import "../singletons"

Panel {
    id: root

    property QSH.HyprlandMonitor monitor

    implicitWidth: workspaces.implicitWidth + Variables.windowGap * 2
    implicitHeight: workspaces.implicitHeight
    
    Row {
        id: workspaces
        spacing: Variables.windowGap / 2

        Repeater {
            id: repeater
            model: QS.ScriptModel {
                values: QSH.Hyprland.workspaces.values.filter(w => w.monitor == root.monitor)
            }

            delegate: WorkspaceButton {
                workspace: modelData
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}

