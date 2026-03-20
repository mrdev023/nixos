import QtQuick
import Quickshell as QS

QS.Variants {
    model: QS.Quickshell.screens
    
    TopBar {
        required property var modelData
        screen: modelData
    }
}
