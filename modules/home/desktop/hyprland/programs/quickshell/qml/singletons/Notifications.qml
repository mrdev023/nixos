pragma Singleton

import Quickshell
import Quickshell.Services.Notifications as QSN

Singleton {
    id: root

    readonly property alias trackedNotifications: _server.trackedNotifications

    QSN.NotificationServer {
        id: _server

        actionsSupported: true
        bodyMarkupSupported: true

        onNotification: notif => {
            notif.tracked = true;
        }
    }
}
