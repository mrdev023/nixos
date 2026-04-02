import QtQuick
import Quickshell as QS
import Quickshell.Services.SystemTray as QSSST

import "../../../singletons"

Image {
    id: root
    property QSSST.SystemTrayItem trayItem

    source: resolveSource(trayItem.icon)
    height: Fonts.ptToPx(Fonts.desktopSize, topBar.screen)
    fillMode: Image.PreserveAspectFit

    QS.QsMenuAnchor {
        id: menuAnchor
        menu: root.trayItem.menu
        anchor.window: topBar
        anchor.rect: Qt.rect(root.mapToItem(null, 0, 0).x, topBar.height, root.width, 0)
        anchor.edges: QS.Edges.Bottom
        anchor.gravity: QS.Edges.Bottom | QS.Edges.Right
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton) {
                if (root.trayItem.hasMenu)
                    menuAnchor.open()
            } else {
                root.trayItem.activate()
            }
        }
    }

    // Workaround:
    //   Searching custom icon paths is not yet supported. Icon path will be ignored for "spotify-linux-32?path=/nix/store/7gw1aml0wpxzxbfk73vvgz8pk0h9k10g-spicetify-stylix/share/spotify/icons"
    //   Could not load icon "spotify-linux-32?path=/nix/store/7gw1aml0wpxzxbfk73vvgz8pk0h9k10g-spicetify-stylix/share/spotify/icons" at size QSize(100, 100) from request
    function resolveSource(uri) {
        if (!uri.startsWith("image://icon/"))
            return uri;

        // Extract ?path= value
        let queryIdx = uri.indexOf("?path=");
        if (queryIdx === -1)
            return uri;

        let iconName = uri.substring("image://icon/".length, queryIdx);
        let iconPath = uri.substring(queryIdx + "?path=".length);

        // Load directly from file instead
        return "file://" + iconPath + "/" + iconName + ".png";
    }
}
