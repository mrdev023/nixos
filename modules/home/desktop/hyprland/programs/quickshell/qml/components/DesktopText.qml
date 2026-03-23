import QtQuick

import "../singletons"

Text {
    property int innerPadding: 0
    
    font {
        family: Fonts.monospace
        pixelSize: Fonts.ptToPx(Fonts.desktopSize, topBar.screen) - innerPadding
    }
}
