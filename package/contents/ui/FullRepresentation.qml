/*
 * SPDX-FileCopyrightText: 2026 Rifki
 * SPDX-License-Identifier: GPL-2.0-or-later
 */
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami

Item {
    id: full

    readonly property int pad: Kirigami.Units.largeSpacing

    Layout.minimumWidth: Kirigami.Units.gridUnit * 13
    Layout.preferredWidth: Kirigami.Units.gridUnit * 17
    Layout.minimumHeight: content.implicitHeight + pad * 2
    Layout.preferredHeight: content.implicitHeight + pad * 2

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: full.pad
        spacing: Kirigami.Units.smallSpacing

        RowLayout {
            Layout.fillWidth: true

            Kirigami.Heading {
                Layout.fillWidth: true
                level: 4
                text: i18n("Battery")
                font.weight: Font.DemiBold
            }

            PlasmaComponents3.Label {
                text: root.powerSourceText
                opacity: 0.6
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.smallSpacing
            spacing: Kirigami.Units.largeSpacing

            BatteryIcon {
                id: bigIcon
                Layout.preferredHeight: Math.round(Kirigami.Units.gridUnit * 1.9)
                Layout.preferredWidth: Math.round(Layout.preferredHeight * root.iconAspect)
                percent: root.percent
                present: root.hasBattery
                charging: root.charging
                showPercentInside: false
                colorize: root.colorFill
                lowThreshold: root.lowThreshold
                foreground: Kirigami.Theme.textColor
                knockout: Kirigami.Theme.backgroundColor
            }

            Text {
                Layout.fillWidth: true
                text: root.hasBattery ? i18n("%1%", Math.round(root.percent)) : "–"
                color: Kirigami.Theme.textColor
                font.family: Kirigami.Theme.defaultFont.family
                font.pixelSize: Math.round(Kirigami.Units.gridUnit * 2.2)
                font.weight: Font.Light
            }
        }

        PlasmaComponents3.Label {
            Layout.fillWidth: true
            text: root.statusText
            opacity: 0.75
            wrapMode: Text.WordWrap
        }

        Kirigami.Separator {
            visible: deviceList.visible
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.smallSpacing
            Layout.bottomMargin: Kirigami.Units.smallSpacing
        }

        ColumnLayout {
            id: deviceList
            visible: root.showDeviceList && root.devices.length > 1
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            Repeater {
                model: root.devices

                RowLayout {
                    id: deviceRow
                    readonly property var info: pmSource.data[modelData] || ({})
                    readonly property real level: Number(info["Percent"] || 0)
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    Kirigami.Icon {
                        Layout.preferredWidth: Kirigami.Units.iconSizes.small
                        Layout.preferredHeight: Kirigami.Units.iconSizes.small
                        source: root.deviceIcon(deviceRow.info["Type"] || "")
                    }

                    PlasmaComponents3.Label {
                        Layout.fillWidth: true
                        text: deviceRow.info["Pretty Name"] || modelData
                        elide: Text.ElideRight
                    }

                    PlasmaComponents3.Label {
                        text: i18n("%1%", Math.round(deviceRow.level))
                        opacity: 0.7
                    }

                    BatteryIcon {
                        Layout.preferredHeight: Math.round(Kirigami.Units.gridUnit * 0.7)
                        Layout.preferredWidth: Math.round(Layout.preferredHeight * root.iconAspect)
                        percent: deviceRow.level
                        charging: deviceRow.info["State"] === "Charging"
                        showPercentInside: false
                        colorize: root.colorFill
                        lowThreshold: root.lowThreshold
                        foreground: Kirigami.Theme.textColor
                        knockout: Kirigami.Theme.backgroundColor
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }
    }
}
