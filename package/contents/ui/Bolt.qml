/*
 * SPDX-FileCopyrightText: 2026 Rifki
 * SPDX-License-Identifier: GPL-2.0-or-later
 */
import QtQuick
import QtQuick.Shapes

// Lightning bolt drawn in a 10x16 box and scaled to the item's size
Item {
    id: root

    property color color: "white"
    property color outline: "transparent"
    property real outlineWidth: 0

    Shape {
        anchors.fill: parent
        layer.enabled: true
        layer.samples: 4
        layer.smooth: true

        ShapePath {
            scale: Qt.size(root.width / 10, root.height / 16)
            fillColor: root.color
            strokeColor: root.outlineWidth > 0 ? root.outline : "transparent"
            strokeWidth: root.outlineWidth > 0 ? root.outlineWidth : -1
            joinStyle: ShapePath.RoundJoin
            PathSvg { path: "M 6.2 0 L 0.4 9.2 L 4.6 9.2 L 3.6 16 L 9.6 6.6 L 5.4 6.6 Z" }
        }
    }
}
