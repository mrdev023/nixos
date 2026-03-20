import QtQuick
import QtQuick.Effects

import "../singletons"

Item {
    id: root
    readonly property real _padding: Variables.windowGap
    default property alias content: _content.children
    implicitWidth: _rect.implicitWidth
    implicitHeight: _rect.implicitHeight

    RectangularShadow {
        anchors.fill: _rect
        radius: _rect.radius
        color: Colors.base01
        cached: true
        blur: 10
    }

    Rectangle {
        id: _rect
        anchors.fill: parent
        implicitWidth: _content.implicitWidth + _padding * 2
        implicitHeight: _content.implicitHeight + _padding * 2
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
}
