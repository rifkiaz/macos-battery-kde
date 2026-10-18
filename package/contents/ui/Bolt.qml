/*
 * SPDX-FileCopyrightText: 2026 Rifki
 * SPDX-License-Identifier: GPL-2.0-or-later
 */
import QtQuick
import QtQuick.Shapes

// Lightning bolt that fills the item's size. The points are computed from
// the item size directly (ShapePath.scale is not honoured by every Qt
// renderer). The optional outline is drawn behind the bolt, so it never
// makes the bolt itself thinner.
Item {
    id: root

    property color color: "white"
    property color outline: "transparent"
    property real outlineWidth: 0

    // Bolt outline in a 10x16 box
    readonly property var points: [
        [6.3, 0], [0.2, 9.3], [4.5, 9.3], [3.5, 16], [9.8, 6.5], [5.4, 6.5]
    ]
    readonly property real sx: width / 10
    readonly property real sy: height / 16

    component BoltPath: ShapePath {
        startX: root.points[0][0] * root.sx
        startY: root.points[0][1] * root.sy
        PathLine { x: root.points[1][0] * root.sx; y: root.points[1][1] * root.sy }
        PathLine { x: root.points[2][0] * root.sx; y: root.points[2][1] * root.sy }
        PathLine { x: root.points[3][0] * root.sx; y: root.points[3][1] * root.sy }
        PathLine { x: root.points[4][0] * root.sx; y: root.points[4][1] * root.sy }
        PathLine { x: root.points[5][0] * root.sx; y: root.points[5][1] * root.sy }
        PathLine { x: root.points[0][0] * root.sx; y: root.points[0][1] * root.sy }
    }

    Shape {
        anchors.fill: parent
        visible: root.outlineWidth > 0
        // Antialiased without an offscreen layer, crisp at any scale factor
        preferredRendererType: Shape.CurveRenderer

        BoltPath {
            fillColor: root.outline
            strokeColor: root.outline
            // Half of the stroke lies inside the bolt, hidden by it
            strokeWidth: root.outlineWidth * 2
            joinStyle: ShapePath.RoundJoin
        }
    }

    Shape {
        anchors.fill: parent
        // Antialiased without an offscreen layer, crisp at any scale factor
        preferredRendererType: Shape.CurveRenderer

        BoltPath {
            fillColor: root.color
            strokeColor: "transparent"
            strokeWidth: -1
        }
    }
}
