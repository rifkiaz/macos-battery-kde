/*
 * SPDX-FileCopyrightText: 2026 Rifki
 * SPDX-License-Identifier: GPL-2.0-or-later
 *
 * macOS-style battery glyph. Uses only plain Qt Quick so it can be
 * previewed outside Plasma; colors are passed in by the caller.
 */
import QtQuick
import QtQuick.Shapes

Item {
    id: root

    property real percent: 0
    property bool present: true
    property bool charging: false
    property bool showPercentInside: true
    property bool colorize: true
    property int lowThreshold: 20

    property color foreground: "white"
    // Color used to "cut out" the label where it overlaps the fill
    property color knockout: "black"
    property color chargingColor: "#30D158"
    property color lowColor: "#FF453A"
    property string fontFamily: ""

    readonly property real level: present ? Math.max(0, Math.min(100, percent)) : 0
    readonly property bool low: present && !charging && level <= lowThreshold
    readonly property color fillColor: colorize && charging ? chargingColor
                                     : colorize && low ? lowColor
                                     : foreground
    readonly property color outlineColor: Qt.rgba(foreground.r, foreground.g, foreground.b, 0.4)

    readonly property real stroke: Math.max(1, Math.round(height * 0.07))
    readonly property real inset: stroke + Math.max(1, Math.round(height * 0.08))
    readonly property real nubWidth: Math.max(2, Math.round(height * 0.12))

    implicitHeight: 20
    implicitWidth: Math.round(implicitHeight * 2.15)

    Rectangle {
        id: body
        width: root.width - root.nubWidth - Math.max(1, Math.round(root.height * 0.04))
        height: root.height
        radius: height * 0.3
        color: "transparent"
        border.width: root.stroke
        border.color: root.outlineColor
        antialiasing: true

        Rectangle {
            id: fill
            readonly property real maxWidth: body.width - 2 * root.inset
            x: root.inset
            y: root.inset
            height: body.height - 2 * root.inset
            width: root.level <= 0 ? 0 : Math.max(height * 0.3, maxWidth * root.level / 100)
            radius: Math.max(1, body.radius - root.inset)
            color: root.fillColor
            antialiasing: true
            Behavior on width { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
            Behavior on color { ColorAnimation { duration: 250 } }
        }

        // Label drawn in the foreground color over the empty part...
        BatteryLabel {
            id: baseLabel
            anchors.centerIn: parent
            visible: root.showPercentInside
            color: root.foreground
            text: root.present ? Math.round(root.level).toString() : "–"
            charging: root.charging
            pixelSize: Math.round(Math.min(body.height * 0.6, body.width * 0.32))
            fontFamily: root.fontFamily
        }

        // ...and in the knockout color where it overlaps the fill.
        Item {
            visible: root.showPercentInside
            x: fill.x
            y: 0
            width: fill.width
            height: body.height
            clip: true

            BatteryLabel {
                x: baseLabel.x - parent.x
                y: baseLabel.y
                color: root.knockout
                text: baseLabel.text
                charging: baseLabel.charging
                pixelSize: baseLabel.pixelSize
                fontFamily: root.fontFamily
            }
        }

        // Without the inside label, show a centered bolt while charging
        Bolt {
            visible: root.charging && !root.showPercentInside
            anchors.centerIn: parent
            height: Math.round(body.height * 0.8)
            width: Math.round(height * 0.62)
            color: root.foreground
            outline: root.knockout
            outlineWidth: 1.6
        }
    }

    // Terminal nub, rounded on the right side only
    Item {
        x: root.width - root.nubWidth
        anchors.verticalCenter: body.verticalCenter
        width: root.nubWidth
        height: Math.round(root.height * 0.36)
        clip: true

        Rectangle {
            x: -parent.width
            width: parent.width * 2
            height: parent.height
            radius: parent.width
            color: root.outlineColor
            antialiasing: true
        }
    }
}
