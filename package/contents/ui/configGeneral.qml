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
    property alias cfg_percentPosition: positionCombo.currentIndex
    property alias cfg_colorFill: colorCheck.checked
    property alias cfg_lowThreshold: lowSpin.value
    property alias cfg_showDeviceList: deviceCheck.checked

    Kirigami.FormLayout {
        QQC2.ComboBox {
            id: positionCombo
            Kirigami.FormData.label: i18n("Percentage:")
            model: [i18n("Hidden"), i18n("Next to the battery"), i18n("Inside the battery")]
        }

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
