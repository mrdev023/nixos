import QtQuick
import QtQuick.Layouts as QQL

import "../../../components"
import "../../../singletons"

Item {
    id: root

    required property string modelData
    required property int index

    readonly property string _displayText: {
        const tabIdx = modelData.indexOf('\t');
        return tabIdx >= 0 ? modelData.substring(tabIdx + 1) : modelData;
    }

    width: ListView.view.width
    height: Variables.topBarHeight

    QQL.RowLayout {
        anchors {
            fill: parent
            leftMargin: Variables.windowGap
            rightMargin: Variables.windowGap
        }

        DesktopText {
            QQL.Layout.fillWidth: true
            text: root._displayText
            variant: DesktopText.Variant.Text
            elide: Text.ElideRight
        }
    }

    TapHandler {
        onTapped: Clipboard.select(root.modelData)
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
        onHoveredChanged: if (hovered) root.ListView.view.currentIndex = root.index
    }
}
