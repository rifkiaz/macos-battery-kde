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
    readonly property bool besideText: root.percentPosition === 1

    readonly property int iconHeight: vertical
        ? Math.round(Math.min(width * 0.8, Kirigami.Units.gridUnit * 2.6) / 2.15)
        : Math.round(Math.max(10, Math.min(height * 0.5, Kirigami.Units.gridUnit * 1.25)))

    Layout.minimumWidth: vertical ? 0 : grid.implicitWidth
    Layout.preferredWidth: vertical ? -1 : grid.implicitWidth
    Layout.minimumHeight: vertical ? grid.implicitHeight : 0
    Layout.preferredHeight: vertical ? grid.implicitHeight : -1

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton
    onClicked: root.expanded = !root.expanded

    GridLayout {
        id: grid
        anchors.centerIn: parent
        flow: compact.vertical ? GridLayout.TopToBottom : GridLayout.LeftToRight
        columns: compact.vertical ? 1 : 2
        rowSpacing: Math.round(Kirigami.Units.smallSpacing / 2)
        columnSpacing: Kirigami.Units.smallSpacing

        Text {
            visible: compact.besideText
            Layout.alignment: Qt.AlignCenter
            text: root.hasBattery ? i18n("%1%", Math.round(root.percent)) : "–"
            color: Kirigami.Theme.textColor
            font.family: Kirigami.Theme.defaultFont.family
            font.pixelSize: Math.round(compact.iconHeight * 0.72)
            font.weight: Font.Medium
        }

        BatteryIcon {
            Layout.alignment: Qt.AlignCenter
            Layout.preferredHeight: compact.iconHeight
            Layout.preferredWidth: Math.round(compact.iconHeight * 2.15)
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
    }
}
