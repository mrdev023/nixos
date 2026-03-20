import QtQuick
import Quickshell as QS

import "../singletons"

QS.PopupWindow {
    id: root
    color: "transparent"

    anchor {
        window: topBar // Top parent bar
        edges: QS.Edges.Top | QS.Edges.Right
        gravity: QS.Edges.Bottom | QS.Edges.Left
        rect {
            x: topBar.width
            y: topBar.height
        }
        margins {
            top: Variables.windowGap
            right: Variables.windowGap
        }
    }
}
