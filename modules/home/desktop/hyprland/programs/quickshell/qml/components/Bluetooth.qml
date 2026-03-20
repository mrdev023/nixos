import QtQuick
import Quickshell.Bluetooth as QSB

import "../components"
import "../singletons"

Item {
    property QSB.BluetoothAdapter adapter: QSB.Bluetooth.defaultAdapter

    visible: !!adapter
    implicitWidth: name.implicitWidth
    implicitHeight: name.implicitHeight

    DesktopText {
        id: name
        text: icon()
        color: Colors.base05
        verticalAlignment: Text.AlignVCenter

        function icon(): string {
            let connectedDevice = adapter.devices.values.filter(d => d.connected).length
            if (connectedDevice) return "󰂱"

            switch (adapter.state) {
                case QSB.BluetoothAdapterState.Disabled:
                    return "󰂲"
                case QSB.BluetoothAdapterState.Enabling:
                case QSB.BluetoothAdapterState.Disabling:
                case QSB.BluetoothAdapterState.Enabled:
                    return "󰂯"
                case QSB.BluetoothAdapterState.Blocked:
                    return "󰗖"
                default:
                    return "󰂯"
            }
        }
    }
}
