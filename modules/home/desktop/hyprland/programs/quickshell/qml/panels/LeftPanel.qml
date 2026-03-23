import QtQuick
import Quickshell as QS
import Quickshell.Hyprland as QSH

import "../components"
import "./components/left"
import "../singletons"

Panel {
    id: root

    property QSH.HyprlandMonitor monitor

    implicitWidth: workspaces.implicitWidth + Variables.windowGap * 2
    MouseArea {
        anchors.fill: parent
        onWheel: event => {
            const workspaces = QSH.Hyprland.workspaces.values.filter(w => w.monitor == root.monitor);
            const count = workspaces.length;
            if (count === 0)
                return;

            const currentIndex = workspaces.indexOf(QSH.Hyprland.focusedWorkspace);
            if (currentIndex === -1)
                return;

            const direction = event.angleDelta.y > 0 ? 1 : -1;
            const newIndex = (currentIndex + direction + count) % count;

            workspaces[newIndex].activate();
        }
    }

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
                height: root.height - Variables.windowGap * 2
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
