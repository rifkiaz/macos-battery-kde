/*
 * SPDX-FileCopyrightText: 2026 Rifki
 * SPDX-License-Identifier: GPL-2.0-or-later
 */
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami

MouseArea {
    id: compact

    readonly property bool vertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical

    // Automatic size for the panel thickness, then scaled by the user's setting.
    // The battery never grows past the panel thickness.
    readonly property real autoHeight: vertical
        ? Math.min(width * 0.8, Kirigami.Units.gridUnit * 2.6) / root.iconAspect
        : Math.min(height * 0.5, Kirigami.Units.gridUnit * 1.25)
    readonly property int iconHeight: {
        const scaled = Math.max(8, autoHeight * root.iconScale);
        const limit = vertical ? width / root.iconAspect : height;
        return Math.round(Math.min(scaled, limit));
    }
    readonly property int iconWidth: {
        const w = Math.round(iconHeight * root.iconAspect);
        return vertical ? Math.min(w, Math.floor(width)) : w;
    }

    Layout.minimumWidth: vertical ? 0 : grid.implicitWidth
    Layout.preferredWidth: vertical ? -1 : grid.implicitWidth
    Layout.minimumHeight: vertical ? grid.implicitHeight : 0
    Layout.preferredHeight: vertical ? grid.implicitHeight : -1

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton
    onClicked: root.expanded = !root.expanded

    component PercentText: Text {
        Layout.alignment: Qt.AlignCenter
        text: root.hasBattery ? i18n("%1%", Math.round(root.percent)) : "–"
        color: Kirigami.Theme.textColor
        font.family: Kirigami.Theme.defaultFont.family
        font.pixelSize: Math.max(6, Math.round(compact.iconHeight * 0.75 * root.textScale))
        font.weight: Font.Medium
    }

    GridLayout {
        id: grid
        anchors.centerIn: parent
        flow: compact.vertical ? GridLayout.TopToBottom : GridLayout.LeftToRight
        columns: compact.vertical ? 1 : 3
        rows: compact.vertical ? 3 : 1
        rowSpacing: Math.round(Kirigami.Units.smallSpacing / 2)
        columnSpacing: Kirigami.Units.smallSpacing

        // Left (or top, in a vertical panel)
        PercentText {
            visible: root.percentPosition === 1
        }

        BatteryIcon {
            Layout.alignment: Qt.AlignCenter
            Layout.preferredHeight: compact.iconHeight
            Layout.preferredWidth: compact.iconWidth
            percent: root.percent
            present: root.hasBattery
            charging: root.charging
            showPercentInside: root.percentPosition === 2
            colorize: root.colorFill
            lowThreshold: root.lowThreshold
            foreground: Kirigami.Theme.textColor
            knockout: Kirigami.Theme.backgroundColor
            fontFamily: Kirigami.Theme.defaultFont.family
            opacity: compact.containsMouse ? 1 : 0.92
        }

        // Right (or bottom, in a vertical panel)
        PercentText {
            visible: root.percentPosition === 3
        }
    }
}
