import QtQuick

import "../singletons"

Item {
    id: root

    property var icons: []
    property int activeIndex: 0
    signal activated(int index)

    readonly property int dotSize: 14
    readonly property int trackThickness: 4
    readonly property int count: icons.length
    readonly property real dotGap: count > 1 ? (width - dotSize) / (count - 1) : 0

    implicitHeight: _iconsArea.implicitHeight + Variables.windowGap + dotSize

    // Icons positioned absolutely, each centered over its dot
    Item {
        id: _iconsArea
        anchors.top: parent.top
        width: parent.width
        implicitHeight: _iconMeasure.implicitHeight

        DesktopText { id: _iconMeasure; text: "X"; visible: false }

        Repeater {
            model: root.icons
            delegate: DesktopText {
                x: Math.round(index * root.dotGap + root.dotSize / 2 - implicitWidth / 2)
                text: modelData
                color: index <= root.activeIndex ? Colors.base05 : Colors.base03

                Behavior on color { ColorAnimation { duration: 150 } }
            }
        }
    }

    Item {
        anchors.top: _iconsArea.bottom
        anchors.topMargin: Variables.windowGap
        width: parent.width
        height: root.dotSize

        Rectangle {
            y: (parent.height - root.trackThickness) / 2
            x: root.dotSize / 2
            width: parent.width - root.dotSize
            height: root.trackThickness
            radius: root.trackThickness / 2
            color: Colors.base01
        }

        Rectangle {
            y: (parent.height - root.trackThickness) / 2
            x: root.dotSize / 2
            width: root.activeIndex * root.dotGap
            height: root.trackThickness
            radius: root.trackThickness / 2
            color: Colors.base0D

            Behavior on width {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }
        }

        Repeater {
            model: root.count
            delegate: Rectangle {
                x: index * root.dotGap
                width: root.dotSize
                height: root.dotSize
                radius: root.dotSize / 2
                color: index <= root.activeIndex ? Colors.base0D : Colors.base02
                transformOrigin: Item.Center
                scale: index === root.activeIndex ? 1.5 : 1.0

                Behavior on color { ColorAnimation { duration: 150 } }
                Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -Variables.windowGap / 2
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.activated(index)
                }
            }
        }
    }
}
