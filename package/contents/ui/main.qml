/*
 * SPDX-FileCopyrightText: 2026 Rifki
 * SPDX-License-Identifier: GPL-2.0-or-later
 */
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as P5Support
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    readonly property var batteryData: pmSource.data["Battery"] || ({})
    readonly property var acData: pmSource.data["AC Adapter"] || ({})

    readonly property bool hasBattery: batteryData["Has Battery"] === true
    readonly property real percent: hasBattery ? Number(batteryData["Percent"] || 0) : 0
    readonly property string batteryState: batteryData["State"] || ""
    readonly property bool pluggedIn: acData["Plugged in"] === true
    readonly property bool charging: batteryState === "Charging"
    readonly property bool fullyCharged: batteryState === "FullyCharged"
    readonly property real remainingMsec: Number(batteryData["Smoothed Remaining msec"]
                                                 || batteryData["Remaining msec"] || 0)

    // Every individual battery (laptop packs plus peripherals such as mice)
    readonly property var devices: pmSource.sources
        .filter(source => /^Battery\d+$/.test(source))
        .sort()

    readonly property int percentPosition: Plasmoid.configuration.percentPosition
    readonly property real iconScale: Plasmoid.configuration.iconSize / 100
    readonly property real iconAspect: Plasmoid.configuration.iconAspect / 100
    readonly property real textScale: Plasmoid.configuration.textSize / 100
    readonly property bool colorFill: Plasmoid.configuration.colorFill
    readonly property int lowThreshold: Plasmoid.configuration.lowThreshold
    readonly property bool showDeviceList: Plasmoid.configuration.showDeviceList

    function formatDuration(msec) {
        const totalMinutes = Math.round(msec / 60000);
        const hours = Math.floor(totalMinutes / 60);
        const minutes = totalMinutes % 60;
        if (hours > 0) {
            return i18nc("hours and minutes", "%1 h %2 min", hours, minutes);
        }
        return i18nc("minutes", "%1 min", minutes);
    }

    readonly property string statusText: {
        if (!hasBattery) {
            return i18n("No battery found");
        }
        if (fullyCharged) {
            return i18n("Fully charged");
        }
        if (charging) {
            return remainingMsec > 0
                ? i18n("Charging, %1 until full", formatDuration(remainingMsec))
                : i18n("Charging");
        }
        if (pluggedIn) {
            return i18n("Plugged in, not charging");
        }
        return remainingMsec > 0
            ? i18n("%1 remaining", formatDuration(remainingMsec))
            : i18n("On battery");
    }

    readonly property string powerSourceText: pluggedIn ? i18n("Power Adapter") : i18n("Battery")

    function deviceIcon(type) {
        switch (type) {
        case "Mouse": return "input-mouse";
        case "Keyboard": return "input-keyboard";
        case "Phone": return "phone";
        case "GamingInput": return "input-gaming";
        case "Headset": case "Headphones": return "audio-headset";
        case "Ups": return "battery-ups";
        case "Battery": return "computer-laptop";
        default: return "battery";
        }
    }

    Plasmoid.icon: "battery"
    Plasmoid.status: hasBattery ? PlasmaCore.Types.ActiveStatus : PlasmaCore.Types.PassiveStatus

    toolTipMainText: hasBattery ? i18n("Battery: %1%", Math.round(percent)) : i18n("Battery")
    toolTipSubText: statusText

    switchWidth: Kirigami.Units.gridUnit * 10
    switchHeight: Kirigami.Units.gridUnit * 6

    compactRepresentation: CompactRepresentation {}
    fullRepresentation: FullRepresentation {}

    P5Support.DataSource {
        id: pmSource
        engine: "powermanagement"
        connectedSources: sources
        onSourceAdded: source => connectSource(source)
        onSourceRemoved: source => disconnectSource(source)
    }
}
