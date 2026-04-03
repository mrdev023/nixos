import QtQuick
import QtQuick.Layouts as QQL
import Quickshell.Services.UPower as QSSU

import "../../../components"
import "../../../singletons"

RightBarItem {
    id: root

    property QSSU.UPowerDevice device: QSSU.UPower.displayDevice

    visible: device?.isPresent ?? false
    iconText: _icon()

    onTapped: detailsWindow.opened = !detailsWindow.opened

    DesktopPopup {
        id: detailsWindow
        spacing: Variables.windowGap

        QQL.RowLayout {
            QQL.Layout.fillWidth: true
            QQL.Layout.bottomMargin: Variables.windowGap

            DesktopText {
                text: "󰁹"
                variant: DesktopText.Variant.Title
            }

            DesktopText {
                QQL.Layout.fillWidth: true
                text: "Batterie"
                variant: DesktopText.Variant.Title
            }
        }

        QQL.RowLayout {
            QQL.Layout.fillWidth: true
            spacing: Variables.windowGap

            DesktopText {
                QQL.Layout.fillWidth: true
                text: _stateLabel()
                variant: DesktopText.Text
            }

            DesktopText {
                text: `${Math.round((device?.percentage ?? 0) * 100)}%`
                variant: DesktopText.Text
            }
        }

        DesktopProgressBar {
            QQL.Layout.fillWidth: true
            value: device?.percentage ?? 0
        }

        DesktopText {
            visible: _timeRemaining() !== ""
            text: _timeRemaining()
            variant: DesktopText.Subtext
            color: Colors.base03
        }

        QQL.RowLayout {
            QQL.Layout.fillWidth: true
            spacing: Variables.windowGap

            DesktopText {
                QQL.Layout.fillWidth: true
                text: "Santé"
                variant: DesktopText.Text
            }

            DesktopText {
                text: device?.healthSupported
                    ? `${Math.round((device?.healthPercentage ?? 0) * 100)}%`
                    : "N/A"
                variant: DesktopText.Text
                color: device?.healthSupported ? _healthColor() : Colors.base03
            }
        }
    }

    function _icon(): string {
        if (!device)
            return "󰂑";

        const pct = device.percentage;

        if (device.state === QSSU.UPowerDeviceState.Charging
                || device.state === QSSU.UPowerDeviceState.PendingCharge) {
            if (pct < 0.1) return "󰢜";
            if (pct < 0.2) return "󰂆";
            if (pct < 0.3) return "󰂇";
            if (pct < 0.4) return "󰂈";
            if (pct < 0.5) return "󰢝";
            if (pct < 0.6) return "󰂉";
            if (pct < 0.7) return "󰢞";
            if (pct < 0.8) return "󰂊";
            if (pct < 0.9) return "󰂋";
            return "󰂄";
        }

        if (device.state === QSSU.UPowerDeviceState.FullyCharged)
            return "󰂄";

        if (pct < 0.1) return "󰁺";
        if (pct < 0.2) return "󰁻";
        if (pct < 0.3) return "󰁼";
        if (pct < 0.4) return "󰁽";
        if (pct < 0.5) return "󰁾";
        if (pct < 0.6) return "󰁿";
        if (pct < 0.7) return "󰂀";
        if (pct < 0.8) return "󰂁";
        if (pct < 0.9) return "󰂂";
        return "󰁹";
    }

    function _stateLabel(): string {
        if (!device)
            return "Inconnu";

        switch (device.state) {
        case QSSU.UPowerDeviceState.Charging:
            return "En charge";
        case QSSU.UPowerDeviceState.Discharging:
            return "En décharge";
        case QSSU.UPowerDeviceState.FullyCharged:
            return "Chargée";
        case QSSU.UPowerDeviceState.Empty:
            return "Vide";
        case QSSU.UPowerDeviceState.PendingCharge:
            return "Charge en attente";
        case QSSU.UPowerDeviceState.PendingDischarge:
            return "Décharge en attente";
        default:
            return "Inconnu";
        }
    }

    function _timeRemaining(): string {
        if (!device)
            return "";

        let seconds = 0;
        let label = "";

        if (device.state === QSSU.UPowerDeviceState.Charging
                || device.state === QSSU.UPowerDeviceState.PendingCharge) {
            seconds = device.timeToFull;
            label = "Chargée dans";
        } else if (device.state === QSSU.UPowerDeviceState.Discharging) {
            seconds = device.timeToEmpty;
            label = "Vide dans";
        } else {
            return "";
        }

        if (seconds <= 0)
            return "";

        const h = Math.floor(seconds / 3600);
        const m = Math.floor((seconds % 3600) / 60);

        if (h > 0 && m > 0)
            return `${label} ${h}h ${m}min`;
        if (h > 0)
            return `${label} ${h}h`;
        return `${label} ${m}min`;
    }

    function _healthColor(): color {
        const h = device?.healthPercentage ?? 0;
        if (h >= 80) return Colors.base0B;
        if (h >= 60) return Colors.base0A;
        return Colors.base08;
    }
}
