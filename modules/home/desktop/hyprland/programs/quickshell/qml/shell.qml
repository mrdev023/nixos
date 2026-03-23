import QtQuick
import Quickshell as QS

import "panels"
import "singletons"

QS.Variants {
    model: QS.Quickshell.screens
    
    TopBar {
        required property var modelData
        screen: modelData
    }
}
