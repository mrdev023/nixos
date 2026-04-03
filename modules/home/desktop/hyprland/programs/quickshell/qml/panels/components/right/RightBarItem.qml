import QtQuick

import "../../../components"
import "../../../singletons"

Item {
    id: root

    property alias iconText: _icon.text
    signal tapped()

    implicitWidth: _icon.implicitWidth
    implicitHeight: _icon.implicitHeight

    DesktopText {
        id: _icon
        variant: DesktopText.Bigtext
        verticalAlignment: Text.AlignVCenter
    }

    TapHandler {
        onTapped: root.tapped()
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
}
