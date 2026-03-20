import QtQuick

import "../singletons"

Text {
    enum Variant {
        Title,
        Subtitle,
        Bigtext,
        Text,
        Subtext
    }

    property int variant: DesktopText.Text
    
    property int _innerPadding: switch (variant) {
        case DesktopText.Title:
        case DesktopText.Bigtext:
            return 0;
        case DesktopText.Subtitle:
        case DesktopText.Text:
            return 4;
        case DesktopText.Subtext:
            return 8;
        default:
            return 8;
    }

    color: Colors.base05
    
    font {
        family: Fonts.monospace
        pixelSize: Fonts.ptToPx(Fonts.desktopSize, topBar.screen) - _innerPadding
        weight: switch (variant) {
            case DesktopText.Title:
            case DesktopText.Subtitle:
                return Font.Bold;
            case DesktopText.Bigtext:
            case DesktopText.Text:
            case DesktopText.Subtext:
                return Font.Normal;
            default:
                return Font.Normal;
        }
    }
}
