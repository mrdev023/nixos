import QtQuick

Image {
    id: root

    property string iconSource: ""

    source: _resolveSource(iconSource)
    visible: status !== Image.Error && iconSource !== ""
    sourceSize: Qt.size(width > 0 ? width : height, height)
    fillMode: Image.PreserveAspectFit

    // Workaround: Quickshell does not support custom icon search paths embedded
    // in the URI as "?path=" query params (e.g. spotify-linux-32?path=/nix/...).
    // Extract the path and load the icon file directly instead.
    function _resolveSource(uri) {
        if (!uri.startsWith("image://icon/"))
            return uri;

        const queryIdx = uri.indexOf("?path=");
        if (queryIdx === -1)
            return uri;

        const name = uri.substring("image://icon/".length, queryIdx);
        const path = uri.substring(queryIdx + "?path=".length);
        return "file://" + path + "/" + name + ".png";
    }
}
