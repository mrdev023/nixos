import QtQuick

import "../singletons"


Rectangle {
    id: root
    readonly property real _padding: Variables.windowGap

    default property alias content: _content.children

    implicitWidth: _content.implicitWidth + _padding * 2

    color: Colors.base00
    radius: Variables.windowRadius

    Item {
        id: _content

        anchors {
            fill: parent
            margins: root._padding
        }
    }
}
