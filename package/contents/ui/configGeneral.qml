/*
 * SPDX-FileCopyrightText: 2026 Rifki
 * SPDX-License-Identifier: GPL-2.0-or-later
 */
import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property int cfg_percentPosition
    property alias cfg_iconSize: sizeSpin.value
    property alias cfg_iconAspect: aspectSpin.value
    property alias cfg_textSize: textSpin.value
    property alias cfg_colorFill: colorCheck.checked
    property alias cfg_lowThreshold: lowSpin.value
    property alias cfg_showDeviceList: deviceCheck.checked

    Kirigami.FormLayout {
        QQC2.ComboBox {
            id: positionCombo
            Kirigami.FormData.label: i18n("Percentage:")
            textRole: "text"
            valueRole: "value"
            model: [
                { text: i18n("Hidden"), value: 0 },
                { text: i18n("Left of the battery"), value: 1 },
                { text: i18n("Inside the battery"), value: 2 },
                { text: i18n("Right of the battery"), value: 3 }
            ]
            Component.onCompleted: currentIndex = Math.max(0, indexOfValue(cfg_percentPosition))
            onActivated: cfg_percentPosition = currentValue
        }

        QQC2.SpinBox {
            id: textSpin
            Kirigami.FormData.label: i18n("Percentage text size:")
            enabled: cfg_percentPosition === 1 || cfg_percentPosition === 3
            from: 50
            to: 200
            stepSize: 10
            textFromValue: (value, locale) => i18n("%1%", value)
            valueFromText: (text, locale) => parseInt(text)
        }

        Item { Kirigami.FormData.isSection: true }

        QQC2.SpinBox {
            id: sizeSpin
            Kirigami.FormData.label: i18n("Battery height:")
            from: 50
            to: 250
            stepSize: 10
            textFromValue: (value, locale) => i18n("%1%", value)
            valueFromText: (text, locale) => parseInt(text)
        }

        QQC2.SpinBox {
            id: aspectSpin
            Kirigami.FormData.label: i18n("Battery width:")
            from: 140
            to: 350
            stepSize: 5
            textFromValue: (value, locale) => i18n("%1% of height", value)
            valueFromText: (text, locale) => parseInt(text)
        }

        QQC2.Button {
            text: i18n("Reset size")
            icon.name: "edit-undo"
            onClicked: {
                sizeSpin.value = 100;
                aspectSpin.value = 215;
                textSpin.value = 100;
            }
        }

        Item { Kirigami.FormData.isSection: true }

        QQC2.CheckBox {
            id: colorCheck
            Kirigami.FormData.label: i18n("Colors:")
            text: i18n("Green while charging, red when low")
        }

        QQC2.SpinBox {
            id: lowSpin
            Kirigami.FormData.label: i18n("Low battery level:")
            from: 5
            to: 50
            stepSize: 5
            textFromValue: (value, locale) => i18n("%1%", value)
            valueFromText: (text, locale) => parseInt(text)
        }

        QQC2.CheckBox {
            id: deviceCheck
            Kirigami.FormData.label: i18n("Popup:")
            text: i18n("Show connected devices (mouse, keyboard, …)")
        }
    }
}
