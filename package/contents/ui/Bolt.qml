/*
 * SPDX-FileCopyrightText: 2026 Rifki
 * SPDX-License-Identifier: GPL-2.0-or-later
 */
import QtQuick
import QtQuick.Shapes

// Lightning bolt drawn in a 10x16 box and scaled to the item's size.
// The optional outline is drawn behind the bolt, so it never makes the
// bolt itself thinner.
Item {
    id: root

    property color color: "white"
    property color outline: "transparent"
    property real outlineWidth: 0

    readonly property string boltPath: "M 6.3 0 L 0.2 9.3 L 4.5 9.3 L 3.5 16 L 9.8 6.5 L 5.4 6.5 Z"

    Shape {
        anchors.fill: parent
        visible: root.outlineWidth > 0
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            scale: Qt.size(root.width / 10, root.height / 16)
            fillColor: root.outline
            strokeColor: root.outline
            // Half of the stroke lies inside the bolt, hidden by it
            strokeWidth: root.outlineWidth * 2
            joinStyle: ShapePath.RoundJoin
            PathSvg { path: root.boltPath }
        }
    }

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            scale: Qt.size(root.width / 10, root.height / 16)
            fillColor: root.color
            strokeColor: "transparent"
            strokeWidth: -1
            PathSvg { path: root.boltPath }
        }
    }
}
