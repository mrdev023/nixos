import QtQuick
import QtQuick.Layouts as QQL
import Quickshell.Bluetooth as QSB

import "../../../components"
import "../../../singletons"

RightBarItem {
    id: root

    property QSB.BluetoothAdapter _adapter: QSB.Bluetooth.defaultAdapter

    visible: !!_adapter
    iconText: _icon()

    onTapped: detailsWindow.opened = !detailsWindow.opened

    DesktopPopup {
        id: detailsWindow
        spacing: Variables.windowGap

        QQL.RowLayout {
            QQL.Layout.fillWidth: true

            DesktopText {
                text: "󰂯"
                variant: DesktopText.Variant.Title
            }

            DesktopText {
                QQL.Layout.fillWidth: true
                text: "Appareils bluetooth"
                variant: DesktopText.Variant.Title
            }

            DesktopSwitch {
                checked: root._adapter.state === QSB.BluetoothAdapterState.Enabled
                onClicked: root._adapter.enabled = !root._adapter.enabled
            }
        }

        QQL.RowLayout {
            visible: connectedRepeater.count > 0
            QQL.Layout.topMargin: Variables.windowGap
            QQL.Layout.bottomMargin: Variables.windowGap

            DesktopText {
                QQL.Layout.fillWidth: true
                text: "Connecté"
                variant: DesktopText.Subtitle
            }
        }

        Repeater {
            id: connectedRepeater
            model: root._adapter?.devices.values.filter(filterConnectedDevice)
            delegate: BluetoothDeviceItem {
                required property QSB.BluetoothDevice modelData
                device: modelData
            }
        }

        QQL.RowLayout {
            visible: disconnectedRepeater.count > 0
            QQL.Layout.topMargin: Variables.windowGap
            QQL.Layout.bottomMargin: Variables.windowGap

            DesktopText {
                QQL.Layout.fillWidth: true
                text: "Disponibles"
                variant: DesktopText.Subtitle
            }
        }

        Repeater {
            id: disconnectedRepeater
            model: root._adapter?.devices.values.filter(d => !filterConnectedDevice(d))
            delegate: BluetoothDeviceItem {
                required property QSB.BluetoothDevice modelData
                device: modelData
            }
        }
    }

    component BluetoothDeviceItem: QQL.RowLayout {
        required property QSB.BluetoothDevice device
        spacing: Variables.windowGap

        QQL.ColumnLayout {
            DesktopText {
                QQL.Layout.fillWidth: true
                text: device.name
                variant: DesktopText.Text
            }

            DesktopText {
                visible: device.batteryAvailable
                text: `Batterie: ${Math.round(device.battery * 100)}%`
                variant: DesktopText.Subtext
            }
        }

        DesktopButton {
            buttonText: label()

            onClicked: {
                switch (state()) {
                case "not_paired":
                    device.pair();
                case "disconnected":
                    device.connect();
                case "connected":
                    device.disconnect();
                default:
                    break;
                }
            }

            function label(): string {
                switch (state()) {
                case "not_paired":
                    return "Appairer";
                case "pairing":
                    return "Appairage...";
                case "disconnected":
                    return "Déconnecté";
                case "connecting":
                    return "Connexion...";
                case "connected":
                    return "Connecté";
                case "disconnecting":
                    return "Déconnexion...";
                default:
                    return `Invalid: ${state()}`;
                }
            }

            function state(): string {
                if (!device.paired)
                    return "not_paired";
                if (device.paring)
                    return "pairing";
                if (device.state === QSB.BluetoothDeviceState.Connecting)
                    return "connecting";
                if (device.state === QSB.BluetoothDeviceState.Connected)
                    return "connected";
                if (device.state === QSB.BluetoothDeviceState.Disconnecting)
                    return "disconnecting";
                if (device.state === QSB.BluetoothDeviceState.Disconnected)
                    return "disconnected";
                return "unknown";
            }
        }
    }

    function filterConnectedDevice(device: QSB.BluetoothDevice): bool {
        switch (device.state) {
        case QSB.BluetoothDeviceState.Connecting:
        case QSB.BluetoothDeviceState.Connected:
        case QSB.BluetoothDeviceState.Disconnecting:
            return true;
        default:
            return false;
        }
    }

    function _icon(): string {
        let connectedDevice = root._adapter?.devices.values.filter(d => d.connected).length;
        if (connectedDevice)
            return "󰂱";

        switch (root._adapter.state) {
        case QSB.BluetoothAdapterState.Disabled:
            return "󰂲";
        case QSB.BluetoothAdapterState.Enabling:
        case QSB.BluetoothAdapterState.Disabling:
        case QSB.BluetoothAdapterState.Enabled:
            return "󰂯";
        case QSB.BluetoothAdapterState.Blocked:
            return "󰗖";
        default:
            return "󰂯";
        }
    }
}
