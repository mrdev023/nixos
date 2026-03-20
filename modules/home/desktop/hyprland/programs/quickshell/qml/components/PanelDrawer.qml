import QtQuick
import QtQuick.Layouts as QQL

import "../components"
import "../singletons"

DesktopPopup {
    id: root
    // If is completely hidden, switch to not visible
    // to avoid block event on others PanelDrawer
    // WARN: Binding loop detected for property "visible"
    //   root.width dépend de implicitWidth → _container.implicitWidth
    //   → qui peut changer quand visible change → qui recalcule _slideOffset
    //   → qui recalcule visible
    visible: _slideOffset < root.width

    // Variables.windowGap * 2 -> Keep spaces for Shadow
    implicitWidth: _container.implicitWidth + Variables.windowGap * 2
    implicitHeight: _container.implicitHeight + Variables.windowGap * 2

    property bool opened
    property real _slideOffset: opened ? 0 : root.width

    default property alias content: _content.children
    property alias spacing: _content.spacing

    Behavior on _slideOffset {
        NumberAnimation {
            duration: 250
            easing.type: Easing.OutCubic
        }
    }

    Panel {
        id: _container
        anchors.centerIn: parent
        implicitWidth: _content.implicitWidth + Variables.windowGap * 4
        implicitHeight: _content.implicitHeight + Variables.windowGap * 4
        transform: Translate {
            x: root._slideOffset
        }

        QQL.ColumnLayout {
            id: _content
            anchors.centerIn: parent
        }
    }
}
