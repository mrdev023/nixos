import QtQuick

import "../singletons"

Row {
    Item {
        // Workaround: Variables.windowGap here instead of Row spacing to avoid final close jump
        //   When implicitWidth is equals to 0, Row hide drawer and remove spacing between shutdown and drawer
        //   But spacing is not animated so it make a final close jump.
        //   With this patch, we include the spacing in the animation
        implicitWidth: hover.hovered ? drawer.implicitWidth + Variables.windowGap : 0
        implicitHeight: main.implicitHeight
        clip: true

        Behavior on implicitWidth {
            NumberAnimation {
                duration: 500
                easing.type: Easing.OutCubic
            }
        }

        Row {
            id: drawer
            spacing: Variables.windowGap

            DesktopText {
                id: logout
                text: "󰍃"
                color: Colors.base05
            }
            DesktopText {
                id: lock
                text: "󰌾"
                color: Colors.base05
            }
            DesktopText {
                id: reboot
                text: "󰜉"
                color: Colors.base05
            }
        }
    }

    Item {
        id: main
        implicitWidth: shutdown.implicitWidth
        implicitHeight: shutdown.implicitHeight
    
        DesktopText {
            id: shutdown
            text: "󰐥"
            color: Colors.base08
        }
    }

    HoverHandler {
        id: hover
    }
}
