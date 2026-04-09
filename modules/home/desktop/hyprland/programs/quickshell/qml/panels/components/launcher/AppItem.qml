import QtQuick
import QtQuick.Layouts as QQL
import Quickshell as QS

import "../../../components"
import "../../../singletons"

Item {
    id: root

    required property QS.DesktopEntry modelData
    required property int index

    width: ListView.view.width
    height: Variables.topBarHeight

    QQL.RowLayout {
        anchors {
            fill: parent
            leftMargin: Variables.windowGap
            rightMargin: Variables.windowGap
        }
        spacing: Variables.windowGap

        DesktopIcon {
            iconSource: "image://icon/" + root.modelData.icon
            width: 20
            height: 20
        }

        DesktopText {
            QQL.Layout.fillWidth: true
            text: root.modelData.name
            variant: DesktopText.Variant.Text
            elide: Text.ElideRight
        }
    }

    TapHandler {
        onTapped: {
            root.modelData.execute();
            Launcher.close();
        }
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
        onHoveredChanged: if (hovered) root.ListView.view.currentIndex = root.index
    }
}
