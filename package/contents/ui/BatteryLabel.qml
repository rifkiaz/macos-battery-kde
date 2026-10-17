/*
 * SPDX-FileCopyrightText: 2026 Rifki
 * SPDX-License-Identifier: GPL-2.0-or-later
 */
import QtQuick

// Percentage label shown inside the battery, with an optional bolt
Row {
    id: root

    property alias text: label.text
    property color color: "white"
    property bool charging: false
    property int pixelSize: 12
    property string fontFamily: ""

    spacing: Math.round(pixelSize * 0.05)

    Bolt {
        visible: root.charging
        anchors.verticalCenter: parent.verticalCenter
        height: Math.round(root.pixelSize * 0.95)
        width: Math.round(height * 0.62)
        color: root.color
    }

    Text {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        color: root.color
        font.family: root.fontFamily
        font.pixelSize: root.pixelSize
        font.weight: Font.Bold
        font.letterSpacing: -0.3
        renderType: Text.QtRendering
    }
}
