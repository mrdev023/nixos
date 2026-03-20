import QtQuick
import Quickshell.Io as QSIO

import "../../../components"
import "../../../popups"
import "../../../singletons"

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

        ConfirmPopup {
            id: confirmDialog
        }

        Row {
            id: drawer
            spacing: Variables.windowGap

            PowerAction {
                id: logout
                text: "󰍃"
                variant: DesktopText.Bigtext
                message: "Se déconnecter ?"
                command: ["hyprctl", "dispatch", "exit"]
            }

            PowerAction {
                id: lock
                text: "󰌾"
                variant: DesktopText.Bigtext
                message: "Verrouiller la session ?"

                command: ["hyprlock"]
            }

            PowerAction {
                id: reboot
                text: "󰜉"
                variant: DesktopText.Bigtext
                message: "Redémarrer le système ?"

                command: ["reboot"]
            }
        }
    }

    component PowerAction: DesktopText {
        id: powerAction

        property alias message: confirmDialog.message
        property alias command: process.command

        QSIO.Process {
            id: process
        }

        ConfirmPopup {
            id: confirmDialog
            onConfirmed: process.running = true
        }

        TapHandler {
            onTapped: confirmDialog.open()
        }

        HoverHandler {
            cursorShape: Qt.PointingHandCursor
        }
    }

    Item {
        id: main
        implicitWidth: shutdown.implicitWidth
        implicitHeight: shutdown.implicitHeight

        PowerAction {
            id: shutdown
            text: "󰐥"
            color: Colors.base08
            variant: DesktopText.Bigtext
            message: "Arrêter le système ?"
            command: ["shutdown", "now"]
        }
    }

    HoverHandler {
        id: hover
    }
}
